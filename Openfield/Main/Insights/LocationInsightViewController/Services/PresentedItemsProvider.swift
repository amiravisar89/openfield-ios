//
//  PresentedItemsProvider.swift
//  Openfield
//
//  Created by Itay Kaplan on 28/02/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

protocol PresentedItemsProvider {
    func canProvide(forInsight insight: LocationInsight) -> Bool
    func provide(forInsight insight: LocationInsight) -> [LocationInsightItem]
    func getIndexFromPresentedIndex(presentedIndex: Int, forInsight insight: LocationInsight) -> Int?
}

class LocationInsightPresentedItemsProvider {
    let presentedItemsProviders: [PresentedItemsProvider]

    init(presentedItemsProviders: [PresentedItemsProvider]) {
        self.presentedItemsProviders = presentedItemsProviders
    }

    func provide(forInsight insight: LocationInsight) -> [LocationInsightItem] {
        guard let provider = presentedItemsProviders.first(where: { $0.canProvide(forInsight: insight) }) else {
            return []
        }

        return provider.provide(forInsight: insight)
    }

    func getIndexFromPresentedIndex(presentedIndex: Int, forInsight insight: LocationInsight) -> Int? {
        guard let provider = presentedItemsProviders.first(where: { $0.canProvide(forInsight: insight) }) else {
            return nil
        }
        return provider.getIndexFromPresentedIndex(presentedIndex: presentedIndex, forInsight: insight)
    }
}

class SingleLocationPresentedItemProvider: PresentedItemsProvider {
    func canProvide(forInsight insight: LocationInsight) -> Bool {
        return insight is SingleLocationInsight
    }

    func provide(forInsight insight: LocationInsight) -> [LocationInsightItem] {
        return insight.items
    }

    func getIndexFromPresentedIndex(presentedIndex _: Int, forInsight _: LocationInsight) -> Int? {
        return 0
    }
}

class EnhancedLocationPresentedItemProvider: PresentedItemsProvider {
    func canProvide(forInsight insight: LocationInsight) -> Bool {
        return insight is EnhancedLocationInsight
    }

    func provide(forInsight insight: LocationInsight) -> [LocationInsightItem] {
        return insight.items
    }

    func getIndexFromPresentedIndex(presentedIndex: Int, forInsight _: LocationInsight) -> Int? {
        guard presentedIndex >= 0 else { return nil }
        return presentedIndex
    }
}

class IssueLocationPresentedItemProvider: PresentedItemsProvider {
    func canProvide(forInsight insight: LocationInsight) -> Bool {
        return insight is IssueLocationInsight
    }

    func provide(forInsight insight: LocationInsight) -> [LocationInsightItem] {
        return insight.items
    }

    func getIndexFromPresentedIndex(presentedIndex: Int, forInsight _: LocationInsight) -> Int? {
        guard presentedIndex >= 0 else { return nil }
        return presentedIndex
    }
}

class RangedLocationPresentedItemProvider: PresentedItemsProvider {
    func canProvide(forInsight insight: LocationInsight) -> Bool {
        return insight is RangedLocationInsight
    }

    func provide(forInsight insight: LocationInsight) -> [LocationInsightItem] {
        return insight.items.filter { $0.taggedImagesPercent > 0 }
    }

    func getIndexFromPresentedIndex(presentedIndex: Int, forInsight insight: LocationInsight) -> Int? {
        guard presentedIndex >= 0 else { return nil }
        let preesentedItems = provide(forInsight: insight)
        return insight.items.firstIndex { $0.id == preesentedItems[presentedIndex].id }
    }
}

class EmptyLocationPresentedItemProvider: PresentedItemsProvider {
    func canProvide(forInsight insight: LocationInsight) -> Bool {
        return insight is EmptyLocationInsight
    }

    func provide(forInsight insight: LocationInsight) -> [LocationInsightItem] {
        return insight.items
    }

    func getIndexFromPresentedIndex(presentedIndex _: Int, forInsight _: LocationInsight) -> Int? {
        return 0
    }
}
