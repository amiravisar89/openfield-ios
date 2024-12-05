//
//  EmptyLocationInsightModelMapper.swift
//  Openfield
//
//  Created by Itay Kaplan on 15/03/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

struct EmptyLocationInsightModelMapper {
    let locationInsightModelMapper: LocationInsightModelMapper

    init(locationInsightModelMapper: LocationInsightModelMapper) {
        self.locationInsightModelMapper = locationInsightModelMapper
    }

    func map(insightServerModel: InsightServerModel, insightConfiguration: InsightConfiguration, userInsight: UserInsight?, translationService: TranslationService, unitsByCountry: UnitsByCountry) throws -> EmptyLocationInsight {
        let locationInsight = try locationInsightModelMapper.map(insightServerModel: insightServerModel, insightConfiguration: insightConfiguration, userInsight: userInsight, translationService: translationService, unitsByCountry: unitsByCountry)

        guard locationInsight.items.count == 1 else {
            throw ParsingError(description: "EmptyLocationInsight should have only 1 item, for insight_uid - \(insightServerModel.uid)")
        }

        let description = translationService.localizedString(localizedString: insightServerModel.i18n_description, defaultValue: insightServerModel.description)

        let subject = translationService.localizedString(localizedString: insightServerModel.i18n_subject, defaultValue: insightServerModel.subject)

        return EmptyLocationInsight(
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
            thumbnail: locationInsight.thumbnail,
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
