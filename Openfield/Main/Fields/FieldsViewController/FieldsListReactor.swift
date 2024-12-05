//
//  FieldsListReactor.swift
//  Openfield
//
//  Created by Daniel Kochavi on 26/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import ReactorKit
import Resolver
import RxSwift
import Then

final class FieldsListReactor: Reactor {
  var initialState: FieldsListReactor.State = .init(
    sections: [],
    presentedSections: [FieldsListSection(items: Array(1 ... 6).map { _ in FieldItem.loadingCell }
        .enumerated().map { FieldElement(type: $0.1, identity: $0.0) },
      type: .fields,
      id: UUID().uuidString)],
    highlightsLoading: true,
    fieldsLoading: true,
    searchActive: false,
    highlights: [],
    fieldList: [],
    sortingType: FieldListSortingType.latest,
    searchTerm: "",
    searchingFields: false,
    noInsights: false
  )

  let disposeBag = DisposeBag()

  let fieldsUsecase: FieldsUsecaseProtocol
  let insightsFromDateUsecase: InsightsFromDateUsecaseProtocol
  let fieldLastReadUsecase: FieldLastReadUsecase
  let getHighlightsForFieldsUseCase: GetHighlightsForFieldsUseCaseProtocol
  let getImagesIntervalSinceNowUseCase: GetImagesIntervalSinceNowUseCaseProtocol
  let getInsightIntervalSinceNowUseCase: GetInsightIntervalSinceNowUseCaseProtocol
  let getHighlightItemsLimitUseCase: GetHighlightItemsLimitUseCaseProtocol
  let getHighlightDaysLimitUseCase: GetHighlightDaysLimitUseCaseProtocol
  let latestHighlightsByFarmsUseCase: LatestHighlightsByFarmsUseCaseProtocol
  let farmFilter: FarmFilterProtocol

  let FieldsDelayDuration = 1500
  let highlightsDelayDuration = 1000

  init(fieldsUsecase: FieldsUsecaseProtocol, insightsFromDateUsecase: InsightsFromDateUsecaseProtocol, fieldLastReadUsecase: FieldLastReadUsecase, getHighlightsForFieldsUseCase: GetHighlightsForFieldsUseCaseProtocol, farmFilter: FarmFilterProtocol,
       getImagesIntervalSinceNowUseCase: GetImagesIntervalSinceNowUseCaseProtocol,
       getInsightIntervalSinceNowUseCase: GetInsightIntervalSinceNowUseCaseProtocol,
       getHighlightItemsLimitUseCase: GetHighlightItemsLimitUseCaseProtocol,
       getHighlightDaysLimitUseCase: GetHighlightDaysLimitUseCaseProtocol,
       latestHighlightsByFarmsUseCase: LatestHighlightsByFarmsUseCaseProtocol)
  {
    self.fieldsUsecase = fieldsUsecase
    self.insightsFromDateUsecase = insightsFromDateUsecase
    self.fieldLastReadUsecase = fieldLastReadUsecase
    self.getHighlightsForFieldsUseCase = getHighlightsForFieldsUseCase
    self.latestHighlightsByFarmsUseCase = latestHighlightsByFarmsUseCase
    self.farmFilter = farmFilter
    self.getImagesIntervalSinceNowUseCase = getImagesIntervalSinceNowUseCase
    self.getInsightIntervalSinceNowUseCase = getInsightIntervalSinceNowUseCase
    self.getHighlightItemsLimitUseCase = getHighlightItemsLimitUseCase
    self.getHighlightDaysLimitUseCase = getHighlightDaysLimitUseCase
    let insightsFromDate = getInsightIntervalSinceNowUseCase.insightIntervalSinceNow()
    let insights = insightsFromDateUsecase.getInsights(insightsFromDate: insightsFromDate, limit: nil)
    let imagesFromDate = getImagesIntervalSinceNowUseCase.imagesIntervalSinceNow()

    Observable.combineLatest(
      fieldsUsecase.getFieldsWithImages(imagesFromDate: imagesFromDate),
      insights,
      fieldLastReadUsecase.fieldsLastReadStream(),
      farmFilter.farms
    ).flatMapLatest { fields, insights, fieldsLastRead, farms -> Observable<Action> in
      let selectedFarms = farms.filter { $0.isSelected }
      let filteredFields = fields.filter { selectedFarms.compactMap { $0.name }.contains($0.farmName) }
      let fieldsIds = filteredFields.map { Int($0.id) }
      
      let limit = getHighlightItemsLimitUseCase.highlightItemsLimit()
      let highlightsLimitDate = Date().minus(component: .day, value: getHighlightDaysLimitUseCase.highlightDaysLimit())
        
      return latestHighlightsByFarmsUseCase.getHighlightsForFarms(
        limit: limit,
        fromDate: highlightsLimitDate,
        fieldsIds: fieldsIds
      )
      .map { [weak self] highlights in
        guard let self = self else {return .nothing}
          let fieldCellContents = filteredFields.map { field in
              let insightsForField = insights.filter { $0.fieldId == field.id }
              return FieldCellContent(
                  field: field,
                  latestImage: field.coverImage?.url,
                  report: self.getReports(insights: insightsForField, field: field),
                  fieldLastRead: fieldsLastRead[field.id]
              )
          }
          return .setSections(fields: fieldCellContents, highlights: highlights)
      }
    }
    .bind(to: action)
    .disposed(by: disposeBag)
      
    insights
      .map { insights -> Bool in
        insights.filter { ![WelcomeInsightsIds.irrigation.rawValue, WelcomeInsightsIds.locationInsight.rawValue].contains($0.uid) }.isEmpty
      }
      .map { .updateNoInsights(noInsights: $0) }
      .bind(to: action)
      .disposed(by: disposeBag)
  }

  private func getReports(insights: [Insight], field: Field) -> FieldCellReport {
    let currentDate = Date()
    let calendar = Calendar.current
    let sixDaysAgo = calendar.date(byAdding: .day, value: -6, to: currentDate)
    let sixDaysAgoStartOfDay = calendar.startOfDay(for: sixDaysAgo!)
    let filteredInsightsForField = insights.filter { $0.publishDate.compare(sixDaysAgoStartOfDay) == .orderedDescending }
    if !filteredInsightsForField.isEmpty {
      let insightsGroupedByDate: [String: [Insight]] = Dictionary(grouping: filteredInsightsForField) { insight -> String in
        DateFormatter.iso8601DateOnly.string(from: insight.publishDate)
      }
      let insightsGroupedByDateSorted = insightsGroupedByDate.sorted { $0.key < $1.key }
      let lastInsights = insightsGroupedByDateSorted.last!.value.sorted { $0.publishDate > $1.publishDate }
      let insightsReport = lastInsights.map { $0.displayName }
      return .insigntsReport(insights: NSOrderedSet(array: insightsReport).array as! [String], date: lastInsights.first?.publishDate)
    } else {
      let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: currentDate)
      let twoDaysAgoStartOfDay = calendar.startOfDay(for: twoDaysAgo!)
      let lastImages = field.imageGroups.filter { $0.date.compare(twoDaysAgoStartOfDay) == .orderedDescending }
      let lastImagesSorted = lastImages.sorted { $0.date < $1.date }
      if !lastImagesSorted.isEmpty {
        return .imagesReport(date: lastImagesSorted.last?.date)
      } else {
        return .noReport
      }
    }
  }

  enum FieldCellReport {
    case insigntsReport(insights: [String], date: Date?)
    case imagesReport(date: Date?)
    case noReport
  }

  enum Action {
    case nothing
    case setSorting(sortingType: FieldListSortingType)
    case updateNoInsights(noInsights: Bool)
    case changeSearchTerm(text: String)
    case clickedField(fieldItem: FieldElement, navigation: (Field) -> Void)
    case clickInsight(index: Int, navigation: (Insight) -> Void)
    case setSearchActive(active: Bool)
    case navigateHighlights(navigation: (Int?, String?) -> Void)
    case farmSelectionClicked
    case settingsButtonClicked
    case farmsSelected
    case highlightEndDrag(index: Int)
    case analyticsScroll(reachesEnd: Bool)
    case navigateSorting(navigation: (FieldListSortingType) -> Void)
    case setSections(fields: [FieldCellContent], highlights: [HighlightItem])
  }
    
  enum Mutation {
    case setHighlightsLoading(loading: Bool)
    case setFieldsLoading(loading: Bool)
    case setItemClicked(v: Void)
    case setSorting(sortingType: FieldListSortingType)
    case setNoInsights(noInsights: Bool)
    case setSearch(searchActive: Bool, searchTerms: String)
    case setSections(fields: [FieldCellContent], highlights: [HighlightItem])

  }

  struct State: Then {
    var sections: [FieldsListSection]
    var presentedSections: [FieldsListSection]
    var highlightsLoading: Bool
    var fieldsLoading: Bool
    var searchActive: Bool
    var highlights: [HighlightItem]
    var fieldList: [FieldCellContent]
    var sortingType: FieldListSortingType
    var searchTerm: String
    var searchingFields: Bool
    var noInsights: Bool
  }

  func mutate(action: FieldsListReactor.Action) -> Observable<FieldsListReactor.Mutation> {
    switch action {
    case let .setSections(fields, highlights):
        return Observable.concat(
            Observable.just(.setSections(fields: fields, highlights: highlights)),
            Observable.just(.setFieldsLoading(loading: false)),
            Observable.just(Mutation.setHighlightsLoading(loading: false)))
   
    case let .setSorting(sortingType):
      onSortSaved(newSortingType: sortingType)
      return .just(.setSorting(sortingType: sortingType))

    case let .updateNoInsights(noInsights: noInisghts):
      return .just(.setNoInsights(noInsights: noInisghts))

    case let .changeSearchTerm(text):
      guard !currentState.fieldsLoading else { return .empty() }
      onSearchType()
      return .just(Mutation.setSearch(searchActive: true, searchTerms: text))

    case let .clickedField(fieldItem, navigation):

      switch fieldItem.type {
      case let .fieldCellContent(fieldContent):
        PerformanceManager.shared.startTrace(origin: .fields_list, target: .field)
        onFieldClick(fieldContent: fieldContent)
        navigation(fieldContent.field)
        return fieldLastReadUsecase.updateFieldLastRead(id: fieldContent.field.id, lastRead: fieldContent.fieldLastRead).map { .setItemClicked(v: $0) }
      case .loadingCell:
        return .empty()
      case .fieldHighlightContent(fieldHighlightContent: _):
        return .empty()
      }

    case let .clickInsight(index: index, navigation: navigation):
      guard currentState.highlights.indices.contains(index) else { return Observable.empty() }

      var highlightedInsight: Insight?
      switch currentState.highlights[index].type {
      case let .insight(insight, _):
        if insight is IrrigationInsight {
          PerformanceManager.shared.startTrace(origin: .fields_list, target: .irrigation_insight)
        } else {
          PerformanceManager.shared.startTrace(origin: .fields_list, target: .location_insight)
        }
        highlightedInsight = insight
        navigation(insight)
      case .empty:
        break
      }
      if let insight = highlightedInsight {
        onHighlightClick(index: index, insight: insight)
      }
      return Observable.empty()

    case let .setSearchActive(active: active):
      guard !currentState.fieldsLoading else { return .empty() }
      if active {
        onSearchClick()
      } else {
        onSearchBackClick()
      }
      return .just(Mutation.setSearch(searchActive: active, searchTerms: active ? currentState.searchTerm : ""))

    case let .navigateHighlights(navigation: navigation):
      PerformanceManager.shared.startTrace(origin: .fields_list, target: .highlights_list)
      onShowAllHighlightsClick()
      navigation(nil, nil)
      return Observable.empty()
    case .farmSelectionClicked:
      onFarmsSelectionClick()
      return Observable.empty()
    case .settingsButtonClicked:
      onSettingClick()
      return Observable.empty()
    case let .analyticsScroll(reachesEnd):
      onFiledsListScroll(reachesEnd: reachesEnd)
      return Observable.empty()
    case .farmsSelected:
      onFarmSelected()
      return Observable.empty()
    case let .highlightEndDrag(index):
      onHighlightEndDrag(index: index)
      return Observable.empty()
    case let .navigateSorting(navigation: navigation):
      onSortButtonClick()
      navigation(currentState.sortingType)
      return Observable.empty()
    case .nothing:
      return Observable.empty()
    }
  }

  func reduce(state: FieldsListReactor.State, mutation: FieldsListReactor.Mutation) -> FieldsListReactor.State {
    switch mutation {
    case .setItemClicked:
      let newState: State = state
      return newState

    case let .setSections(fields, highlights):
      if (fields.elementsEqual(currentState.fieldList) && 
          highlights.elementsEqual(currentState.highlights)) {
        return state
      }
      
      let sortedFieldElements = getSortedFilteredFields(
        fields: fields,
        sortingType: currentState.sortingType,
        searchTerm: currentState.searchTerm
      ).map { FieldItem.fieldCellContent(fieldCellContent: $0) }
      
      let newSections = buildSections(
        sections: currentState.sections,
        fieldElements: sortedFieldElements,
        highlights: highlights,
        sortingType: currentState.sortingType,
        searchActive: currentState.searchActive
      )
      
      log.debug(".setSections: number of fields = \(fields.count), number of highlights = \(highlights.count), number of sections = \(newSections.count)")
      return state.with {
        $0.fieldList = fields
        $0.highlights = highlights
        $0.sections = newSections
        $0.presentedSections = newSections
      }

    case let .setNoInsights(noInsights):
      return state.with {
        $0.noInsights = noInsights
      }

    case let .setSorting(sortingType):
      let sortedFieldElements = getSortedFilteredFields(fields: currentState.fieldList, sortingType: sortingType, searchTerm: currentState.searchTerm).map { FieldItem.fieldCellContent(fieldCellContent: $0) }
        
        let newSections = buildSections(
            sections: currentState.sections,
            fieldElements: sortedFieldElements,
            highlights: currentState.highlights,
            sortingType: sortingType,
            searchActive: currentState.searchActive
        )
       
      return state.with {
          $0.sortingType = sortingType
          $0.sections = newSections
          $0.presentedSections = newSections
      }
    
    case let .setHighlightsLoading(loading: loading):
      return state.with {
        $0.highlightsLoading = loading
      }
        
    case let .setFieldsLoading(loading: loading):
      return state.with {
        $0.fieldsLoading = loading
      }
        
    case let .setSearch(searchActive: searchActive, searchTerms: searchTerms):
      let filteredFieldElements = getSortedFilteredFields(fields: currentState.fieldList, sortingType: currentState.sortingType, searchTerm: searchTerms).map { FieldItem.fieldCellContent(fieldCellContent: $0) }
        
        let newSections = buildSections(
            sections: currentState.sections,
            fieldElements: filteredFieldElements,
            highlights: currentState.highlights,
            sortingType: currentState.sortingType,
            searchActive: searchActive
        )
        
      return state.with {
          $0.searchTerm = searchTerms
          $0.searchActive = searchActive
          $0.presentedSections = newSections
      }
    }
  }
    
    private func buildSections(
        sections: [FieldsListSection],
        fieldElements: [FieldItem],
        highlights: [HighlightItem],
        sortingType: FieldListSortingType,
        searchActive: Bool
    ) -> [FieldsListSection] {
        var newSections = sections.filter { $0.type != .fields && $0.type != .highlights }
        
        if !searchActive && !highlights.isEmpty {
            newSections.insert(
                FieldsListSection(
                    items: [FieldElement(type: .fieldHighlightContent(fieldHighlightContent: FieldHighlightsContent(highlights: highlights)), identity: .zero)],
                    type: .highlights,
                    id: FieldsListSectionType.highlights.rawValue,
                    header: FieldHeader(leftTitle: R.string.localizable.highlightsRecentHighlights(), rightTitle: R.string.localizable.highlightsShowAll())), at: .zero)
        }
        
        let header: FieldHeader? = searchActive ? nil : FieldHeader(leftTitle: R.string.localizable.fieldFieldsCount(fieldElements.count), rightTitle: getSortingTitle(type: sortingType))
        newSections.append(
            FieldsListSection(
                items: fieldElements.map { item in
                    switch item {
                    case let .fieldCellContent(fieldCellContent):
                        return FieldElement(type: item, identity: fieldCellContent.field.id)
                    case .fieldHighlightContent, .loadingCell:
                        return FieldElement(type: item, identity: .zero)
                    }
                },
                type: .fields,
                id: UUID().uuidString,
                header: header
            )
        )
        
        return newSections
    }

  private func getSortingTitle(type: FieldListSortingType) -> String {
    switch type {
    case .alphanumeric:
      return R.string.localizable.fieldSortingAToZ()
    case .latest:
      return R.string.localizable.fieldSortingLatest()
    case .unread:
      return R.string.localizable.fieldSortingUnread()
    }
  }

  private func getSortedFilteredFields(
    fields: [FieldCellContent],
    sortingType: FieldListSortingType,
    searchTerm: String
  ) -> [FieldCellContent] {
    let filteredFields = fields
      .filter { content -> Bool in
        if (searchTerm.allSatisfy { $0.isWhitespace }) {
          return true
        } else {
          return content.field.name.lowercased().contains(searchTerm.lowercased())
        }
      }
    switch sortingType {
    case .latest:
      return getFieldsSortedByLatest(fields: filteredFields)
    case .alphanumeric:
      return getFieldsSortedByAlphaNumeric(fields: filteredFields)
    case .unread:
      return getFieldsSortedByUnread(fields: filteredFields)
    }
  }

  private func getFieldsSortedByLatest(
    fields: [FieldCellContent]
  ) -> [FieldCellContent] {
    return fields.sorted { field1, field2 in
      compareByLatest(field1: field1, field2: field2) < 0
    }
  }

  private func getFieldsSortedByUnread(
    fields: [FieldCellContent]
  ) -> [FieldCellContent] {
    fields.sorted { field1, field2 in
      let isUnread1 = isUnread(field: field1)
      let isUnread2 = isUnread(field: field2)

      if isUnread1 != isUnread2 {
        return isUnread1 && !isUnread2
      } else {
        let latestComparison = compareByLatest(field1: field1, field2: field2)
        if latestComparison != 0 {
          return latestComparison < 0
        } else {
          return compareByAlphanumeric(field1: field1, field2: field2)
        }
      }
    }
  }

  private func getFieldsSortedByAlphaNumeric(fields: [FieldCellContent]) -> [FieldCellContent] {
    return fields.sorted(by: compareByAlphanumeric)
  }

  private func compareByAlphanumeric(field1: FieldCellContent, field2: FieldCellContent) -> Bool {
    let nameComparison = field1.field.name.localizedStandardCompare(field2.field.name)
    if nameComparison == .orderedSame {
      return field1.field.id < field2.field.id
    }
    return nameComparison == .orderedAscending
  }

  private func compareByLatest(field1: FieldCellContent, field2: FieldCellContent) -> Int {
    let date1 = getReportDate(report: field1.report)
    let date2 = getReportDate(report: field2.report)

    let latestComparison: Int
    switch (date1, date2) {
    case let (date1?, date2?):
      // Both fields have reports; compare their dates
      latestComparison = date2.compare(date1).rawValue
    case (nil, _?):
      // Only field2 has a report, so it should come first
      latestComparison = 1
    case (_?, nil):
      // Only field1 has a report, so it should come first
      latestComparison = -1
    case (nil, nil):
      // Neither field has a report, so they are considered equal in terms of latest report
      latestComparison = 0
    }
    if latestComparison != 0 {
      return latestComparison
    } else {
      return compareByAlphanumeric(field1: field1, field2: field2) ? -1 : 1
    }
  }

  private func isUnread(field: FieldCellContent) -> Bool {
    let reportDate = getReportDate(report: field.report)
    let readTime = field.fieldLastRead?.tsRead
    return reportDate != nil && (readTime == nil || readTime?.isBeforeDate(reportDate!, granularity: .second) == true)
  }

  func getReportDate(report: FieldCellReport) -> Date? {
    switch report {
    case let .insigntsReport(_, date):
      return date
    case let .imagesReport(date):
      return date
    case .noReport:
      return nil
    }
  }

  // MARK: - analytics

  // TODO: we fetch the data from different resources, we need to find way to identify when all data loaded
  // TODO: call it!!
  private func onDataLoaded() {
    EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.fieldsList, .impression, getPageState()))
  }

  private func onFarmsSelectionClick() {
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.fieldsList, "farm_popup", getPageState()))
  }

  private func onFarmSelected() {
    var parameters: [String: String] = getPageState()
    var farmIds: [String]
    do {
      farmIds = try farmFilter.farms.value().map { String($0.id) }
    } catch {
      farmIds = [String]()
    }
   
    parameters["farm_list"] = farmIds.joined(separator: ", ")
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.fieldsList, "farm_selection_save", getPageState()))
  }

  private func onFieldClick(fieldContent: FieldCellContent) {
    EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.fieldsList, .fieldsFieldClick, [
      EventParamKey.fieldId: "\(fieldContent.field.id)", EventParamKey.farmId: "\(fieldContent.field.farmId)", EventParamKey.fromDate: String(Int(fieldContent.field.dateUpdated.timeIntervalSince1970 * 1000)), "field_unread": String(fieldContent.fieldLastRead == nil ? 1 : 0), EventParamKey.listFiltered: "\(currentState.searchTerm.isEmpty ? "no" : "yes")",
    ]))
  }

  private func onSortButtonClick() {
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.fieldsList, "sort_click", getPageState()))
  }

  private func onSortSaved(newSortingType: FieldListSortingType) {
    var parameters: [String: String] = getPageState()
    parameters["new_sort"] = newSortingType.rawValue
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.fieldsList, "save_sort_selection", parameters))
  }

  private func onSearchClick() {
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.fieldsList, "field_search", getPageState()))
  }

  private func onSearchBackClick() {
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.fieldsList, "back_search", getPageState()))
  }

  private func onSearchType() {
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.fieldsList, "typing_seach_field", getPageState()))
  }

  private func onSettingClick() {
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.fieldsList, "settings_click"))
  }

  private func onFiledsListScroll(reachesEnd: Bool) {
    var parameters: [String: String] = getPageState()
    parameters[EventParamKey.itemId] = "scroll_farm_page"
    parameters[EventParamKey.scrollAll] = String(reachesEnd)
    EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.fieldsList, .scroll, parameters))
  }

  private func onShowAllHighlightsClick() {
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.highlight, "show_all_highlights"))
  }

  private func onHighlightClick(index: Int, insight: Insight) {
    var insightType: String
    if insight is IrrigationInsight {
      insightType = "irrigation highlight"
    } else if insight is SingleLocationInsight {
      insightType = "first detection"
    } else {
      insightType = "actionable insight"
    }
    var parameters = [String: String]()
    parameters[EventParamKey.itemId] = "highlight_view"
    parameters[EventParamKey.fieldId] = String(insight.fieldId)
    parameters[EventParamKey.insightUid] = String(insight.uid)
    parameters[EventParamKey.fromDate] = String(Int(insight.publishDate.timeIntervalSince1970 * 1000))
    parameters[EventParamKey.position] = String(index)
    parameters[EventParamKey.highlightType] = insightType
    EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.highlight, .highlightClick, parameters))
  }

  private func onHighlightEndDrag(index: Int) {
    let parameters: [String: String] = [
      EventParamKey.itemId: "swipe_highlights",
      EventParamKey.numHighlights: String(currentState.highlights.count),
      EventParamKey.position: String(index + 1),
    ]
    EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.highlight, .scroll, parameters))
  }

  private func getPageState() -> [String: String] {
    var farmCount: Int
    do {
      farmCount = try farmFilter.farms.value().count
    } catch {
      farmCount = 0
    }
    return [
      "sorting_selection": currentState.sortingType.rawValue,
      "farm_count": String(farmCount),
      "fields_count": String(currentState.fieldList.count),
      "num_highlights": String(currentState.highlights.count),
      "scrollable_farm_page": "", // TODO: is this must? hard to get it from ui or just set true if there is more then 3 items if there are highlight or more then 5 if there are no highlights (this is the number of items can be in screen)
    ]
  }
}
