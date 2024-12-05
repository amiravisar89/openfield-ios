//
//  LocationInsightCardsProvider.swift
//  Openfield
//
//  Created by Itay Kaplan on 03/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import Resolver
import SwiftDate
import UIKit

protocol IsLocationInsightProvider {
    func canProvide(for insight: LocationInsight) -> Bool
}

protocol CardsProvider: IsLocationInsightProvider {
    var locationColorsProvider: LocationColorProvider { get }
    func provide(firstCard forInsight: LocationInsight, locations: [Location]?, isFieldOwner: Bool) -> LocationInsightCard?
    func provide(itemsCards forInsight: LocationInsight, locations: [Location]?, locationInsightPresentedItemsProvider: LocationInsightPresentedItemsProvider) -> [LocationInsightCard]
}

class LocationInsightCardProvider {
    let locationInsightCardsProviders: [CardsProvider]
    let locationInsightPresentedItemsProvider: LocationInsightPresentedItemsProvider

    init(locationInsightCardsProviders: [CardsProvider], locationInsightPresentedItemsProvider: LocationInsightPresentedItemsProvider) {
        self.locationInsightCardsProviders = locationInsightCardsProviders
        self.locationInsightPresentedItemsProvider = locationInsightPresentedItemsProvider
    }

    func provide(locationInsight: LocationInsight, locations: [Location]?, isFieldOwner: Bool) -> [LocationInsightCard] {
        guard let provider = locationInsightCardsProviders.first(where: { $0.canProvide(for: locationInsight) }) else {
            return []
        }

        var cards = provider.provide(itemsCards: locationInsight, locations: locations, locationInsightPresentedItemsProvider: locationInsightPresentedItemsProvider)
        if let overviewCard = provider.provide(firstCard: locationInsight, locations: locations, isFieldOwner: isFieldOwner) {
            cards.insert(overviewCard, at: .zero)
        }
        return cards
    }
}

class SingleLocationCardsProvider: CardsProvider {
    let locationColorsProvider: LocationColorProvider
    let chipsProvider: ChipsProvider

    init(locationColorsProvider: SingleLocationInsightColorProvider, chipsProvider: ChipsProvider) {
        self.locationColorsProvider = locationColorsProvider
        self.chipsProvider = chipsProvider
    }

    func canProvide(for insight: LocationInsight) -> Bool {
        return insight is SingleLocationInsight
    }

    func provide(firstCard forInsight: LocationInsight, locations: [Location]?, isFieldOwner _: Bool = true) -> LocationInsightCard? {
        var items: [SingleLocationOverviewItem] = []
        guard let insight = forInsight as? SingleLocationInsight,
              let locations = locations,
              let chipConfig = chipsProvider.provideChips(for: forInsight)
        else {
            return nil
        }

        let firstDetectionData = insight.firstDetectionData

        let locationsFiltered = locations
            .filter { !$0.images.isEmpty }
            .flatMap { $0.images }
            .sorted { $0.isCover && !$1.isCover }
            .sorted { $0.id < $1.id }.prefix(3)

        items.append(SingleLocationDateItem(imageDate: firstDetectionData.imageDate, fullReportDate: firstDetectionData.fullReportDate, region: insight.dateRegion))

        if locationsFiltered.count == 1, let singleImage = locationsFiltered.first {
            let tagData = TagsData(image: singleImage.previews, tags: singleImage.tags, color: R.color.enhancedLocationColor()!)
            items.append(SingleLocationTagImageItem(data: tagData))
        } else {
            let locationsImages = locationsFiltered.enumerated().map { index, image in
                EnhanceImagesData(image: image.previews, tags: image.tags, showMore: index == locationsFiltered.count - 1, color: R.color.enhancedLocationColor()!, isNightImage: image.isNightImage)
            }
            items.append(SingleLocationImagesItem(images: locationsImages))
        }

        return SingleLocationOverviewCard(items: items, chipsConfig: chipConfig, title: forInsight.subject)
    }

    func provide(itemsCards _: LocationInsight, locations _: [Location]?, locationInsightPresentedItemsProvider _: LocationInsightPresentedItemsProvider) -> [LocationInsightCard] {
        return []
    }
}

class EnhancedLocationCardsProvider: CardsProvider {
    let locationColorsProvider: LocationColorProvider

    init(locationColorsProvider: EnhancedLocationInsightColorProvider) {
        self.locationColorsProvider = locationColorsProvider
    }

    func canProvide(for insight: LocationInsight) -> Bool {
        return insight is EnhancedLocationInsight
    }

    func provide(firstCard forInsight: LocationInsight, locations _: [Location]?, isFieldOwner _: Bool = true) -> LocationInsightCard? {
        guard let insight = forInsight as? EnhancedLocationInsight else {
            return nil
        }
        let enhanceData = insight.enhanceData
        let itemsDescriptions = forInsight.items.compactMap { item -> EnhanceItem? in // check if one of the ranges are more then 1
            guard let enhanceData = item.enhanceData, let aggValue = enhanceData.locationsAggValue else { return nil }
            return EnhanceItem(identity: String(item.id), type: .description(itemDescription: EnhanceItemDescription(title: enhanceData.title, summery: aggValue)))
        }

        var sections: [EnhanceSectionItem] = []

        if !itemsDescriptions.isEmpty {
            sections.insert(EnhanceSectionItem(items: itemsDescriptions, title: R.string.localizable.type(), summery: R.string.localizable.insightLocationWithFindings(), id: EnhanceSections.itemsSection.rawValue), at: .zero)
        }

        var enhanceItems: [EnhanceItem] = []
        if let aggValue = enhanceData.locationsAggValue {
            if enhanceData.isSeverity {
                enhanceItems.append(EnhanceItem(identity: UUID().uuidString, type: .description(itemDescription: EnhanceItemDescription(title: enhanceData.locationsAggName, summery: aggValue))))
            }
        }

        let severityCells = enhanceData.ranges.levels.map { severityCell(order: $0.order, color: $0.color, name: $0.name, value: $0.value, relativeToLastValue: $0.relativeToLastReport) }.sorted(by: { $0.order < $1.order })

        enhanceItems.append(EnhanceItem(identity: UUID().uuidString, type: .severity(severity: EnhanceSeverityTableCellData(title: enhanceData.ranges.title,
                                                                                                                            midtitle: enhanceData.ranges.midtitle,
                                                                                                                            subtitle: enhanceData.ranges.subtitle,
                                                                                                                            severityCells: severityCells))))

        sections.insert(EnhanceSectionItem(items: enhanceItems, title: enhanceData.title, summery: enhanceData.subtitle, id: EnhanceSections.overviewSection.rawValue), at: .zero)
        return EnhanceLocationCard(sections: sections, highlight: insight.highlight)
    }

    func provide(itemsCards forInsight: LocationInsight, locations: [Location]?, locationInsightPresentedItemsProvider: LocationInsightPresentedItemsProvider) -> [LocationInsightCard] {
        guard let insight = forInsight as? EnhancedLocationInsight else {
            return []
        }

        let presentedItems = locationInsightPresentedItemsProvider.provide(forInsight: insight)

        return presentedItems.compactMap { item in

            guard let itemEnhanceData = item.enhanceData else { return nil }

            var enhanceItems: [EnhanceItem] = []
            var sections: [EnhanceSectionItem] = []

            let locationsIds = itemEnhanceData.ranges.levels.flatMap { $0.locationIds }
            guard let locations = locations else { return EnhanceLocationCard(sections: sections) }

            let locationsFiltered = locations
                .filter { locationsIds.contains($0.id) }
                .filter { !$0.images.isEmpty }
                .flatMap { $0.images }
                .filter { $0.itemId == item.id }
                .sorted { $0.isCover && !$1.isCover }
                .sorted { $0.id < $1.id }.prefix(3)

            if itemEnhanceData.ranges.levels.count == 1, let firstLevel = itemEnhanceData.ranges.levels.first {
                return EnhanceLocationImageCard(title: firstLevel.name, info: "\(firstLevel.value)% \(R.string.localizable.insightImageGalleryOfScan())", image: locationsFiltered.first?.previews ?? [], tags: locationsFiltered.first?.tags ?? [], color: itemEnhanceData.ranges.levels.first?.color, showImageLoader: true, isNightImage: locationsFiltered.first?.isNightImage ?? false)
            }

            if let aggValue = itemEnhanceData.locationsAggValue {
                if itemEnhanceData.isSeverity {
                    enhanceItems.insert(EnhanceItem(identity: UUID().uuidString, type: .description(itemDescription: EnhanceItemDescription(title: itemEnhanceData.locationsAggName, summery: aggValue))), at: .zero)
                }
            }

            if itemEnhanceData.ranges.levels.count > 1 {
                let severityCells = itemEnhanceData.ranges.levels.map { severityCell(order: $0.order, color: $0.color, name: $0.name, value: $0.value, relativeToLastValue: $0.relativeToLastReport) }.sorted(by: { $0.order < $1.order })
                enhanceItems.append(EnhanceItem(identity: UUID().uuidString,
                                                type: .severity(severity: EnhanceSeverityTableCellData(title: itemEnhanceData.ranges.title,
                                                                                                       midtitle: itemEnhanceData.ranges.midtitle,
                                                                                                       subtitle: itemEnhanceData.ranges.subtitle,
                                                                                                       severityCells: severityCells))))
            }

            sections.insert(EnhanceSectionItem(items: enhanceItems, title: itemEnhanceData.title, summery: "", id: EnhanceSections.overviewSection.rawValue), at: .zero)

            let locationsImages = locationsFiltered.enumerated().map { index, image in
                EnhanceImagesData(image: image.previews, tags: image.tags, showMore: index == locationsFiltered.count - 1, color: R.color.enhancedLocationColor()!, isNightImage: image.isNightImage)
            }

            let imagesSection = EnhanceSectionItem(items: [EnhanceItem(identity: UUID().uuidString, type: .imagesCollection(images: locationsImages))], title: R.string.localizable.insightFindingSamples(), summery: " ", id: EnhanceSections.imagesSection.rawValue)
            sections.append(imagesSection)

            return EnhanceLocationCard(sections: sections)
        }
    }

    enum EnhanceSections: String {
        case overviewSection
        case imagesSection
        case itemsSection
    }
}

class IssueLocationCardsProvider: CardsProvider {
    let locationColorsProvider: LocationColorProvider

    init(locationColorsProvider: IssueLocationInsightColorProvider) {
        self.locationColorsProvider = locationColorsProvider
    }

    func canProvide(for insight: LocationInsight) -> Bool {
        return insight is IssueLocationInsight
    }

    func provide(firstCard forInsight: LocationInsight, locations _: [Location]?, isFieldOwner _: Bool = true) -> LocationInsightCard? {
        let overviewIssues = forInsight.items.map { (issueName: $0.name, severity: $0.displayedValue ?? "") }
        return IssueLocationOverviewCard(cycleCompletionPrecentage: forInsight.scannedAreaPercent, issues: overviewIssues, title: R.string.localizable.insightReportOverview())
    }

    func provide(itemsCards forInsight: LocationInsight, locations: [Location]?, locationInsightPresentedItemsProvider: LocationInsightPresentedItemsProvider) -> [LocationInsightCard] {
        guard let insight = forInsight as? IssueLocationInsight else {
            return []
        }

        let presentedItems = locationInsightPresentedItemsProvider.provide(forInsight: insight)
        let locationIssues = presentedItems.enumerated().map { index, item -> LocationInsightCard in
            let image: LocationImageMeatadata? = locations?.filter { !$0.images.isEmpty }.flatMap { $0.images }.filter { $0.itemId == item.id }.filter { $0.isCover }.first
            return IssueLocationCard(title: item.name, info: item.displayedValue ?? "", image: image?.previews ?? [], tags: image?.tags ?? [], color: locationColorsProvider.getColor(forItemAtIndex: index, forInsight: insight, locationSelected: nil), showImageLoader: locations == nil, description: item.description, isNightImage: image?.isNightImage ?? false)
        }
        return locationIssues
    }
}

class EmptyLocationCardsProvider: CardsProvider {
    var locationColorsProvider: LocationColorProvider

    init(locationColorsProvider: EmptyLocationInsightColorProvider) {
        self.locationColorsProvider = locationColorsProvider
    }

    func provide(itemsCards _: LocationInsight, locations _: [Location]?, locationInsightPresentedItemsProvider _: LocationInsightPresentedItemsProvider) -> [LocationInsightCard] {
        return []
    }

    func provide(firstCard forInsight: LocationInsight, locations _: [Location]?, isFieldOwner _: Bool) -> LocationInsightCard? {
        let summery = forInsight.items.first?.description ?? R.string.localizable.insightEmptyLocationOverviewCardSummeryLabel()
        return EmptyLocationOverviewCard(cycleCompletionPrecentage: forInsight.scannedAreaPercent, summery: summery, title: R.string.localizable.insightEmptyLocationOverviewCardTitle())
    }

    func canProvide(for insight: LocationInsight) -> Bool {
        return insight is EmptyLocationInsight
    }
}

class RangedLocationCardsProvider: CardsProvider {
    let locationColorsProvider: LocationColorProvider

    init(locationColorsProvider: RangedLocationInsightColorProvider) {
        self.locationColorsProvider = locationColorsProvider
    }

    func canProvide(for insight: LocationInsight) -> Bool {
        return insight is RangedLocationInsight
    }

    func provide(firstCard forInsight: LocationInsight, locations _: [Location]?, isFieldOwner: Bool) -> LocationInsightCard? {
        guard let insight = forInsight as? RangedLocationInsight else {
            return nil
        }

        var categories: [RangedLocationOverviewCardItem] = insight.items.enumerated().map { index, item -> RangedLocationOverviewCardItem in
            let colors = locationColorsProvider.colors(insightItemsCount: forInsight.items.count)
            return RangedLocationOverviewCardCategory(
                color: colors[index % colors.count],
                range: item.name,
                percentage: item.taggedImagesPercent
            )
        }

        if let goalStandCount = insight.goalStandCount, let aggUnit = insight.aggregationUnit, isFieldOwner {
            categories.append(RangedLocationOverviewCardGoal(subtitle: "\(Int(goalStandCount).withCommas()) \(R.string.localizable.insightPlantsPerUnit_IOS(aggUnit))"))
        }

        var avgCountTitle = R.string.localizable.insightAvgStandCount()
        if let aggUnit = insight.aggregationUnit {
            avgCountTitle = "\(avgCountTitle) \(R.string.localizable.insightPlantsPerUnit_IOS(aggUnit))"
        }

        return RangedLocationOverviewCard(
            cycleCompletionPrecentage: insight.scannedAreaPercent,
            avgCountTitle: avgCountTitle,
            avgCount: insight.avgStandCount.withCommas(),
            categories: categories, title: R.string.localizable.insightReportOverview()
        )
    }

    func provide(itemsCards forInsight: LocationInsight, locations: [Location]?, locationInsightPresentedItemsProvider: LocationInsightPresentedItemsProvider) -> [LocationInsightCard] {
        guard let insight = forInsight as? RangedLocationInsight else {
            return []
        }

        let presentedItems = locationInsightPresentedItemsProvider.provide(forInsight: insight)
        let locationIssues = presentedItems.enumerated().map { index, item -> LocationInsightCard in
            let image: LocationImageMeatadata? = locations?.filter { !$0.images.isEmpty }.flatMap { $0.images }.filter { $0.itemId == item.id }.filter { $0.isCover }.first
            return IssueLocationCard(title: item.name,
                                     info: "\(item.taggedImagesPercent)%",
                                     image: image?.previews ?? [],
                                     tags: image?.tags ?? [],
                                     color: locationColorsProvider.getColor(forItemAtIndex: index, forInsight: forInsight, locationSelected: nil),
                                     showImageLoader: locations == nil,
                                     description: item.description, 
                                     isNightImage: image?.isNightImage ?? false)
        }
        return locationIssues
    }
}
