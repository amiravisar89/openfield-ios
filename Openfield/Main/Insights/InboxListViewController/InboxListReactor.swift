//
//  InboxListReactor.swift
//  Openfield
//
//  Created by Itay Kaplan on 25/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Dollar
import Foundation
import ReactorKit
import Resolver
import RxCocoa
import RxSwift
import SwiftDate
import SwiftyUserDefaults
import Then

final class InboxListReactor: Reactor {
    let disposeBag = DisposeBag()
    let farmFilter: FarmFilter = Resolver.resolve()
    let throttleInterval = RxTimeInterval.seconds(3)

    var initialState: State = .init(
        user: nil,
        isLoading: true,
        displayingUnread: false,
        showError: false,
        sectionItems: [],
        presentedInboxItems: [],
        unreadItemsCount: 0,
        allItemsCount: 0,
        allItemsWithFilterCount: 0,
        showFilterEmptyState: false,
        presentedItems: [],
        showUnreadEmptyState: false,
        insights: [],
        imageries: [],
        farms: []
    )
    let updateUseParamsUsecase: UpdateUserParamsUsecaseProtocol
    var dateProvider: DateProvider
    let insightsUseCase : InsightsFromDateUsecaseProtocol
    let getFeedMinDateUseCase : GetFeedMinDateUseCaseProtocol
    let userUseCase: UserStreamUsecaseProtocol
    let getImageryUsecase: GetImageryUsecaseProtocol

    init(dateProvider: DateProvider, insightsUseCase : InsightsFromDateUsecaseProtocol, getFeedMinDateUseCase : GetFeedMinDateUseCaseProtocol, userUseCase: UserStreamUsecaseProtocol, getImageryUsecase: GetImageryUsecaseProtocol, updateUseParamsUsecase: UpdateUserParamsUsecaseProtocol) {
        self.updateUseParamsUsecase = updateUseParamsUsecase
        self.dateProvider = dateProvider
        self.insightsUseCase = insightsUseCase
        self.getFeedMinDateUseCase = getFeedMinDateUseCase
        self.userUseCase = userUseCase
        self.getImageryUsecase = getImageryUsecase

        Observable.combineLatest(insightsUseCase.getInsights(insightsFromDate: getFeedMinDateUseCase.date(), limit: nil), getImageryUsecase.imageries(), farmFilter.farms)
            .map { Action.setData(insights: $0.0, imageries: $0.1, farms: $0.2) }
            .bind(to: action)
            .disposed(by: disposeBag)

        userUseCase.userStream()
            .map { Action.setUser(user: $0) }
            .bind(to: action)
            .disposed(by: disposeBag)
    }

    enum Action {
        case updateUserSawSubscribePopup
        case updateUserClickedSubscribePopup
        case updateUserSeenRole
        case updateUserSeenFieldTooltip
        case clickToggleShowUnreadAll
        case resetFarmFilter
        case reloadList
        case setData(insights: [Insight], imageries: [Imagery], farms: [FilteredFarm])
        case updateUserRole(role: UserRole)
        case clickOnItem(inboxItem: InboxItem)
        case setInsights(insights: [Insight])
        case setImageries(imageries: [Imagery])
        case setUser(user: User?)
    }

    enum Mutation {
        case unChange
        case showAll
        case showUnread
        case showError
        case startReload
        case setShowUnreadEmptyState(show: Bool)
        case setShowFilterEmptyState(show: Bool)

        case setInsights(insights: [Insight])
        case setImageries(imageries: [Imagery])
        case setFarms(farms: [FilteredFarm])
        case setUser(user: User?)

        case setPresentedInboxItems(items: [InboxItem])
        case setSectionItems(items: [SectionInboxItem])
        case setPresentedItems(items: [SectionInboxItem])
        case setIsLoading(isLoading: Bool)

        case setUnreadCount(count: Int)
        case setReadCount(count: Int)
    }

    struct State: Then {
        let farmFilter: FarmFilter = Resolver.resolve()
        var user: User?
        var isLoading: Bool
        var displayingUnread: Bool
        var showError: Bool
        var sectionItems: [SectionInboxItem]
        var presentedInboxItems: [InboxItem]
        var unreadItemsCount: Int
        var allItemsCount: Int
        var allItemsWithFilterCount: Int
        var showFilterEmptyState: Bool
        var presentedItems: [SectionInboxItem]
        var showUnreadEmptyState: Bool

        var insights: [Insight]
        var imageries: [Imagery]
        var farms: [FilteredFarm]
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setData(insights: insights, imageries: imageries, farms: farms):

            let insightsObs = Observable.just(Mutation.setInsights(insights: insights))
            let imageryObs = Observable.just(Mutation.setImageries(imageries: imageries))

            let isLoadingObs = Observable.just(Mutation.setIsLoading(isLoading: !(!insights.isEmpty || !imageries.isEmpty)))
            let farmFilterItems = filteredByFarms(insights: insights, imageries: imageries, farms: farms)

            let sectionsItems = getSectionItems(items: farmFilterItems)
            let unreadSectionsItems = filterByUnread(sections: sectionsItems)
            let unreadCountObs = Observable.just(Mutation.setUnreadCount(count: farmFilterItems.filter { !$0.isRead }.count))
            let readCountObs = Observable.just(Mutation.setReadCount(count: farmFilterItems.count))
            let sectionObs = Observable.just(Mutation.setSectionItems(items: sectionsItems))
            let setPresentedInboxItems = Observable.just(Mutation.setPresentedInboxItems(items: farmFilterItems))

            let showUnreadEmptyStateObs = Observable.just(Mutation.setShowUnreadEmptyState(show: currentState.displayingUnread && farmFilterItems.filter { !$0.isRead }.isEmpty))
            let showFilterEmptyStateObs = Observable.just(Mutation.setShowFilterEmptyState(show: farmFilterItems.isEmpty))

            let setPresentedObs = Observable.just(Mutation.setPresentedItems(items: currentState.displayingUnread ? unreadSectionsItems : sectionsItems))
            let setFarmObs = Observable.just(Mutation.setFarms(farms: farms))

            return Observable.concat(insightsObs,
                                     imageryObs,
                                     setPresentedInboxItems,
                                     sectionObs,
                                     unreadCountObs,
                                     readCountObs,
                                     setPresentedObs,
                                     showUnreadEmptyStateObs,
                                     showFilterEmptyStateObs,
                                     setFarmObs,
                                     isLoadingObs)

        case .resetFarmFilter:
            farmFilter.resetFarms()
            return Observable.empty()

        case let .clickOnItem(inboxItem):
            if case let .insight(insight) = inboxItem.type {
                EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.feedList, .feedInsightClick, [EventParamKey.insightUid: insight.uid, EventParamKey.fieldId: "\(insight.fieldId)"]))
            } else if case let .locationInsight(insight) = inboxItem.type {
                EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.feedList, .feedInsightClick, [EventParamKey.insightUid: insight.uid, EventParamKey.fieldId: "\(insight.fieldId)"]))
            } else if case let .imagery(imagery) = inboxItem.type {
                EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.feedList, .feedImageryClick, [EventParamKey.imageryDate: dateProvider.format(date: imagery.date, format: .short)]))
            } 
            return Observable.empty()

        case .clickToggleShowUnreadAll:
            if currentState.displayingUnread {
                let allItems = currentState.sectionItems
                let presentedItemsObs = Observable.just(Mutation.setPresentedItems(items: allItems))
                let showAllObs = Observable.just(Mutation.showAll)
                let showUnreadEmptyStateObs = Observable.just(Mutation.setShowUnreadEmptyState(show: false))
                trackFilterClick(showAll: true)
                return Observable.concat(presentedItemsObs, showUnreadEmptyStateObs, showAllObs)
            } else {
                let unreadFilteredItems = filterByUnread(sections: currentState.sectionItems)
                let presentedItemsObs = Observable.just(Mutation.setPresentedItems(items: unreadFilteredItems))
                let showUnreadObs = Observable.just(Mutation.showUnread)
                let showUnreadEmptyStateObs = Observable.just(Mutation.setShowUnreadEmptyState(show: unreadFilteredItems.flatMap { $0.items }.filter { !$0.isRead }.count == 0))
                trackFilterClick(showAll: false)
                return Observable.concat(presentedItemsObs,
                                         showUnreadEmptyStateObs,
                                         showUnreadObs)
            }
        case let .updateUserRole(role: role):
            let result = updateUseParamsUsecase
                .changeUserRole(user: currentState.user!, role: role)
                .map { _ in Mutation.unChange }
            return result

        case .updateUserSeenRole:
            let result = updateUseParamsUsecase.updateUserRoleSeen(user: currentState.user!, timeStamp: Date())
                .map { _ in Mutation.unChange }
            return result

        case .updateUserSeenFieldTooltip:
            let result = updateUseParamsUsecase.updateUserFieldTooltipSeen(user: currentState.user!, timeStamp: Date())
                .map { _ in Mutation.unChange }
            return result

        case .updateUserSawSubscribePopup:
            var tracking = currentState.user!.tracking
            tracking.tsSawSubscribePopUp = Date()
            let result = updateUseParamsUsecase
                .updateTracking(tracking: tracking)
                .map { _ in Mutation.unChange }
            return result

        case .updateUserClickedSubscribePopup:
            var tracking = currentState.user!.tracking
            tracking.tsClickedSubscribePopUp = Date()
            let result = updateUseParamsUsecase
                .updateTracking(tracking: tracking)
                .map { _ in Mutation.unChange }
            return result

        case let .setInsights(insights: insights):
            return Observable.just(Mutation.setInsights(insights: insights))

        case let .setImageries(imageries: imageries):
            return Observable.just(Mutation.setImageries(imageries: imageries))

        case let .setUser(user: user):
            return Observable.just(Mutation.setUser(user: user))
        case .reloadList:
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.feedList, "feed_error_reload"))
            let startReload = Observable.just(Mutation.startReload)
            return startReload
        }
    }

    private func trackFilterClick(showAll: Bool) {
        var variant = ""
        var count = ""

        if showAll {
            variant = "all"
            count = "\(currentState.allItemsCount)"
        } else {
            variant = "unread"
            count = "\(currentState.unreadItemsCount)"
        }
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.feedFilters, .labelClick, [EventParamKey.itemId: "feed_filters",
                                                                                                            EventParamKey.itemVariant: variant,
                                                                                                            EventParamKey.filterCount: count]))
    }

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .unChange:
            return state

        case .showAll:
            return state.with {
                $0.displayingUnread = false
            }
        case .showUnread:
            return state.with {
                $0.displayingUnread = true
            }

        case .showError:
            return state.with {
                $0.showError = true
                $0.isLoading = false
            }
        case let .setShowFilterEmptyState(show: show):
            return state.with {
                $0.showFilterEmptyState = show
            }
        case let .setInsights(insights: insights):
            return state.with {
                $0.insights = insights
            }
        case let .setImageries(imageries: imageries):
            return state.with {
                $0.imageries = imageries
            }
        case let .setFarms(farms: farms):
            return state.with {
                $0.farms = farms
            }
        case let .setUser(user: user):
            return state.with {
                $0.user = user
            }
        case let .setSectionItems(items: items):
            return state.with {
                $0.sectionItems = items
            }
        case let .setPresentedItems(items: items):
            
            return state.with {
                $0.presentedItems = items
            }
        case let .setIsLoading(isLoading: isLoading):
            return state.with {
                $0.isLoading = isLoading
            }
        case let .setUnreadCount(count: count):
            return state.with {
                $0.unreadItemsCount = count
            }
        case let .setReadCount(count: count):
            return state.with {
                $0.allItemsCount = count
            }
        case let .setShowUnreadEmptyState(show: show):
            return state.with {
                $0.showUnreadEmptyState = show
            }
        case let .setPresentedInboxItems(items: items):
            return state.with {
                $0.presentedInboxItems = items
            }
        case .startReload:
            return state.with {
                $0.isLoading = true
                $0.showError = false
            }

        }
    }

    private func trackPerformanceToFeed(inboxItemsCount: Int) {
        if let elapsedTime = AnalyticsMeasure.sharedInstance.elapsedTime(label: Events.loginToFeed.rawValue) {
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.feed, .loginToFeed, [EventParamKey.value: "\(elapsedTime)",
                                                                                                          EventParamKey.itemCount: "\(inboxItemsCount)"]))
        }

        if let elapsedTime = AnalyticsMeasure.sharedInstance.elapsedTime(label: Events.openToFeed.rawValue) {
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.feed, .openToFeed, [EventParamKey.value: "\(elapsedTime)",
                                                                                                         EventParamKey.itemCount: "\(inboxItemsCount)"]))
        }
    }

    private func getSectionItems(items: [InboxItem]) -> [SectionInboxItem] {
        let sectionItemsHash = Dollar.groupBy(items) { item -> String in
            String(format: "%d %d", item.date.weekInYearNum, item.date.year)
        }
        let sectionItems = sectionItemsHash.compactMap { (weekUniqueId: String, items: [InboxItem]) -> SectionInboxItem? in
            let sortedItems = items.sorted { $0.date > $1.date }
            guard let firstItemDate = sortedItems.first else { return nil }
            return SectionInboxItem(startDate: firstItemDate.date.startOfWeek, endDate: firstItemDate.date.endOfWeek, items: sortedItems, id: weekUniqueId)
        }
        return sectionItems.sorted(by: { $0.startDate > $1.startDate })
    }

    private func filterByUnread(sections: [SectionInboxItem]) -> [SectionInboxItem] {
        return sections.map { sectionItem -> SectionInboxItem in
            SectionInboxItem(startDate: sectionItem.startDate, endDate: sectionItem.endDate, items: sectionItem.items.filter { !$0.isRead }, id: sectionItem.id)
        }.filter { !$0.items.isEmpty }
    }

    private func filteredByFarms(insights: [Insight], imageries: [Imagery], farms: [FilteredFarm]) -> [InboxItem] {
        let farmsSelected = farms.filter { $0.isSelected }
        let farmsSelectedName = farmsSelected.map { $0.name }
        let isAllFarmsSelected = farmsSelected.count == farms.count

        let filteredInsights = insights.filter { isAllFarmsSelected ? true : farmsSelectedName.contains($0.farmName) }.map {
            InboxItem(type: InboxItemType.getInboxItemType(for: $0), identity: $0.id, isRead: $0.isRead, date: $0.publishDate)
        }

        let filteredImagery: [InboxItem] = imageries.compactMap { imagery in
            let filteredImages = imagery.images.filter { farmsSelectedName.contains($0.field.farmName) }
            guard !filteredImages.isEmpty else { return nil }
            return Imagery(images: filteredImages, date: imagery.date, region: imagery.region, isRead: imagery.isRead)
        }.compactMap { imagery in
            InboxItem(type: .imagery(imagery: imagery), identity: imagery.identity, isRead: imagery.isRead, date: imagery.date)
        }

        return filteredInsights + filteredImagery
    }
}
