//
//  AnalysisReactor.swift
//  Openfield
//
//  Created by Daniel Kochavi on 17/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import ReactorKit
import Resolver
import RxSwift
import SwiftDate
import Then
import FirebaseAnalytics

struct LayerCell: Then, Hashable {
    let imageType: AppImageType
    let image: String?
    var isEnabled: Bool = true
    var isSelected: Bool = false
    var issue: Issue?
}

struct DateCell: Then, Hashable {
    let index: Int
    var isCloudy: Bool = false
    let date: Date
    let region: Region
    var isEnabled: Bool = false
    var isSelected: Bool = false
    let sourceType: ImageSourceType
}

struct AnalysisParams {
    let fieldId: Int
    var initialDate: Date
    var initialLayer: AppImageType
    var forceInitialDate = false
    var field: Field? = nil
    var insight: IrrigationInsight? = nil
    var initialInsights: [IrrigationInsight]? = nil
    var origin: String
}

final class AnalysisReactor: Reactor {
    var initialState: AnalysisReactor.State = State(wrapper: AnalysisDataWrapper.empty, selectedInsightsCount: 0)
    var insightsByField: InsightsForFieldUsecaseProtocol
    var fieldUseCase : FieldUseCaseProtocol
    var anlysysParam: AnalysisParams!
    private var disposeBag = DisposeBag()

    typealias VoidEffect = () -> Void
    typealias IntEffect = (Int) -> Void

    enum Action {
        case setWrapper(wrapper: AnalysisDataWrapper)
        case tappedClose(navigationEffect: VoidEffect?)
        case tappedLayers(navigationEffect: VoidEffect?)
        case tappedDate(navigationEffect: VoidEffect?)
        case tappedInsights(navigationEffect: IntEffect?)
        case selectedLayer(layerCell: LayerCell)
        case selectedDate(dateCell: DateCell)
        case selectNextFlightDate(uiEffect: IntEffect?)
        case selectPreviousFlightDate(uiEffect: IntEffect?)
        case clickedInsight(indexPath: IndexPath)
    }

    enum Mutation {
        case setWrapper(wrapper: AnalysisDataWrapper)
        case unChange
        case changeLayer
        case changeDate
        case changeInsight(count: Int, insights: [IrrigationInsight])
    }

    struct State: Then {
        var wrapper: AnalysisDataWrapper
        var selectedInsightsCount: Int

        var field: Field {
            wrapper.field
        }

        var isWrapperEmpty: Bool {
            wrapper.isEmpty
        }

        var insights: [IrrigationInsight] {
            wrapper.getInsights()
        }

        var layers: [LayerCell] {
            wrapper.getCurrentLayers()
        }

        var dates: [DateCell] {
            wrapper.dateCells
        }

        var currentLayer: LayerCell {
            wrapper.getCurrentLayer()
        }

        var currentDate: DateCell {
            wrapper.getCurrentDateCell()
        }

        var currentImages: [PreviewImage] {
            wrapper.getCurrentImage()
        }

        var currentBounds: ImageBounds {
            wrapper.getCurrentImageBounds()
        }

        var currentIssue: Issue? {
            wrapper.getCurrentIssue()
        }

        var currentInsights: String? {
            AnalysisReactor.getInsightsText(insights: insights)
        }

        var hasNextDate: Bool {
            wrapper.hasNextDate()
        }

        var hasPreviousDate: Bool {
            wrapper.hasPreviousDate()
        }
    }
  
    init(params: AnalysisParams, insightsByField: InsightsForFieldUsecaseProtocol, fieldUseCase : FieldUseCaseProtocol) {
        anlysysParam = params
        self.insightsByField = insightsByField
        self.fieldUseCase = fieldUseCase
        let insight = params.insight
        let initialInsights = params.initialInsights
        let field = params.field
        
        // Analytics
        let screenViewParams = [AnalyticsParameterScreenName: ScreenName.analysis,
                                AnalyticsParameterScreenClass: String(describing: AnalysisViewController.self),
                                EventParamKey.category: EventCategory.field,
                                EventParamKey.fieldId: field?.id,
                                EventParamKey.farmId: field?.farmId
        ] as [String : Any]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)

      let insightsObs = insightsByField.insights(forFieldId: params.fieldId).map { $0.filter { (insight: Insight) -> Bool in
            insight as? IrrigationInsight != nil
        } }.map { $0 as! [IrrigationInsight] }.take(1)

      let fieldObs = field == nil ? fieldUseCase.getFieldWithImages(fieldId: params.fieldId) : Observable.just(field!)

        let initialDate = params.forceInitialDate ? params.initialDate : insight?.imageDate ?? params.initialDate

        Observable.zip(fieldObs, insightsObs) { field, insights -> AnalysisDataWrapper in
  
            let wrapper = AnalysisDataWrapper(field: field, initialInsights: initialInsights, initialDate: initialDate, initialLayer: params.initialLayer, insights: insights, isEmpty: false)

            var currentImage = wrapper.getCurrentImage().first
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.analysis,
                                                                       .analysisView, [EventParamKey.origin: params.origin,
                                                                                       EventParamKey.fieldId: "\(wrapper.field.id)",
                                                                                       EventParamKey.imageId: "\(currentImage?.imageId)",
                                                                                       EventParamKey.insightUid: insight?.uid ?? ""]))
            return wrapper
        }.take(1)
            .map { Action.setWrapper(wrapper: $0) }
            .bind(to: action)
            .disposed(by: disposeBag)
    }

    func mutate(action: AnalysisReactor.Action) -> Observable<AnalysisReactor.Mutation> {
        let wrapper = currentState.wrapper
        switch action {
        case let .setWrapper(wrapper):
            return Observable.just(Mutation.setWrapper(wrapper: wrapper))
        case let .tappedClose(navigationEffect):
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.navigation, "analysis_back_btn"))
            navigationEffect?()
            return Observable.just(Mutation.unChange)
        case let .tappedDate(navigationEffect):
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.dateSelection, "analysis_date_selection"))
            navigationEffect?()
            return Observable.empty()

        case let .tappedLayers(navigationEffect):
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.layerSelection, "analysis_image_type"))
            navigationEffect?()
            return Observable.empty()

        case let .tappedInsights(navigationEffect):
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.detectionsSelection, "analysis_detections"))
            navigationEffect?(wrapper.getInsights().count)
            return Observable.empty()

        case let .selectedLayer(layer):
            guard layer.isEnabled else { return Observable.just(Mutation.unChange) }
            wrapper.changeLayer(layer: layer.imageType)
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.layerSelection, .layerSelected, [EventParamKey.itemId: layer.imageType.rawValue]))
            return Observable.just(Mutation.changeLayer)

        case let .selectedDate(dateCell):
            guard dateCell.isEnabled else { return Observable.just(Mutation.unChange) }
            wrapper.changeDate(to: dateCell.index)
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.dateSelection, .dateChanged, [EventParamKey.origin: "click"]))
            return Observable.just(Mutation.changeDate)

        case let .selectNextFlightDate(uiEffect):
            wrapper.changeToNextDate()
            uiEffect?(wrapper.getCurrentDateCell().index)
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.dateSelection, .dateChanged, [EventParamKey.origin: "next"]))
            return Observable.just(Mutation.changeDate)

        case let .selectPreviousFlightDate(uiEffect):
            wrapper.changeToPreviousDate()
            uiEffect?(wrapper.getCurrentDateCell().index)
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.dateSelection, .dateChanged, [EventParamKey.origin: "prev"]))
            return Observable.just(Mutation.changeDate)
        case let .clickedInsight(indexPath):
            let insight = wrapper.changeInsightSelectionState(index: indexPath.row)
            let insights = wrapper.getInsights()
            let selectedInsights = insights.filter { $0.isSelected }

            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.detectionsSelection,
                                                                       .itemToggle, [EventParamKey.insightUid: insight.uid,
                                                                                     EventParamKey.fieldId: "\(insight.fieldId)",
                                                                                     EventParamKey.totalItems: "\(insights.count)",
                                                                                     EventParamKey.visibileItems: "\(selectedInsights.count)"]))
            return Observable.just(Mutation.changeInsight(count: selectedInsights.count, insights: selectedInsights))
        }
    }

    private static func getInsightsText(insights: [IrrigationInsight]) -> String? {
        let dateProvider: DateProvider = Resolver.resolve()
        if insights.isEmpty { return nil }
        let selectedInsightsCount = insights.filter { $0.isSelected }.count
        switch selectedInsightsCount {
        case 0:
            return R.string.localizable.analysisSelectInsights()
        case 1:
            let selectedInsight = insights.first { $0.isSelected }!
            return dateProvider.format(date: selectedInsight.publishDate, format: .short)
        default:
            return R.string.localizable.analysisMultipleInsightsSelected_IOS("\(selectedInsightsCount)")
        }
    }

    func reduce(state: AnalysisReactor.State, mutation: AnalysisReactor.Mutation) -> AnalysisReactor.State {
        switch mutation {
        case let .setWrapper(wrapper):
            let newState: State = state.with {
                $0.wrapper = wrapper
            }
            return newState
        case .unChange:
            let newState: State = state
            return newState
        case .changeLayer:
            anlysysParam.initialLayer = state.currentLayer.imageType
            NSLog("Wrapper : changeLayer")
            let newState: State = state
            return newState
        case .changeDate:
            anlysysParam.initialDate = state.currentDate.date
            let newState: State = state
            return newState
        case let .changeInsight(count, insights):
            anlysysParam.initialInsights = insights
            let newState: State = state.with {
                $0.selectedInsightsCount = count
            }
            return newState
        }
    }
}
