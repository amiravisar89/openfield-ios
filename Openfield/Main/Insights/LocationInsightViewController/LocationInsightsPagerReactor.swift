//
//  LocationInsightsPagerReactor.swift
//  Openfield
//
//  Created by Yoni Luz on 13/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import SwiftyUserDefaults
import Then
import FirebaseAnalytics

class LocationInsightsPagerReactor: Reactor {
  var initialState: LocationInsightsPagerReactor.State
  private let disposeBag = DisposeBag()
  let insightsFromFieldAndCategoryUsecase: InsightsFromFieldAndCategoryUsecaseProtocol
  let getSingleInsightUseCase: GetSingleInsightUsecaseProtocol
  let dateProvider: DateProvider

  init(insightUid: String, category: String, subcateogy: String, fieldId: Int?, cycleId: Int?, publicationYear: Int?, insightsFromFieldAndCategoryUsecase: InsightsFromFieldAndCategoryUsecaseProtocol, getSingleInsightUsecase: GetSingleInsightUsecaseProtocol, welcomInsightsUsecase: WelcomInsightsUsecaseProtocol, dateProvider: DateProvider, getShapeFileUrlUseCase: GetShapeFileUrlUseCaseProtocol, languageService: LanguageService, isUserFieldOwnerUsecase: IsUserFieldOwnerUseCaseProtocol, getSupportedInsightUseCase: GetSupportedInsightUseCaseProtocol) {
    self.insightsFromFieldAndCategoryUsecase = insightsFromFieldAndCategoryUsecase
    self.dateProvider = dateProvider
    getSingleInsightUseCase = getSingleInsightUsecase
    let shareStrategies = getSupportedInsightUseCase.supportedInsights()[category]?.appTypes[subcateogy]?.shareStrategies ?? []
    let showBadge = shareStrategies.contains { $0 == .shapeFile }
    initialState = State(fieldId: fieldId, originalLocationInsightId: insightUid, shareActions: shareStrategies, showBadge: showBadge, shouldShowPrevButtonGlow: false)

    if insightUid == WelcomeInsightsIds.locationInsight.rawValue {
      welcomInsightsUsecase.insights()
        .map { $0.filter { $0.uid == WelcomeInsightsIds.locationInsight.rawValue }}
        .map { insights in Action.setData(insights: insights, isFieldOwner: false) }
        .bind(to: action)
        .disposed(by: disposeBag)

    } else if let fieldId = fieldId {
      isUserFieldOwnerUsecase.isUserField(fieldId: fieldId).flatMap { isOwner in
        if isOwner {
          return insightsFromFieldAndCategoryUsecase.insights(byFieldId: fieldId, byCategory: category, onlyHighlights: false, cycleId: cycleId, publicationYear: publicationYear).map { (insights: $0, isFieldOwner: isOwner) }
        } else {
          return getSingleInsightUsecase.insight(byUID: insightUid).compactMap { $0 }.map { (insights: [$0], isFieldOwner: isOwner) }
        }
      }
      .map { .setData(insights: $0.insights, isFieldOwner: $0.isFieldOwner) }
      .bind(to: action)
      .disposed(by: disposeBag)

    } else {
      getSingleInsightUsecase.insight(byUID: insightUid).compactMap { $0 }
        .concatMap { insight in
          isUserFieldOwnerUsecase.isUserField(fieldId: insight.fieldId).concatMap { isOwner in
            if isOwner {
              return insightsFromFieldAndCategoryUsecase.insights(byFieldId: insight.fieldId, byCategory: category, onlyHighlights: false, cycleId: cycleId, publicationYear: publicationYear).map { (insights: $0, isFieldOwner: isOwner) }
            } else {
              return Observable.just((insights: [insight], isFieldOwner: isOwner))
            }
          }
        }
        .map { .setData(insights: $0, isFieldOwner: $1) }
        .bind(to: action)
        .disposed(by: disposeBag)
    }

    languageService.currentLanguage
      .map { userLanguage in
        let url = getShapeFileUrlUseCase.url(locale: userLanguage.locale)
        return Action.setShapefileUrl(url: url)
      }
      .bind(to: action)
      .disposed(by: disposeBag)
  }

  struct State: Then {
    var fieldId: Int?
    var originalLocationInsightId: String
    var insights = [LocationInsight]()
    var isFieldOwner = false
    var currentIndex: Int?
    var currentLocationInsight: LocationInsight?
    var shareActions: [ShareStrategy]
    var shapefileUrl: URL?
    var showBadge: Bool = false
    var shouldShowPrevButtonGlow: Bool
  }

  enum Action {
    case setData(insights: [Insight], isFieldOwner: Bool)
    case clickBack(navigationEffect: SideEffect)
    case setCurrentIndex(index: Int)
    case showNextPage
    case showPrevPage
    case shareInsight(shareEffect: ((String, UIView?) -> Void)?, view: UIView?)
    case navigateToField(navigationEffect: ((_ fieldId: Int) -> Void)?)
    case setShapefileUrl(url: URL)
    case shareClicked
    case shareShapeFileClicked
    case shapeFileRedirectToFormClicked(didContinue: Bool)
      case reportScreenView(insight: LocationInsight)
  }

  enum Mutation {
    case setInsights(insights: [LocationInsight])
    case setCurrentIndex(index: Int)
    case setIsFieldOwner(isOnwer: Bool)
    case setFieldId(id: Int)
    case setShapefileUrl(url: URL)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .setData(insights, isFieldOwner):
      var observables = [Observable<Mutation>]()
      let locationInsights = insights.compactMap { $0 as? LocationInsight }
      observables.append(Observable.just(.setInsights(insights: locationInsights)))
      observables.append(Observable.just(.setIsFieldOwner(isOnwer: isFieldOwner)))

      if locationInsights != currentState.insights {
        if let insightIndex = locationInsights.firstIndex(where: { $0.uid == currentState.originalLocationInsightId }) {
          observables.append(Observable.just(.setCurrentIndex(index: insightIndex)))
        }
      }
      return Observable.concat(observables)
    case let .clickBack(navigationEffect):
      navigationEffect?()
      return Observable.empty()
    case let .setCurrentIndex(index):
      return Observable.just(.setCurrentIndex(index: index))
    case .showNextPage:
      if let currentIndex = currentState.currentIndex {
        let newIndex = currentIndex + 1
        if newIndex < currentState.insights.count {
          onNavigateButtonClick(prevButtonShouldGlow: currentState.shouldShowPrevButtonGlow, isBackward: false)
          return Observable.just(.setCurrentIndex(index: newIndex))
        } else {
          return Observable.empty()
        }
      } else {
        return Observable.empty()
      }
    case .showPrevPage:
      if let currentIndex = currentState.currentIndex {
        let newIndex = currentIndex - 1
        if newIndex >= 0 {
          Defaults.locationInsightPagerPrevArrowClicked = true
          onNavigateButtonClick(prevButtonShouldGlow: currentState.shouldShowPrevButtonGlow, isBackward: true)
          return .just(Mutation.setCurrentIndex(index: newIndex))
        } else {
          return Observable.empty()
        }
      } else {
        return Observable.empty()
      }
    case let .shareInsight(shareEffect: shareEffect, view: view):
      if let currentLocationInsight = currentState.currentLocationInsight {
        reportShareStrategyClick(strategy: .share)
        let insightDateFormated: String = dateProvider.format(date: currentLocationInsight.publishDate, format: .short)
        var components = DeepLinkingSettings.universalLinkShareBaseUrlComponents
        components.path = "/i/\(currentLocationInsight.uid)"
        let textToShare: String = R.string.localizable.insightShareLocationInsight_IOS(currentLocationInsight.subject, insightDateFormated, currentLocationInsight.fieldName, components.url!.absoluteString)
        shareEffect?(textToShare, view)
      }
      return Observable.empty()
    case let .navigateToField(navigationEffect):
      if let fieldId = currentState.currentLocationInsight?.fieldId {
        PerformanceManager.shared.startTrace(origin: .location_insight, target: .field)
        navigationEffect?(fieldId)
      }
      return Observable.empty()

    case let .setShapefileUrl(url: url):
      return Observable.just(Mutation.setShapefileUrl(url: url))

    case .shareClicked:
      reportShareClick()
      return .empty()

    case .shareShapeFileClicked:
      reportShareStrategyClick(strategy: .shapeFile)
      return .empty()

    case let .shapeFileRedirectToFormClicked(didContinue: didContinue):
      reportShareRedirectToForm(didContinue: didContinue)
      if didContinue {
        guard let shapefileUrl = currentState.shapefileUrl else { return .empty() }
        UIApplication.shared.open(shapefileUrl)
      }
      return .empty()
    case .reportScreenView(let insight):
        // Analytics
        let screenViewParams = [
            AnalyticsParameterScreenName: ScreenName.insight,
            AnalyticsParameterScreenClass: String(describing: LocationInsightViewController.self),
            EventParamKey.category: EventCategory.field,
            EventParamKey.fieldId: insight.fieldId,
            EventParamKey.farmId: insight.farmId,
            EventParamKey.cycleId: insight.cycleId,
            EventParamKey.insightUid: insight.uid,
            EventParamKey.insightCategory: insight.category,
            EventParamKey.insightType: insight.type
        ] as [String : Any]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
        return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {
    case let .setInsights(insights):
      return state.with {
        $0.insights = insights
      }
    case let .setCurrentIndex(index):
      let showPrevAnimation = index != .zero &&
        state.insights.count > 1 &&
        !Defaults.locationInsightPagerPrevArrowClicked
      return state.with {
        $0.currentIndex = index
        let currentLocationInsight = state.insights[index]
        $0.currentLocationInsight = currentLocationInsight
        $0.shouldShowPrevButtonGlow = showPrevAnimation
      }
    case let .setIsFieldOwner(isOnwer: isOnwer):
      return state.with {
        $0.isFieldOwner = isOnwer
      }
    case let .setFieldId(id: id):
      return state.with {
        $0.fieldId = id
      }

    case let .setShapefileUrl(url: url):
      return state.with {
        $0.shapefileUrl = url
      }
    }
  }

  func onNavigateButtonClick(prevButtonShouldGlow: Bool, isBackward: Bool) {
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(
      EventCategory.field, "report_popup",
      ["\(EventParamKey.fieldId)": "\(currentState.fieldId ?? 0)",
       EventParamKey.animation: prevButtonShouldGlow ? "On" : "Off",
       EventParamKey.direction: isBackward ? "backward" : "forward",
       "current_report": "\(currentState.currentLocationInsight?.uid ?? "")"]
    )
    )
  }

  private func reportShareClick() {
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(
      EventCategory.locationInsight, Events.shareClick.rawValue,
      [EventParamKey.fieldId: String(currentState.fieldId ?? 0),
       EventParamKey.currentReport: "\(currentState.currentLocationInsight?.uid ?? "")"]
    ))
  }

  private func reportShareStrategyClick(strategy: ShareStrategy) {
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(
      EventCategory.locationInsight, Events.shareBottomsheet.rawValue,
      [EventParamKey.fieldId: String(currentState.fieldId ?? 0),
       EventParamKey.currentReport: "\(currentState.currentLocationInsight?.uid ?? "")",
       EventParamKey.shareStrategy: strategy.rawValue]
    ))
  }

  private func reportShareRedirectToForm(didContinue: Bool) {
    EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(
      EventCategory.locationInsight, Events.redirectShapefile.rawValue,
      [EventParamKey.fieldId: String(currentState.fieldId ?? 0),
       EventParamKey.currentReport: "\(currentState.currentLocationInsight?.uid ?? "")",
       EventParamKey.userSelection: didContinue ? Events.continueShapefile.rawValue : Events.cancelShapefile.rawValue]
    ))
  }
}
