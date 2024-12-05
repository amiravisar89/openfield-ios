//
//  InsightViewReactor.swift
//  Openfield
//
//  Created by Itay Kaplan on 03/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation
import ReactorKit
import Resolver
import RxCocoa
import RxSwift
import SwiftDate
import SwiftyUserDefaults
import Then
import UIKit
import FirebaseAnalytics

final class InsightViewReactor: Reactor {
  var initialState: State
  var dateProvider: DateProvider
  let updateUserParamsUsecase: UpdateUserParamsUsecaseProtocol
  var origin: String
  let disposeBag = DisposeBag()
  var sawFeedbackWalkthrough = false
  let getSingleInsightUsecase: GetSingleInsightUsecaseProtocol
  let insightsForFieldUsecase : InsightsForFieldUsecaseProtocol
  let fieldUseCase: FieldUseCaseProtocol
  let userUseCase: UserStreamUsecaseProtocol
  let isFieldOwnerUseCase: IsUserFieldOwnerUseCaseProtocol

  init(insightUid: String, origin: String, getSingleInsightUsecase: GetSingleInsightUsecaseProtocol, insightsForFieldUsecase : InsightsForFieldUsecaseProtocol, fieldUseCase: FieldUseCaseProtocol, userUseCase: UserStreamUsecaseProtocol, updateUserParamsUsecase: UpdateUserParamsUsecaseProtocol, dateProvider: DateProvider, isFieldOwnerUseCase: IsUserFieldOwnerUseCaseProtocol) {
    self.dateProvider = dateProvider
    self.getSingleInsightUsecase = getSingleInsightUsecase
    self.insightsForFieldUsecase = insightsForFieldUsecase
    self.fieldUseCase = fieldUseCase
    self.userUseCase = userUseCase
    self.origin = origin
    self.updateUserParamsUsecase = updateUserParamsUsecase
    self.isFieldOwnerUseCase = isFieldOwnerUseCase

    initialState = State(insightUid: insightUid, insight: nil, isFieldOwner: false, isWelcomeInsight: insightUid == WelcomeInsightsIds.irrigation.rawValue)

    let insightStream = getSingleInsightUsecase.insight(byUID: insightUid).filter {
      $0 is IrrigationInsight
    }.compactMap { $0 as? IrrigationInsight }

    Observable.zip(insightStream.compactMap {$0},
                   userUseCase.userStream()) { insight, user in (insight, user) }
    .take(1)
    .map { Action.initData(insight: $0.0, user: $0.1) }
    .bind(to: action)
    .disposed(by: disposeBag)

    insightStream.map { Action.analyticsInsightView(insight: $0) }
      .bind(to: action)
      .disposed(by: disposeBag)
    
    insightStream.compactMap {$0}
      .flatMap{isFieldOwnerUseCase.isUserField(fieldId: $0.fieldId)}
      .map{Action.setIsFieldOwner(isOwner: $0)}
      .bind(to: action)
      .disposed(by: disposeBag)

    self.userUseCase.userStream()
      .map { Action.updateUser(user: $0) }
      .bind(to: action)
      .disposed(by: disposeBag)
  }

  enum Action {
    case initData(insight: IrrigationInsight, user: User)
    case drawerReachedMaxHeight(atMax: Bool)
    case shareInsight(shareEffect: (String, UIView?) -> Void, view: UIView)
    case markInsightAsUnread(navigationEffect: () -> Void)
    case selectedRating(rating: Int, navigationEffect: (Feedback, InsightViewReactor) -> Void, uiEffect: () -> Void)
    case selectedFeedbackAnswer(displayString: String, otherText: String?)
    case closeFeedback(closeFeedbackEffect: () -> Void)
    case clickedAnalyze(navigationEffect: (Field, IrrigationInsight, [IrrigationInsight]) -> Void)
    case clickedField(navigationEffect: (Field) -> Void)
    case clickBack(navigationEffect: () -> Void, showFeedbackDialog: () -> Void)
    case shownCardTooltip
    case shownComparePopUp
    case analyticsInsightView(insight: IrrigationInsight)
    case updateUser(user: User)
    case setIsFieldOwner(isOwner: Bool)
    case reportScreenView
  }

  enum Mutation {
    case setData(insight: IrrigationInsight, user: User)
    case updateUser(user: User)
    case unChange
    case setFeedback(feedback: Feedback)
    case changeBackButtonHeader(visibile: Bool)
    case setIsFieldOwner(isOwner: Bool)
  }

  struct State: Then {
    var insightUid: String
    var insight: IrrigationInsight?
    var isFieldOwner : Bool
    var user: User?
    var feedbackOptions: [String] { return FeedbackAnswer.allCases.map { $0.displayString } }
    var isWelcomeInsight: Bool
    var showBackButtonHeader: Bool = false
    var showDrawerTooltip: Bool {
      guard let user = user else { return false }
      return user.tracking.insightsReadWithoutOpeningCard > 4 && user.tracking.tsCardTooltipLastShown == nil && user.tracking.tsCardFirstOpen == nil
    }
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .updateUser(user):
      return .just(.updateUser(user: user))
    case let .initData(insight, user):
      trackPerformances(insight: insight, origin: origin)
      if user.insights[insight.id]?.tsRead == nil {
        updateUserParamsUsecase.changeInsightReadStatus(insight: insight, isRead: true)
      }
      return Observable.concat(.just(Mutation.setData(insight: insight, user: user)))

    case let .markInsightAsUnread(navigationEffect):
      guard let insight = currentState.insight else { return .empty() }
      updateUserParamsUsecase.changeInsightReadStatus(insight: insight, isRead: false)
      EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.insightCard, "mark_as_unread"))
      navigationEffect()
      return Observable.just(Mutation.unChange)
    case let .selectedRating(rating, navigation, uiEffect):
      guard let insight = currentState.insight else { return .empty() }
      let previousFeedback = insight.feedback
      var updatedFeedback = previousFeedback.with {
        $0.otherReasonText = previousFeedback.otherReasonText
        $0.rating = rating
      }
      if rating == 5 {
        updatedFeedback.reason = nil
      }
      EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.insightCard,
                                                                 .ratingStarClicked, [EventParamKey.rating: "\(rating)",
                                                                                      EventParamKey.previousRating: "\(previousFeedback.rating ?? 0)"]))
      return updateUserParamsUsecase
        .updateFeedback(feedback: updatedFeedback)
        .do { if rating < 5 {
          EventTracker.track(event: AnalyticsEventFactory.buildDialogEvent(EventCategory.feedbackSheet,
                                                                           FeedbackViewController.analyticName, true, [EventParamKey.rating: "\(rating)",
                                                                                                                       EventParamKey.reason: "\(previousFeedback.reason?.rawValue ?? "null")"]))

          navigation(updatedFeedback, self)
          uiEffect()
        } else {
          uiEffect()
        }}
        .map { _ in Mutation.setFeedback(feedback: updatedFeedback) }
    case let .selectedFeedbackAnswer(displayString, otherText):
      guard let insight = currentState.insight else { return .empty() }
      guard let selectionIndex = currentState.feedbackOptions.firstIndex(of: displayString) else {
        return Observable.just(Mutation.unChange)
      }
      var feedback = insight.feedback
      let updatedReason = FeedbackAnswer.allCases[selectionIndex]
      feedback.otherReasonText = otherText
      let updatedFeedback = feedback.with {
        $0.reason = updatedReason
      }
      EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.feedbackSheet,
                                                                 .labelClick, [EventParamKey.itemId: "feedback_reason",
                                                                               EventParamKey.reason: updatedReason.rawValue]))
      return updateUserParamsUsecase
        .updateFeedback(feedback: updatedFeedback)
        .map { _ in Mutation.setFeedback(feedback: updatedFeedback) }

    case let .closeFeedback(closeFeedbackEffect):
      closeFeedbackEffect()
      EventTracker.track(event: AnalyticsEventFactory.buildDialogEvent(EventCategory.feedbackSheet,
                                                                       FeedbackViewController.analyticName, false, [EventParamKey.origin: "button"]))
      return Observable.just(Mutation.unChange)

    case let .clickedAnalyze(navigationEffect):
      guard let insight = currentState.insight else { return .empty() }
      PerformanceManager.shared.startTrace(origin: .insight, target: .analysis)
      EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.insightCard, "analyze_insight"))
        let insightsStream = insightsForFieldUsecase.insights(forFieldId: insight.fieldId).take(1)
        let fieldStream = fieldUseCase.getFieldWithImages(fieldId: insight.fieldId)

      let irrigationInsightStream = insightsStream.castAndFilterElementsInSequence(IrrigationInsight.self)
      return Observable.zip(fieldStream, irrigationInsightStream)
        .observeOn(MainScheduler.instance)
        .do { (field, insights) in
        navigationEffect(field, insight, insights)
      }.map{_ in Mutation.unChange}

    case let .clickedField(navigationEffect):
      guard let insight = currentState.insight else { return .empty() }
      PerformanceManager.shared.startTrace(origin: .insight, target: .field)
      EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.insightCard, .textLinkClick, [EventParamKey.itemId: "insight_field"]))
      return fieldUseCase.getFieldWithImages(fieldId: insight.fieldId)
        .observeOn(MainScheduler.instance)
        .do(onNext: { field in
          navigationEffect(field)
        })
        .map { _ in Mutation.unChange }

    case let .drawerReachedMaxHeight(animateChange):
      var tracking = currentState.user!.tracking
      var trackingObs: Observable<Mutation> = .empty()
      if currentState.insightUid != WelcomeInsightsIds.irrigation.rawValue && (tracking.tsCardTooltipLastShown == nil || tracking.tsCardFirstOpen == nil) {
        tracking.tsCardFirstOpen = Date()
        trackingObs = updateTracking(user: currentState.user!, tracking: tracking)
      }
      return Observable.concat(.just(Mutation.changeBackButtonHeader(visibile: animateChange)), trackingObs)

    case let .clickBack(navigationEffect, showFeedbackDialog):
      EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.navigation, "insight_back_btn"))
      var resultObs: Observable<Mutation> = .just(.unChange)
      if let user = currentState.user {
        var tracking = user.tracking
        if shouldCountCardNotOpened(tracking: tracking, insightUid: currentState.insightUid) {
          tracking.insightsReadWithoutOpeningCard += 1
          resultObs = resultObs.concat(updateTracking(user: user, tracking: tracking))
        }
        if shouldShowFeedbackPopup(tracking: tracking) {
          tracking.tsFeedbackPopupLastShown = Date()
          resultObs = resultObs.concat(updateTracking(user: user, tracking: tracking))
          sawFeedbackWalkthrough = true
          showFeedbackDialog()
        } else {
          if let insight = currentState.insight, insight.feedback.rating == nil {
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.insight, .sawInsightWithoutRating, [EventParamKey.sawFeedBackWalkthrough: sawFeedbackWalkthrough.description]))
          }
          navigationEffect()
        }
      }
      return resultObs
    case .shownCardTooltip:
      var tracking = currentState.user!.tracking
      tracking.tsCardTooltipLastShown = Date()
      return updateTracking(user: currentState.user!, tracking: tracking)
    case .shownComparePopUp:
      var tracking = currentState.user!.tracking
      tracking.tsSawComparePopup = Date()
      return updateTracking(user: currentState.user!, tracking: tracking)
    case let .shareInsight(shareEffect: shareEffect, view: view):
      guard let insight = currentState.insight else { return .empty() }
      EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.insightCard, "share"))
      let insightDateFormated: String = dateProvider.format(date: insight.imageDate, format: .short)
      var components = DeepLinkingSettings.universalLinkShareBaseUrlComponents
      components.path = "/i/\(currentState.insightUid)"
      let textToShare: String = R.string.localizable.insightShareInsight_IOS(insightDateFormated, insight.fieldName, insight.subject, components.url!.absoluteString)

      shareEffect(textToShare, view)
      return Observable.just(Mutation.unChange)
    case let .analyticsInsightView(insight: insight):
      reportInsightView(insight: insight)
      return .empty()
    case .setIsFieldOwner(isOwner: let isOwner):
      return Observable.just(Mutation.setIsFieldOwner(isOwner: isOwner))
    case .reportScreenView:
        let screenViewParams = [
            AnalyticsParameterScreenName: ScreenName.insight,
            AnalyticsParameterScreenClass: String(describing: InsightViewController.self),
            EventParamKey.category: EventCategory.field,
            EventParamKey.fieldId: currentState.insight?.fieldId,
            EventParamKey.farmId: currentState.insight?.farmId,
            EventParamKey.cycleId: currentState.insight?.cycleId,
            EventParamKey.insightUid: currentState.insight?.uid,
            EventParamKey.insightCategory: currentState.insight?.category,
            EventParamKey.insightType: currentState.insight?.type
        ] as [String : Any]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
        return .empty()
    }
  }

  private func reportInsightView(insight: IrrigationInsight) {
    let analyticsParams = [
      EventParamKey.fieldId: "\(insight.fieldId)",
      EventParamKey.insightUid: insight.uid,
      EventParamKey.origin: origin,
      EventParamKey.insightType: insight.type,
    ]
    EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.insight, .insightView, analyticsParams))
  }

  private func trackPerformances(insight: IrrigationInsight, origin: String) {
    var params = [EventParamKey.insightUid: insight.uid,
                  EventParamKey.fieldId: "\(insight.fieldId)",
                  EventParamKey.origin: origin]
    if let elapsedTime = AnalyticsMeasure.sharedInstance.elapsedTime(label: Events.openToInsight.rawValue) {
      params[EventParamKey.value] = "\(elapsedTime)"
      EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.insight, .openToInsight, params))
    }
  }

  private func updateTracking(user: User, tracking: UserTracking) -> Observable<Mutation> {
    var updatedUser = user
    return updateUserParamsUsecase.updateTracking(tracking: tracking)
      .map { tracking in
        updatedUser.tracking = tracking
        return Mutation.updateUser(user: updatedUser)
      }
  }

  private func shouldCountCardNotOpened(tracking: UserTracking, insightUid: String) -> Bool {
    return !(tracking.tsCardFirstOpen != nil || tracking.tsCardTooltipLastShown != nil) && insightUid != WelcomeInsightsIds.irrigation.rawValue
  }

  private func shouldShowFeedbackPopup(tracking: UserTracking) -> Bool {
    guard Defaults.impersonatorId == nil else { return false }
    if tracking.insightsFirstReadWithoutFeedback > 2 {
      guard let tsFeedbackPopupLastShown = tracking.tsFeedbackPopupLastShown else { return true }
      return (tsFeedbackPopupLastShown + 3.weeks).isBeforeDate(Date(), granularity: .hour)
    }
    return false
  }

  func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {
    case let .setData(insight, user):
      return state.with {
        $0.insight = insight
        $0.user = user
      }

    case let .updateUser(user):
      return state.with {
        $0.user = user
      }

    case .unChange:
      let newState: State = state
      return newState

    case let .setFeedback(feedback):
      guard let insight = state.insight else { return state }
      let newState = state.with {
        $0.insight!.feedback = feedback
      }
      return newState

    case let .changeBackButtonHeader(visibile):
      let newState = state.with {
        $0.showBackButtonHeader = visibile
      }
      return newState
    case .setIsFieldOwner(isOwner: let isOwner):
      return state.with {
        $0.isFieldOwner = isOwner
      }
    }
  }
}
