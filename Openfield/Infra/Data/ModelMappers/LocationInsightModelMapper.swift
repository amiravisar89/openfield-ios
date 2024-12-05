//
//  LocationInsightModelMapper.swift
//  Openfield
//
//  Created by Itay Kaplan on 07/02/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Firebase
import Foundation
import SwiftDate
import UIKit

struct LocationInsightModelMapper {
    func map(insightServerModel: InsightServerModel, insightConfiguration: InsightConfiguration, userInsight: UserInsight?, translationService: TranslationService, unitsByCountry: UnitsByCountry) throws -> LocationInsight {
        guard let metadata = insightServerModel.metadata else {
            log.error("Missing metadata for insight uid \(insightServerModel.uid)")
            throw ParsingError(description: "Error while triny to parse location insight. missing metadata")
        }

        guard let startDate = metadata.start_date, let endDate = metadata.end_date, let scannedAreaPercent = metadata.scanned_area_percent, let taggedImagesPercent = metadata.tagged_images_percent, let coverImage = metadata.cover_image, let items = metadata.items else {
            // All params on metadata must be optional because of server constraints
            log.error("Missing metadata items for insight uid \(insightServerModel.uid)")
            throw ParsingError(description: "Error while trying to parse location insight. missing metadata items")
        }

        let imageDetails = coverImage.map {
            SpatialImage(height: $0.height, width: $0.width, url: $0.url, bounds: ImageBounds(boundsLeft: $0.bounds.boundsLeft, boundsBottom: $0.bounds.boundsBottom, boundsRight: $0.bounds.boundsRight, boundsTop: $0.bounds.boundsTop))
        }

        guard let publishDate = insightServerModel.ts_published else {
            log.error("Missing metadata items for insight uid \(insightServerModel.uid)")
            throw ParsingError(description: "Publishdate is nil")
        }
        
        guard let displayName = insightConfiguration.insightDisplayName?.title else {
            log.error("Missing insightDisplayName items for insight uid \(insightServerModel.uid)")
            throw ParsingError(description: "insightDisplayName is nil")
        }
        
        let locationInsightItems = items.map { serverModelItem -> LocationInsightItem in

            let name = translationService.localizedString(localizedString: serverModelItem.i18n_name, defaultValue: serverModelItem.name)

            let description = serverModelItem.description != nil ? translationService.localizedString(localizedString: serverModelItem.i18n_description, defaultValue: serverModelItem.description!) : serverModelItem.description

            let displayValue = serverModelItem.displayed_value != nil ? translationService.localizedString(localizedString: serverModelItem.i18n_displayed_value, defaultValue: serverModelItem.displayed_value!) : serverModelItem.displayed_value

            let enhanceData = EnhanceDataMapper.map(enhanceDataServer: serverModelItem.enhanced_data, translationService: translationService)

            return LocationInsightItem(id: serverModelItem.id, name: name, description: description, taggedImagesPercent: serverModelItem.tagged_images_percent, displayedValue: displayValue, minRange: serverModelItem.min_range, maxRange: serverModelItem.max_range, enhanceData: enhanceData)
        }

        var affectedAreaUnit = defualtAreaUnit

      if let areaUnit = unitsByCountry.areaUnits[insightServerModel.field_country ?? defualtArea] {
            affectedAreaUnit = areaUnit.unit
        }

        var region = Region.local

        if let timeZoneString = insightServerModel.time_zone,
           let timeZone = Zones(rawValue: timeZoneString)
        {
            region = Region(calendar: AppTime.calendar, zone: timeZone, locale: Locales.english)
        }

      let fieldName = (insightServerModel.uid == WelcomeInsightsIds.locationInsight.rawValue) ? translationService.localizedString(localizedString: insightServerModel.i18n_field_name, defaultValue: insightServerModel.field_name) : insightServerModel.field_name

        let description = translationService.localizedString(localizedString: insightServerModel.i18n_description, defaultValue: insightServerModel.description)

        let subject = translationService.localizedString(localizedString: insightServerModel.i18n_subject, defaultValue: insightServerModel.subject)
        
        var summeryResult : String? = nil
        if let i18nSummery = metadata.i18n_report_summary, let defaultSummery = metadata.report_summary { 
            summeryResult = translationService.localizedString(localizedString: i18nSummery, defaultValue: defaultSummery)
        }
        
        var theHighlight: String? = nil
        if let highlight = insightServerModel.highlight, let highlightContent = highlight.content {
            theHighlight = translationService.localizedString(localizedString: highlight.i18n_content, defaultValue: highlightContent)
        }
        
        return LocationInsight(
            id: insightServerModel.id,
            uid: insightServerModel.uid,
            type: insightServerModel.type,
            subject: subject,
            fieldId: insightServerModel.field_id,
            fieldName: fieldName,
            farmName: insightServerModel.farm_name ?? "",
            farmId: insightServerModel.farm_id,
            description: description,
            publishDate: publishDate.dateValue(),
            affectedArea: insightServerModel.tags_area,
            affectedAreaUnit: affectedAreaUnit,
            isRead: userInsight?.tsRead != nil,
            tsFirstRead: userInsight?.tsFirstRead?.dateValue(),
            timeZone: insightServerModel.time_zone,
            thumbnail: insightConfiguration.thumbnailUrl,
            startDate: Date(seconds: TimeInterval(startDate)),
            endDate: Date(seconds: TimeInterval(endDate)),
            scannedAreaPercent: scannedAreaPercent,
            taggedImagesPercent: taggedImagesPercent,
            relativeToLastReport: metadata.relative_to_last_report,
            coverImage: imageDetails,
            items: locationInsightItems,
            aggregationUnit: metadata.aggregation_unit,
            region: region,
            category: insightServerModel.category, 
            subCategory: insightServerModel.subcategory, 
            displayName: displayName, 
            summery: summeryResult,
            highlight: theHighlight,
            cycleId: insightServerModel.cycle_id,
            publicationYear: insightServerModel.publication_year
        )
    }
}
