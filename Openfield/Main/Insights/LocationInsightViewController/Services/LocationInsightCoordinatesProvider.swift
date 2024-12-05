//
//  LocationInsightCoordinatesProvider.swift
//  Openfield
//
//  Created by amir avisar on 20/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import UIKit

struct LocationCoordinateViewModel {
    var id: Int
    var color: UIColor
    var longitude: Double
    var latitude: Double
}

protocol LocationColorProvider: IsLocationInsightProvider {
    func colors(insightItemsCount: Int) -> [UIColor]
    // for location in a selected item
    func getColor(forLocation location: Location, forInsight: LocationInsight, at index: Int) -> UIColor
    // for any location
    func getColor(forLocation location: Location, byItems items: [LocationInsightItem], insight: LocationInsight) -> UIColor

    func getColor(forItemAtIndex index: Int?, forInsight insight: LocationInsight, locationSelected: Location?) -> UIColor

    func getColor(for location: Location, by enhanceData: LocationInsightEnhanceData) -> UIColor
}

class LocationInsightCoordinatesProvider {
    let locationColorsProviders: [LocationColorProvider]

    init(locationColorsProviders: [LocationColorProvider]) {
        self.locationColorsProviders = locationColorsProviders
    }

    func provide(locationInsight: LocationInsight, locations: [Location]?, index: Int) -> [LocationCoordinateViewModel] {
        let optionalProvider = locationColorsProviders.first(where: { $0.canProvide(for: locationInsight) })
        guard let provider = optionalProvider else {
            return []
        }
        return locations?.map { location -> LocationCoordinateViewModel in
            let dotColor: UIColor!
            if index == 0 {
                dotColor = provider.getColor(forLocation: location, byItems: locationInsight.items, insight: locationInsight)
            } else {
                let itemIndex = index - 1
                dotColor = provider.getColor(forLocation: location, forInsight: locationInsight, at: itemIndex)
            }
            return LocationCoordinateViewModel(id: location.id, color: dotColor, longitude: location.longitude, latitude: location.latitude)
        } ?? [LocationCoordinateViewModel]()
    }
}

class SingleLocationInsightColorProvider: LocationColorProvider {
    func getColor(for _: Location, by _: LocationInsightEnhanceData) -> UIColor {
        return R.color.meidumContrastYellow()!
    }

    func colors(insightItemsCount _: Int = .zero) -> [UIColor] {
        return [R.color.meidumContrastYellow()!]
    }

    func getColor(forLocation _: Location, forInsight _: LocationInsight, at _: Int) -> UIColor {
        return R.color.meidumContrastYellow()!
    }

    func getColor(forLocation _: Location, byItems _: [LocationInsightItem], insight _: LocationInsight) -> UIColor {
        return R.color.meidumContrastYellow()!
    }

    func canProvide(for insight: LocationInsight) -> Bool {
        return insight is SingleLocationInsight
    }

    func getColor(forItemAtIndex _: Int?, forInsight _: LocationInsight, locationSelected _: Location?) -> UIColor {
        return R.color.meidumContrastYellow()!
    }
}

class EnhancedLocationInsightColorProvider: LocationColorProvider {
    func getColor(for location: Location, by enhanceData: LocationInsightEnhanceData) -> UIColor {
        guard let selectedLevel = enhanceData.ranges.levels.first(where: { $0.locationIds.contains(location.id) }) else { return UIColor.white.withAlphaComponent(0.5) }
        return selectedLevel.color
    }

    func colors(insightItemsCount _: Int = .zero) -> [UIColor] {
        return [R.color.enhancedLocationColor()!]
    }

    func getColor(forLocation location: Location, forInsight insight: LocationInsight, at index: Int) -> UIColor {
        guard insight.items.indices.contains(index), let itemEnhanceData = insight.items[index].enhanceData else { return .clear }
        return getColor(for: location, by: itemEnhanceData)
    }

    func getColor(forLocation location: Location, byItems _: [LocationInsightItem], insight: LocationInsight) -> UIColor {
        guard let insight = insight as? EnhancedLocationInsight else { return .clear }
        return getColor(for: location, by: insight.enhanceData)
    }

    func canProvide(for insight: LocationInsight) -> Bool {
        return insight is EnhancedLocationInsight
    }

    func getColor(forItemAtIndex index: Int?, forInsight insight: LocationInsight, locationSelected: Location?) -> UIColor {
        guard let index = index,
              let itemEnhanceData = insight.items[index].enhanceData,
              let lcoation = locationSelected
        else { return R.color.enhancedLocationColor()! }

        return getColor(for: lcoation, by: itemEnhanceData)
    }
}

class IssueLocationInsightColorProvider: LocationColorProvider {
    func getColor(for _: Location, by _: LocationInsightEnhanceData) -> UIColor {
        return .clear
    }

    func colors(insightItemsCount _: Int = .zero) -> [UIColor] {
        return StyleGuideColor.issueLocationColors.getUIColors()
    }

    func getColor(forLocation location: Location, forInsight insight: LocationInsight, at index: Int) -> UIColor {
        return location.issuesIds.contains(insight.items[index].id) ? colors()[index % colors().count] : .clear
    }

    func getColor(forLocation location: Location, byItems _: [LocationInsightItem], insight _: LocationInsight) -> UIColor {
        return location.issuesIds.isEmpty ? UIColor.white.withAlphaComponent(0.5) : UIColor.white
    }

    func canProvide(for insight: LocationInsight) -> Bool {
        return insight is IssueLocationInsight
    }

    func getColor(forItemAtIndex index: Int?, forInsight _: LocationInsight, locationSelected _: Location?) -> UIColor {
        if let index = index {
            return colors()[index % colors().count]
        }
        return R.color.valleyBrand()!
    }
}

class EmptyLocationInsightColorProvider: LocationColorProvider {
    func getColor(for _: Location, by _: LocationInsightEnhanceData) -> UIColor {
        return .clear
    }

    func colors(insightItemsCount _: Int = .zero) -> [UIColor] {
        return [UIColor.white.withAlphaComponent(0.5)]
    }

    func getColor(forLocation _: Location, forInsight _: LocationInsight, at _: Int) -> UIColor {
        return colors()[0]
    }

    func getColor(forLocation _: Location, byItems _: [LocationInsightItem], insight _: LocationInsight) -> UIColor {
        return colors()[0]
    }

    func getColor(forItemAtIndex _: Int?, forInsight _: LocationInsight, locationSelected _: Location?) -> UIColor {
        return .clear
    }

    func canProvide(for insight: LocationInsight) -> Bool {
        insight is EmptyLocationInsight
    }
}

class RangedLocationInsightColorProvider: LocationColorProvider {
    func getColor(for _: Location, by _: LocationInsightEnhanceData) -> UIColor {
        return .clear
    }

    func colors(insightItemsCount: Int) -> [UIColor] {
        StyleGuideColor.rangedLocationColors.getUIColors(itemsCount: insightItemsCount)
    }

    let rangedLocationPresentedItemProvider: RangedLocationPresentedItemProvider

    init(rangedLocationPresentedItemProvider: RangedLocationPresentedItemProvider) {
        self.rangedLocationPresentedItemProvider = rangedLocationPresentedItemProvider
    }

    func canProvide(for insight: LocationInsight) -> Bool {
        return insight is RangedLocationInsight
    }

    func getColor(forLocation location: Location, forInsight insight: LocationInsight, at index: Int) -> UIColor {
        guard let itemIndex = getIndexFromPresentedIndex(presentedIndex: index, insight: insight) else {
            return R.color.valleyBrand()!
        }
        let presentedItemId = insight.items[itemIndex].id
        let insightColors = colors(insightItemsCount: insight.items.count)
        let color = location.issuesIds.contains(presentedItemId) ? insightColors[itemIndex % insightColors.count] : UIColor.white.withAlphaComponent(0.5)
        return color
    }

    func getColor(forLocation location: Location, byItems items: [LocationInsightItem], insight _: LocationInsight) -> UIColor {
        if let locationRelatedItemIndex = items.firstIndex(where: { location.issuesIds.contains($0.id) }) {
            let insightColors = colors(insightItemsCount: items.count)
            return insightColors[locationRelatedItemIndex % insightColors.count]
        }
        return .clear
    }

    func getColor(forItemAtIndex index: Int?, forInsight insight: LocationInsight, locationSelected _: Location?) -> UIColor {
        guard let index = index, let colorIndex = getIndexFromPresentedIndex(presentedIndex: index, insight: insight) else {
            return R.color.valleyBrand()!
        }
        let insightColors = colors(insightItemsCount: insight.items.count)
        return insightColors[colorIndex % insightColors.count]
    }

    private func getIndexFromPresentedIndex(presentedIndex: Int, insight: LocationInsight) -> Int? {
        let preesentedItems = rangedLocationPresentedItemProvider.provide(forInsight: insight)
        return insight.items.firstIndex { $0.id == preesentedItems[presentedIndex].id }
    }
}
