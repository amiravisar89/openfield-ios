//
//  SingleLocationInsightModelMapper.swift
//  Openfield
//
//  Created by amir avisar on 01/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation

import UIKit

struct SingleLocationInsightModelMapper {
    let locationInsightModelMapper: LocationInsightModelMapper

    init(locationInsightModelMapper: LocationInsightModelMapper) {
        self.locationInsightModelMapper = locationInsightModelMapper
    }

    func map(insightServerModel: InsightServerModel, insightConfiguration: InsightConfiguration, userInsight: UserInsight?, translationService: TranslationService, unitsByCountry: UnitsByCountry) throws -> SingleLocationInsight {
        let locationInsight = try locationInsightModelMapper.map(insightServerModel: insightServerModel, insightConfiguration: insightConfiguration, userInsight: userInsight, translationService: translationService, unitsByCountry: unitsByCountry)

        guard let firstDetectionData = insightServerModel.metadata?.first_detection_data else {
            log.error("Missing firstDetectionData insight uid \(insightServerModel.uid)")
            throw ParsingError(description: "Error while trying to parse location insight. missing firstDetectionData items")
        }

        let firstDetection = FirstDetectionData(title: locationInsight.subject, imageDate: Date(seconds: TimeInterval(firstDetectionData.image_date)), fullReportDate: Date(seconds: TimeInterval(firstDetectionData.full_report_data)))

        return SingleLocationInsight(
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
            firstDetectionData: firstDetection,
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
