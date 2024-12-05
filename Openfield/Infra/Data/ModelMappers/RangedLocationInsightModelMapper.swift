//
//  RangedLocationInsightModelMapper.swift
//  Openfield
//
//  Created by Itay Kaplan on 07/02/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

struct RangedLocationInsightModelMapper {
    let locationInsightModelMapper: LocationInsightModelMapper

    init(locationInsightModelMapper: LocationInsightModelMapper) {
        self.locationInsightModelMapper = locationInsightModelMapper
    }

    func map(insightServerModel: InsightServerModel, insightConfiguration: InsightConfiguration, userInsight: UserInsight?, translationService: TranslationService, unitsByCountry: UnitsByCountry) throws -> RangedLocationInsight {
        let locationInsight = try locationInsightModelMapper.map(insightServerModel: insightServerModel, insightConfiguration: insightConfiguration, userInsight: userInsight, translationService: translationService, unitsByCountry: unitsByCountry)

        // We know to present ranged location insight only with 4 items //
        if locationInsight.items.count != 4 && locationInsight.items.count != 3 {
            throw ParsingError(description: "Ranged Location Insights must have exatctly 4 items. Insight uid \(locationInsight.uid)")
        }

        for item in locationInsight.items {
            if item.minRange == nil || item.maxRange == nil {
                throw ParsingError(description: "Ranged Location Insights must have min and max ranges for each item. Insight uid \(locationInsight.uid)")
            }
        }

        guard let metadata = insightServerModel.metadata, let avgStandCount = metadata.avg_stand_count else {
            throw ParsingError(description: "Ranged Location Insights must avg_stand_count. Insight uid \(locationInsight.uid)")
        }

        let description = translationService.localizedString(localizedString: insightServerModel.i18n_description, defaultValue: insightServerModel.description)

        let subject = translationService.localizedString(localizedString: insightServerModel.i18n_subject, defaultValue: insightServerModel.subject)

        locationInsight.items.sort { $0.minRange! > $1.minRange! }

        return RangedLocationInsight(
            id: locationInsight.id,
            uid: locationInsight.uid,
            type: locationInsight.type,
            subject: subject,
            fieldId: locationInsight.fieldId,
            fieldName: locationInsight.fieldName,
            farmName: locationInsight.farmName,
            farmId: locationInsight.farmId,
            description: description,
            publishDate: locationInsight.publishDate,
            affectedArea: locationInsight.affectedArea,
            affectedAreaUnit: locationInsight.affectedAreaUnit,
            isRead: locationInsight.isRead,
            tsFirstRead: locationInsight.tsFirstRead,
            timeZone: locationInsight.timeZone,
            thumbnail: insightConfiguration.thumbnailUrl,
            startDate: locationInsight.startDate,
            endDate: locationInsight.endDate,
            goalStandCount: metadata.goal_stand_count,
            scannedAreaPercent: locationInsight.scannedAreaPercent,
            taggedImagesPercent: locationInsight.taggedImagesPercent,
            relativeToLastReport: locationInsight.relativeToLastReport,
            coverImage: locationInsight.coverImage,
            items: locationInsight.items,
            aggregationUnit: locationInsight.aggregationUnit,
            avgStandCount: avgStandCount,
            region: locationInsight.dateRegion,
            category: insightServerModel.category, 
            subCategory: insightServerModel.subcategory,
            displayName: locationInsight.displayName,
            summery: locationInsight.summery,
            highlight: locationInsight.highlight,
            cycleId: insightServerModel.cycle_id,
            publicationYear: insightServerModel.publication_year
        )
    }
}
