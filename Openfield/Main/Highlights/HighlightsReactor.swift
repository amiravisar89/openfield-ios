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

final class HighlightsReactor: Reactor {

    var initialState: State
    let getHighlightsUseCase: GetHighlightsUseCaseProtocol
    let getSupportedInsightUseCase : GetSupportedInsightUseCaseProtocol
    let disposeBag = DisposeBag()

    init(getHighlightsUseCase: GetHighlightsUseCaseProtocol, getSupportedInsightUseCase : GetSupportedInsightUseCaseProtocol, fieldId: Int? = nil, categoryId: String? = nil) {
        self.getHighlightsUseCase = getHighlightsUseCase
        self.getSupportedInsightUseCase = getSupportedInsightUseCase
        initialState = State(loading: true, pageTitle: nil, highlights: [])

        var highlightsStream : Observable<[SectionHighlightItem]> = Observable.empty()
        if let fieldId = fieldId, let categoryId = categoryId {
            highlightsStream = getHighlightsUseCase.highlights(byFieldId: fieldId, byCategory: categoryId)
        } else {
            highlightsStream = getHighlightsUseCase.highlights()
        }
        
        highlightsStream
            .map {.setHighlights(highlights: $0)}
            .bind(to: action)
            .disposed(by: disposeBag)
        
        Observable.just(Action.setPageTitle(title: getPagetitle(categoryId: categoryId)))
            .bind(to: action)
            .disposed(by: disposeBag)
    }

    enum Action {
        case setPageTitle(title : String)
        case setHighlights(highlights : [SectionHighlightItem])
        case clickOnItem(index: Int, highlightItem: HighlightItem, navigation: (HighlightItem) -> Void)
        case analyticsScroll(reachesEnd: Bool)
    }

    enum Mutation {
        case setHighlights(highlights : [SectionHighlightItem])
        case setPageTitle(title : String)
    }

    struct State: Then {
        var loading: Bool
        var pageTitle : String?
        var highlights: [SectionHighlightItem]
    }

    func mutate(action: HighlightsReactor.Action) -> Observable<HighlightsReactor.Mutation> {
        switch action {
        case .setHighlights(highlights: let highlights):
            onHighlightsLoaded(highlights: highlights)
            return .just(.setHighlights(highlights: highlights))
        case .clickOnItem(index: let index, highlightItem: let highlightItem, navigation: let navigation):
            switch highlightItem.type {
            case .insight(let insight, _):
                if insight is IrrigationInsight {
                    PerformanceManager.shared.startTrace(origin: .highlights_list, target: .irrigation_insight)
                } else {
                    PerformanceManager.shared.startTrace(origin: .highlights_list, target: .location_insight)
                }
            case .empty:
                break
            }
            
            onHighlightClick(index: index, highlightItem: highlightItem)
            navigation(highlightItem)
            return Observable.empty()
        case .setPageTitle(title: let title):
            return .just(.setPageTitle(title: title))
        case .analyticsScroll(let reachesEnd):
            onHighlightsListScroll(reachesEnd: reachesEnd)
            return Observable.empty()
        }
        
    }

    func reduce(state: HighlightsReactor.State, mutation: HighlightsReactor.Mutation) -> HighlightsReactor.State {
        switch mutation {
        case .setHighlights(highlights: let highlights):
            return state.with {
                $0.loading = false
                $0.highlights = highlights
            }
        case .setPageTitle(title: let title):
            return state.with {
                $0.pageTitle = title
            }
        }
    }
    
    private func getPagetitle (categoryId: String?) -> String {
        guard let category = categoryId,
              let config = getSupportedInsightUseCase.supportedInsights()[category],
              let displayName = config.insightDisplayName else {return R.string.localizable.highlightsHighlights()}
        return displayName.title
    }
    
    // MARK: - analytics

    private func onHighlightsLoaded(highlights: [SectionHighlightItem]) {
        let parameters: [String: String] = [
            EventParamKey.itemId: "all_highlights",
            EventParamKey.numHighlightsShowAll : String(highlights.count),
        ]
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.highlight, .impression, parameters))
    }

    private func onHighlightsListScroll(reachesEnd: Bool) {
        var parameters = [String: String]()
        parameters[EventParamKey.itemId] = "scroll_highlights_page"
        parameters[EventParamKey.scrollAll] = String(reachesEnd)
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.highlight, .scroll, parameters))
    }

    private func onHighlightClick(index: Int, highlightItem: HighlightItem) {
        var highlightedInsight: Insight
        switch (highlightItem.type) {
        case let .insight(insight, _):
            highlightedInsight = insight
            break;
        case .empty:
            return
        }
        var parameters = [String: String]()
        parameters[EventParamKey.itemId] = "highlight_view"
        parameters[EventParamKey.fieldId] = String(highlightedInsight.fieldId)
        parameters[EventParamKey.insightUid] = String(highlightedInsight.uid)
        parameters[EventParamKey.fromDate] = String(Int(highlightedInsight.publishDate.timeIntervalSince1970 * 1000))
        parameters[EventParamKey.position] = String(index)
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.highlight, .highlightClick, parameters))
    }

}

