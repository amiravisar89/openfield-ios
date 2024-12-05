//
//  FieldViewReactor.swift
//  Openfield
//
//  Created by Daniel Kochavi on 18/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import ReactorKit
import Resolver
import RxSwift
import SwiftyUserDefaults
import Then
import FirebaseAnalytics

final class FieldViewReactor: Reactor {
  var initialState: FieldViewReactor.State

  var fieldWithImagesUsecase: FieldUseCaseProtocol
  var getCategoriesUsecase: GetCategoriesUsecaseProtocol
  var getFieldImageryUsecase: GetFieldImageryUsecaseProtocol
  var getFieldIrrigationUsecase: GetFieldIrrigationUsecaseProtocol
  var getRequestReportLinkUsecase: RequestReportLinkUsecaseProtocol
  var getVirtualScoutingStateUsecase: VirtualScoutingStateUsecaseProtocol
  let disposeBag = DisposeBag()

  init(fieldId: Int, fieldWithImagesUsecase: FieldUseCaseProtocol, getCategoriesUsecase: GetCategoriesUsecaseProtocol, getFieldImageryUsecase: GetFieldImageryUsecaseProtocol,
       getFieldIrrigationUsecase: GetFieldIrrigationUsecaseProtocol, getRequestReportLinkUsecase: RequestReportLinkUsecaseProtocol, getVirtualScoutingStateUsecase: VirtualScoutingStateUsecaseProtocol)
  {
    self.fieldWithImagesUsecase = fieldWithImagesUsecase
    self.getCategoriesUsecase = getCategoriesUsecase
    self.getFieldImageryUsecase = getFieldImageryUsecase
    self.getFieldIrrigationUsecase = getFieldIrrigationUsecase
    self.getRequestReportLinkUsecase = getRequestReportLinkUsecase
    self.getVirtualScoutingStateUsecase = getVirtualScoutingStateUsecase
      initialState = FieldViewReactor.State(fieldId: fieldId, field: nil, cells: [], selectedSeason: nil, seasons: [], isLoading: true, seasonLoading: false, virtualScoutingButtonShouldGlow: !Defaults.virtualScoutingButtonClicked)

    fieldWithImagesUsecase.getFieldWithImages(fieldId: fieldId)
      .flatMap { field in
        Observable.combineLatest(
          Observable.just(field),
          self.getCategoriesUsecase.categoriesBySeason(field: field, selectedSeasonOrder: 0),
          self.getFieldImageryUsecase.fieldImagesWithFilter(field: field, selectedSeasonOrder: 0),
          self.getFieldIrrigationUsecase.irrigations(field: field, selectedSeasonOrder: 0),
          self.getRequestReportLinkUsecase.getRequestReportLink(field: field, selectedSeasonOrder: 0),
          self.getVirtualScoutingStateUsecase.getVirtualScoutingState(field: field, selectedSeasonOrder: 0)
        )
      }.map {
        .setData(field: $0, categories: $1, fieldImages: $2, irrigations: $3, selectedSeasonOrder: 0, requestReportLink: $4, virtualScoutingState: $5)
      }
      .bind(to: action)
      .disposed(by: disposeBag)
  }

  enum Action {
    case setData(field: Field, categories: [InsightCategory], fieldImages: [FieldImage], irrigations: [FieldIrrigation], selectedSeasonOrder: Int, requestReportLink: URL?, virtualScoutingState: VirtualScoutingState)
    case selectSeason(selectedSeasonOrder: Int)
    case navigateToAnalysis(navigation: ((Field) -> Void)?)
    case navigateBack(navigation: () -> Void)
    case navigateScoutingButton(navigation: (Field, Int) -> Void)
    case navigate(index: Int, locationInsightsNavigation: (Insight) -> Void, imageryNavigation: (Field) -> Void, requestReport: (URL) -> Void)
    case navigateIrrigation(index: Int, irrigationNavigation: (IrrigationInsight) -> Void)
    case navigateHighlights(navigation: (Int?, String?) -> Void)
    case analyticsScroll(reachesEnd: Bool)
    case seasonSelectionClicked
    case requestReportClicked(link: URL)
    case requestReportDismissed
    case reportScreenView
  }

  enum Mutation {
    case unChange
    case setData(field: Field, categories: [InsightCategory], fieldImages: [FieldImage], irrigations: [FieldIrrigation], selectedSeasonOrder: Int, requestReportLing: URL?, virtualScoutingState: VirtualScoutingState)
    case selectSeason(selectedSeasonOrder: Int)
    case setSeasonLoading(isLoading: Bool)
    case setVirtualScoutingAnimation(shouldShow: Bool)
  }

  struct State: Then {
    var fieldId: Int
    var field: Field?
    var cells: [FieldReportItem]
    var selectedSeason: Season?
    var seasons: [Season]
    var isLoading: Bool
    var seasonLoading : Bool
    var virtualScoutingState = VirtualScoutingState.hidden
    var virtualScoutingButtonShouldGlow: Bool

    var showNoImagery: Bool {
      field?.imageGroups.count == 0
    }

    var showNoInsights: Bool {
      !showNoImagery && cells.count == 0
    }
  }

  func mutate(action: FieldViewReactor.Action) -> Observable<FieldViewReactor.Mutation> {
    switch action {
    case let .navigateToAnalysis(navigation):
      guard let field = currentState.field else { return .empty() }
      PerformanceManager.shared.startTrace(origin: .field, target: .analysis)
      navigation?(field)
      return .empty()
    case let .navigateBack(navigation):
      reportNavigateBack(fieldId: currentState.fieldId)
      navigation()
      return .empty()
    case let .navigateScoutingButton(navigation):
      guard let field = currentState.field else { return .empty() }
      guard let selectedSeason = currentState.selectedSeason else { return .empty() }
      guard let cycleId = field.getCycleId(forSelectedOrder: selectedSeason.order) else { return .empty() }
      reportNavigateScoutingButton(fieldId: currentState.fieldId, cycleId: cycleId, virtualScoutingButtonShouldGlow: currentState.virtualScoutingButtonShouldGlow)
      Defaults.virtualScoutingButtonClicked = true
      PerformanceManager.shared.startTrace(origin: .field, target: .virtual_scouting)
      navigation(field, cycleId)
      return .just(Mutation.setVirtualScoutingAnimation(shouldShow: false))
    case let .analyticsScroll(reachesEnd: reachesEnd):
      guard let field = currentState.field else { return .empty() }
      reportScroll(reachesEnd: reachesEnd, fieldId: field.id)
      return .empty()
    case let .setData(field: field, categories: categories, fieldImages: fieldImages, irrigations: irrigations, selectedSeasonOrder: selectedSeasonOrder, requestReportLink, virtualScoutingState):
      return Observable.concat(
        [.just(Mutation.selectSeason(selectedSeasonOrder: selectedSeasonOrder)),
         .just(.setData(field: field, categories: categories, fieldImages: fieldImages, irrigations: irrigations, selectedSeasonOrder: selectedSeasonOrder, requestReportLing: requestReportLink, virtualScoutingState: virtualScoutingState))])
    case let .selectSeason(selectedSeasonOrder: selectedSeasonOrder):
      guard
        let field = currentState.field
      else {
        return .empty()
      }
      return Observable.concat([
        Observable.just(Mutation.setSeasonLoading(isLoading: true)),
        Observable.just(Mutation.selectSeason(selectedSeasonOrder: selectedSeasonOrder)),
        fetchData(field: field, selectedSeasonOrder: selectedSeasonOrder),
      ])
    case let .navigate(index: index, locationInsightsNavigation: locationInsightsNavigation, imageryNavigation: imageryNavigation, requestReport):
      let fieldCell = currentState.cells[index]
      switch fieldCell.type {
      case let .category(category: category):
        PerformanceManager.shared.startTrace(origin: .field, target: .location_insight)
        reportClickInsight(index: index, insightCategory: category)
        locationInsightsNavigation(category.insight)
      case .fieldImage(fieldImage: _):
        guard let field = currentState.field else { return .empty() }
        PerformanceManager.shared.startTrace(origin: .field, target: .analysis)
        imageryNavigation(field)
      case .irrigation(irrigation: _):
        return .empty()
      case let .requestReport(link):
        requestReportConfirmAnalytics()
        requestReport(link)
        return .empty()
      }
      return .empty()
    case let .navigateIrrigation(index: index, irrigationNavigation: irrigationNavigation):
      guard let irrigationCell = currentState.cells.compactMap({ item -> FieldIrrigation? in
        switch item.type {
        case let .irrigation(irrigation: irrigation):
          return irrigation
        default:
          return nil
        }
      }).first else { return .empty() }
      guard irrigationCell.insights.indices.contains(index) else { return .empty() }
      PerformanceManager.shared.startTrace(origin: .field, target: .irrigation_insight)
      irrigationNavigation(irrigationCell.insights[index])
      return .empty()
    case let .navigateHighlights(navigation: navigation):
      guard let irrigation = exportIrrigationCell(),
            let field = currentState.field,
            let firstIrrigation = irrigation.insights.first else { return .empty() }
      PerformanceManager.shared.startTrace(origin: .field, target: .highlights_list)
      navigation(field.id, firstIrrigation.category)
      return Observable.empty()
    case .seasonSelectionClicked:
      reportSeasonSelectionClick()
      return Observable.empty()
    case .requestReportDismissed:
      requestReportRedirectAnalytics(userSelection: "cancel_request")
      return Observable.empty()
    case let .requestReportClicked(link):
      requestReportRedirectAnalytics(userSelection: "continue_request")
      UIApplication.shared.open(link)
      return Observable.empty()
    case .reportScreenView:
        let screenViewParams = [AnalyticsParameterScreenName: ScreenName.field,
                                AnalyticsParameterScreenClass: String(describing: FieldViewController.self),
                                EventParamKey.category: EventCategory.field,
                                EventParamKey.fieldId: currentState.field?.id,
                                EventParamKey.farmId: currentState.field?.farmId
        ] as [String: Any]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
      return Observable.empty()
    }
  }

  func reduce(state: FieldViewReactor.State, mutation: FieldViewReactor.Mutation) -> FieldViewReactor.State {
    switch mutation {
    case .unChange:
      let newState: State = state
      return newState

    case .setData(field: let field, categories: let categories, fieldImages: let fieldImages, irrigations: let irrigations, selectedSeasonOrder: let selectedSeasonOrder, let requestReportLink, var virtualScoutingState):
      var result = [FieldReportItem]()
      if let reportLink = requestReportLink, !categories.isEmpty {
        result.append(FieldReportItem(type: .requestReport(link: reportLink), date: Date()))
      }
      let categoriesCells = categories.map {
        FieldReportItem(type: .category(category: $0), date: $0.date)
      }
      result = result + categoriesCells
      let irrigationsCells = irrigations.map { irrigation in
        FieldReportItem(type: .irrigation(irrigation: irrigation), date: irrigation.date)
      }
      result = result + irrigationsCells
      result = result.sorted(by: { $0.date > $1.date })
      let images = fieldImages.map { fieldImage in
        FieldReportItem(type: .fieldImage(fieldImage: fieldImage), date: fieldImage.date)
      }
      result = result + images
      let insights = categories.map { $0.insight }

      let seasons = buildSeasonList(filters: field.filters)
      let selectedSeason = seasons.first(where: { $0.order == selectedSeasonOrder })
      reportScreenState(fieldId: state.field?.id ?? .zero, insights: insights)
      if virtualScoutingState == .enabled && categories.isEmpty {
        virtualScoutingState = .disabled
      }
      return state.with {
        $0.cells = result
        $0.isLoading = false
        $0.seasonLoading = false
        $0.field = field
        $0.selectedSeason = selectedSeason
        $0.seasons = seasons
        $0.virtualScoutingState = virtualScoutingState
      }
    case let .selectSeason(selectedSeasonOrder: selectedSeasonOrder):
      let selectedSeason = currentState.seasons.first(where: { $0.order == selectedSeasonOrder })
      reportSeasonSelection(newSeason: selectedSeason)
      return state.with {
        $0.selectedSeason = selectedSeason
      }
    case let .setVirtualScoutingAnimation(shouldShow: shouldShow):
      return state.with {
        $0.virtualScoutingButtonShouldGlow = shouldShow
      }
    case .setSeasonLoading(isLoading: let isLoading):
        return state.with {
            $0.seasonLoading = isLoading
        }
    }
  }

  private func fetchData(field: Field, selectedSeasonOrder: Int) -> Observable<Mutation> {
    let categories = getCategoriesUsecase.categoriesBySeason(field: field, selectedSeasonOrder: selectedSeasonOrder)
    let fieldImages = getFieldImageryUsecase.fieldImagesWithFilter(field: field, selectedSeasonOrder: selectedSeasonOrder)
    let irrigations = getFieldIrrigationUsecase.irrigations(field: field, selectedSeasonOrder: selectedSeasonOrder)
    let requestReportLink = getRequestReportLinkUsecase.getRequestReportLink(field: field, selectedSeasonOrder: selectedSeasonOrder)
    let virtualScoutingState = getVirtualScoutingStateUsecase.getVirtualScoutingState(field: field, selectedSeasonOrder: selectedSeasonOrder)
    return Observable.combineLatest(categories, fieldImages, irrigations, requestReportLink, virtualScoutingState)
      .map { categories, fieldImages, irrigations, link, virtualScoutingState in
        Mutation.setData(field: field, categories: categories, fieldImages: fieldImages, irrigations: irrigations, selectedSeasonOrder: selectedSeasonOrder, requestReportLing: link, virtualScoutingState: virtualScoutingState)
      }
  }

  private func buildSeasonList(filters: [FieldFilter]) -> [Season] {
    var seasons: [Season] = []
    for filter in filters {
      seasons.append(Season(name: filter.name, order: filter.order))
    }
    return seasons
  }

  private func exportIrrigationCell() -> FieldIrrigation? {
    return currentState.cells.compactMap { item -> FieldIrrigation? in
      switch item.type {
      case let .irrigation(irrigation: irrigation):
        return irrigation
      default:
        return nil
      }
    }.first
  }

  private func reportScreenState(fieldId: Int, insights: [Insight]) {
    let numCategories = insights.count
    let numCategoriesUnread = insights.filter { !$0.isRead }.count
    EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.field, .impression, [EventParamKey.itemId: "field_page", EventParamKey.fieldId: "\(fieldId)", EventParamKey.numCategories: String(numCategories), EventParamKey.numCategoriesUnread: String(numCategoriesUnread)]))
  }

  private func reportNavigateBack(fieldId: Int) {
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.field, "back_field_page", [EventParamKey.fieldId: String(fieldId)]))
  }

  private func reportScroll(reachesEnd: Bool, fieldId: Int) {
    EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.field, Events.scroll,
                                                               [EventParamKey.fieldId: String(fieldId),
                                                                EventParamKey.itemId: "scroll_field_page", EventParamKey.scrollAll: String(reachesEnd)]))
  }

  private func reportClickInsight(index: Int, insightCategory: InsightCategory) {
    let highlight = insightCategory.insight is IrrigationInsight || insightCategory.insight is SingleLocationInsight
    EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.field, .categoryClick,
                                                               [EventParamKey.insightUid: insightCategory.insight.uid, EventParamKey.index: String(index), EventParamKey.highlight: String(highlight), EventParamKey.origin: "field_page", EventParamKey.category: insightCategory.categoryId, EventParamKey.fieldId: "\(insightCategory.insight.fieldId)"]))
  }

  private func reportSeasonSelection(newSeason: Season?) {
    EventTracker.track(event: AnalyticsEventFactory
      .buildClickEvent(EventCategory.field, "cycle_selection",
                       [EventParamKey.fieldId: String(currentState.fieldId),
                        EventParamKey.currentSeason: currentState.selectedSeason?.name ?? "",
                        EventParamKey.newSeason: newSeason?.name ?? ""]))
  }

  private func reportSeasonSelectionClick() {
    EventTracker.track(event: AnalyticsEventFactory
      .buildClickEvent(EventCategory.field, "cycle_popup",
                       [EventParamKey.fieldId: String(currentState.fieldId),
                        EventParamKey.currentSeason: currentState.selectedSeason?.name ?? ""]))
  }

  private func requestReportRedirectAnalytics(userSelection: String) {
    EventTracker.track(event: AnalyticsEventFactory
      .buildClickEvent(EventCategory.field, "redirect_report_request",
                       [EventParamKey.fieldId: String(currentState.fieldId),
                        EventParamKey.userSelection: userSelection]))
  }

  private func reportNavigateScoutingButton(fieldId: Int, cycleId: Int, virtualScoutingButtonShouldGlow: Bool) {
    EventTracker.track(event: AnalyticsEventFactory
      .buildClickEvent(EventCategory.field, "enter_virtual_scouting_click",
                       [EventParamKey.fieldId: String(fieldId),
                        EventParamKey.animation: virtualScoutingButtonShouldGlow ? "On" : "Off",
                        EventParamKey.currentCycle: String(cycleId)]))
  }

  private func requestReportConfirmAnalytics() {
    EventTracker.track(event: AnalyticsEventFactory
      .buildEvent(EventCategory.field, Events.reportRequestClick,
                  [EventParamKey.fieldId: String(currentState.fieldId),
                   EventParamKey.itemId: EventParamKey.reportRequest,
                   EventParamKey.currentSeason: currentState.selectedSeason?.name ?? ""]))
  }
}
