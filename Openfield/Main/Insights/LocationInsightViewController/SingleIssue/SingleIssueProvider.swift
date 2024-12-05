//
//  SingleIssueProvider.swift
//  Openfield
//
//  Created by Itay Kaplan on 07/02/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import UIKit

protocol SingleIssueProvider {
    func canProvide(forInsight locationInsight: LocationInsight) -> Bool
    func provide(forInsight locationInsight: LocationInsight, locationSelected: Location?, forItemIndex index: Int?, withColor color: UIColor) -> SingleIssueViewModel?
    func provide(imageGalleryByLocations locations: [Location]?, forIssueIndex index: Int, forInsight insight: LocationInsight) -> [LocationImageMeatadata]
    func shouldBuildImagesGallery(forIssueIndex index: Int) -> Bool
    func provide(forInsight locationInsight: LocationInsight, selectedIndex: Int, images: [LocationImageMeatadata], cardIndex: Int, tagColor: UIColor, issueIndex: Int?) -> [AppImageGalleyElement]?
}

extension SingleIssueProvider {
    func provide(imageGalleryByLocations locations: [Location]?, forIssueIndex index: Int, forInsight insight: LocationInsight) -> [LocationImageMeatadata] {
        let images = locations?.flatMap {
            $0.images.filter { $0.itemId == insight.items[index].id }
        }.sorted(by: { $0.isCover && !$1.isCover })

        return images ?? [LocationImageMeatadata]()
    }

    func shouldBuildImagesGallery(forIssueIndex index: Int) -> Bool {
        return index > 0
    }
}

class LocationInsightSingleIssueCardProvider {
    let SingeIssueProviders: [SingleIssueProvider]
    let locationInsightPresentedItemsProvider: LocationInsightPresentedItemsProvider

    init(singeIssueProviders: [SingleIssueProvider], locationInsightPresentedItemsProvider: LocationInsightPresentedItemsProvider) {
        SingeIssueProviders = singeIssueProviders
        self.locationInsightPresentedItemsProvider = locationInsightPresentedItemsProvider
    }

    func provide(forInsight locationInsight: LocationInsight, locationSelected: Location?, forItemIndex itemIndex: Int?, withColor color: UIColor) -> SingleIssueViewModel? {
        guard let provider = SingeIssueProviders.first(where: { $0.canProvide(forInsight: locationInsight) }) else {
            log.error("Unsupported insight type. insight uid \(locationInsight.uid) of type \(locationInsight.type)")
            return nil
        }
        return provider.provide(forInsight: locationInsight, locationSelected: locationSelected, forItemIndex: itemIndex, withColor: color)
    }

    func provide(imageGalleryByLocations locations: [Location]?, forIssueIndex index: Int, forInsight insight: LocationInsight) -> [LocationImageMeatadata] {
        guard let provider = SingeIssueProviders.first(where: { $0.canProvide(forInsight: insight) }) else {
            return [LocationImageMeatadata]()
        }
        guard let itemIndex = locationInsightPresentedItemsProvider.getIndexFromPresentedIndex(presentedIndex: index - 1, forInsight: insight) else {
            return [LocationImageMeatadata]()
        }
        return provider.provide(imageGalleryByLocations: locations, forIssueIndex: itemIndex, forInsight: insight)
    }

    func shouldBuildImagesGallery(forIssueIndex index: Int, forInsight insight: LocationInsight) -> Bool {
        guard let provider = SingeIssueProviders.first(where: { $0.canProvide(forInsight: insight) }) else {
            return false
        }
        return provider.shouldBuildImagesGallery(forIssueIndex: index)
    }

    func provide(forInsight locationInsight: LocationInsight, selectedIndex: Int, images: [LocationImageMeatadata], cardIndex: Int, tagColor: UIColor, issueIndex: Int?) -> [AppImageGalleyElement]? {
        guard let provider = SingeIssueProviders.first(where: { $0.canProvide(forInsight: locationInsight) }) else {
            log.error("Unsupported insight type. insight uid \(locationInsight.uid) of type \(locationInsight.type)")
            return nil
        }
        return provider.provide(forInsight: locationInsight, selectedIndex: selectedIndex, images: images, cardIndex: cardIndex, tagColor: tagColor, issueIndex: issueIndex)
    }
}

class SingleLocationInsightSingleIssueCardProvider: SingleIssueProvider {
    func canProvide(forInsight locationInsight: LocationInsight) -> Bool {
        locationInsight is SingleLocationInsight
    }

    func provide(forInsight _: LocationInsight, selectedIndex: Int, images: [LocationImageMeatadata], cardIndex _: Int, tagColor: UIColor, issueIndex _: Int?) -> [AppImageGalleyElement]? {
        return images.enumerated().map { index, element in
            AppImageGalleyElement(images: element.previews, isNightImage: element.isNightImage, tags: element.tags, dotColor: UIColor.clear, subtitle: "", showSubtitleContainer: false)
        }
    }

    func provide(forInsight locationInsight: LocationInsight, locationSelected _: Location?, forItemIndex _: Int?, withColor color: UIColor) -> SingleIssueViewModel? {
        return SingleLocationIssueViewModel(title: locationInsight.subject, info: "", color: color)
    }

    func provide(imageGalleryByLocations locations: [Location]?, forIssueIndex _: Int, forInsight _: LocationInsight) -> [LocationImageMeatadata] {
        let images = locations?
            .filter { !$0.images.isEmpty }
            .flatMap { $0.images }
            .sorted { $0.isCover && !$1.isCover }
            .sorted { $0.id < $1.id }
        return images ?? [LocationImageMeatadata]()
    }

    func shouldBuildImagesGallery(forIssueIndex index: Int) -> Bool {
        return index == 0
    }
}

class EnhancedLocationInsightSingleIssueCardProvider: SingleIssueProvider {
    func provide(forInsight locationInsight: LocationInsight, selectedIndex: Int, images: [LocationImageMeatadata], cardIndex _: Int, tagColor: UIColor, issueIndex: Int?) -> [AppImageGalleyElement]? {
        return images.enumerated().compactMap { index, element in
            guard let issueIndex = issueIndex,
                  let itemEnhanceData = locationInsight.items[issueIndex].enhanceData,
                  let selectedLevel = itemEnhanceData.ranges.levels.first(where: { $0.id == element.levelId }) else { return nil }
            return AppImageGalleyElement(images: element.previews, isNightImage: element.isNightImage, tags: element.tags, dotColor: selectedLevel.color, subtitle: selectedLevel.name, showSubtitleContainer: true)
        }
    }

    func canProvide(forInsight locationInsight: LocationInsight) -> Bool {
        return locationInsight is EnhancedLocationInsight
    }

    func provide(forInsight locationInsight: LocationInsight, locationSelected _: Location?, forItemIndex itemIndex: Int?, withColor _: UIColor) -> SingleIssueViewModel? {
        guard let enhanceInsight = locationInsight as? EnhancedLocationInsight,
              let itemIndex = itemIndex,
              let itemEnhanceData = enhanceInsight.items[itemIndex].enhanceData else { return nil }
        let info = itemEnhanceData.title.isEmpty ? itemEnhanceData.title : "| \(itemEnhanceData.title)"
        return SingleLocationEnhancedViewModel(title: "\(R.string.localizable.insightImageGallery())",
                                               info: info,
                                               color: .clear)
    }

    func provide(imageGalleryByLocations locations: [Location]?, forIssueIndex index: Int, forInsight insight: LocationInsight) -> [LocationImageMeatadata] {
        guard let enhanceInsight = insight as? EnhancedLocationInsight,
              let itemEnhanceData = enhanceInsight.items[index].enhanceData,
              let locations = locations else { return [] }

        let locationsIds = itemEnhanceData.ranges.levels.flatMap { $0.locationIds }

        let locationsFiltered = locations
            .filter { locationsIds.contains($0.id) }
            .filter { !$0.images.isEmpty }
            .flatMap { $0.images }
            .filter { $0.itemId == enhanceInsight.items[index].id }
            .sorted { $0.isCover && !$1.isCover }
            .sorted { $0.id < $1.id }
        return locationsFiltered
    }
}

class IssueLocationInsightSingleIssueCardProvider: SingleIssueProvider {
    func canProvide(forInsight locationInsight: LocationInsight) -> Bool {
        return locationInsight is IssueLocationInsight
    }

    func provide(forInsight _: LocationInsight, selectedIndex: Int, images: [LocationImageMeatadata], cardIndex _: Int, tagColor: UIColor, issueIndex _: Int?) -> [AppImageGalleyElement]? {
        return images.enumerated().map { index, element in
            AppImageGalleyElement(images: element.previews, isNightImage: element.isNightImage, tags: element.tags, dotColor: tagColor, subtitle: "", showSubtitleContainer: false)
        }
    }

    func provide(forInsight locationInsight: LocationInsight, locationSelected _: Location?, forItemIndex itemIndex: Int?, withColor color: UIColor) -> SingleIssueViewModel? {
        guard let itemIndex = itemIndex else { return nil }
        let rangesLocationInsight = locationInsight as! IssueLocationInsight
        let locationIssue = rangesLocationInsight.items[itemIndex]
        return SingleLocationIssueViewModel(title: locationIssue.name,
                                            info: locationIssue.displayedValue ?? "",
                                            color: color)
    }
}

class EmptyLocationInsightSingleIssueCardProvider: SingleIssueProvider {
    func canProvide(forInsight locationInsight: LocationInsight) -> Bool {
        locationInsight is EmptyLocationInsight
    }

    func provide(forInsight _: LocationInsight, selectedIndex: Int, images: [LocationImageMeatadata], cardIndex _: Int, tagColor: UIColor, issueIndex _: Int?) -> [AppImageGalleyElement]? {
        return images.enumerated().map { index, element in
            AppImageGalleyElement(images: element.previews, isNightImage: element.isNightImage, tags: element.tags, dotColor: tagColor, subtitle: "", showSubtitleContainer: false)
        }
    }

    func provide(forInsight _: LocationInsight, locationSelected _: Location?, forItemIndex _: Int?, withColor color: UIColor) -> SingleIssueViewModel? {
        return SingleLocationIssueViewModel(title: R.string.localizable.insightEmptyLocationSingleIssueLabel(), info: "", color: color)
    }

    func provide(imageGalleryByLocations locations: [Location]?, forIssueIndex _: Int, forInsight _: LocationInsight) -> [LocationImageMeatadata] {
        let images = locations?
            .flatMap { $0.images }
            .sorted(by: { $0.isCover && !$1.isCover })
        return images ?? [LocationImageMeatadata]()
    }

    func shouldBuildImagesGallery(forIssueIndex index: Int) -> Bool {
        return index == 0
    }
}

class RangedLocationInsightSingleIssueCardProvider: SingleIssueProvider {
    let rangedLocationPresentedItemProvider: RangedLocationPresentedItemProvider

    init(rangedLocationPresentedItemProvider: RangedLocationPresentedItemProvider) {
        self.rangedLocationPresentedItemProvider = rangedLocationPresentedItemProvider
    }

    func canProvide(forInsight locationInsight: LocationInsight) -> Bool {
        return locationInsight is RangedLocationInsight
    }

    func provide(forInsight _: LocationInsight, selectedIndex: Int, images: [LocationImageMeatadata], cardIndex _: Int, tagColor: UIColor, issueIndex _: Int?) -> [AppImageGalleyElement]? {
        return images.enumerated().map { index, element in
            AppImageGalleyElement(images: element.previews, isNightImage: element.isNightImage, tags: element.tags, dotColor: tagColor, subtitle: "", showSubtitleContainer: false)
        }
    }

    func provide(forInsight locationInsight: LocationInsight, locationSelected _: Location?, forItemIndex itemIndex: Int?, withColor color: UIColor) -> SingleIssueViewModel? {
        guard let itemIndex = itemIndex, let index = rangedLocationPresentedItemProvider.getIndexFromPresentedIndex(presentedIndex: itemIndex, forInsight: locationInsight) else {
            return nil
        }
        let locationIssue = locationInsight.items[index]
        return SingleLocationIssueViewModel(title: locationIssue.name, info: "\(locationIssue.taggedImagesPercent)%", color: color)
    }
}
