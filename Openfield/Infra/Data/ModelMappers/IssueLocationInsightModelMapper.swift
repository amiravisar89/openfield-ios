//
//  IssueLocationInsightModelMapper.swift
//  Openfield
//
//  Created by Itay Kaplan on 27/12/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

struct IssueLocationInsightModelMapper {
    let locationInsightModelMapper: LocationInsightModelMapper

    init(locationInsightModelMapper: LocationInsightModelMapper) {
        self.locationInsightModelMapper = locationInsightModelMapper
    }

    func map(insightServerModel: InsightServerModel, insightConfiguration: InsightConfiguration, userInsight: UserInsight?, translationService: TranslationService, unitsByCountry: UnitsByCountry) throws -> IssueLocationInsight {
        let locationInsight = try locationInsightModelMapper.map(insightServerModel: insightServerModel, insightConfiguration: insightConfiguration, userInsight: userInsight, translationService: translationService, unitsByCountry: unitsByCountry)

        // Enforce the dispaly values on issue location items //
        for item in locationInsight.items {
            guard item.displayedValue != nil else {
                throw ParsingError(description: "All items for isssue location insight must have displayed_value. For insigh uid - \(insightServerModel.uid)")
            }
        }

        return IssueLocationInsight(
            id: locationInsight.id,
            uid: locationInsight.uid,
            type: locationInsight.type,
            subject: locationInsight.subject,
            fieldId: locationInsight.fieldId,
            fieldName: locationInsight.fieldName,
            farmName: locationInsight.farmName,
            farmId: locationInsight.farmId,
            description: locationInsight.description,
            publishDate: locationInsight.publishDate,
            affectedArea: locationInsight.affectedArea,
            affectedAreaUnit: locationInsight.affectedAreaUnit,
            isRead: locationInsight.isRead,
            tsFirstRead: locationInsight.tsFirstRead,
            timeZone: locationInsight.timeZone,
            thumbnail: insightConfiguration.thumbnailUrl,
            startDate: locationInsight.startDate,
            endDate: locationInsight.endDate,
            scannedAreaPercent: locationInsight.scannedAreaPercent,
            taggedImagesPercent: locationInsight.taggedImagesPercent,
            relativeToLastReport: locationInsight.relativeToLastReport,
            coverImage: locationInsight.coverImage,
            items: locationInsight.items,
            aggregationUnit: locationInsight.aggregationUnit,
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
