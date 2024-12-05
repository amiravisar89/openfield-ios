//
//  IrrigationInsightModelMapper.swift
//  Openfield
//
//  Created by Daniel Kochavi on 27/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Firebase
import Foundation
import GEOSwift
import SwiftDate

struct IrrigationInsightModelMapper {

    func map(insightServerModel: InsightServerModel, userInsight: UserInsight?, translationService: TranslationService, unitsByCountry: UnitsByCountry, insightConfiguration: InsightConfiguration) throws -> IrrigationInsight {
        let hardcodedThumbnail = insightServerModel.images.first?.preview.first?.url ?? ""
        let thumbnail = insightServerModel.images.filter { $0.is_main_image == true }.first?.preview.first?.url ?? hardcodedThumbnail

        let mainImage = insightServerModel.images.first { image in image.is_main_image }
        let mainInsightImage = map(insightImageServerModel: mainImage)

        guard let publishDate = insightServerModel.ts_published?.dateValue() else {
            log.error("missing metadata items for insight uid \(insightServerModel.uid)")
            throw ParsingError(description: "Publishdate is nil")
        }

        // TODO-Daniel: Cleanup this parsing code
        let decoder = JSONDecoder()
        let data = insightServerModel.tags[0].geojson.data(using: .utf8)!
        let geoJSON = try? decoder.decode(GeoJSON.self, from: data)
        let imageDate: Date = mainInsightImage?.date ?? publishDate

        var region = Region.local

        if let timeZoneString = insightServerModel.time_zone,
           let timeZone = Zones(rawValue: timeZoneString)
        {
            region = Region(calendar: AppTime.calendar, zone: timeZone, locale: Locales.english)
        }

      let fieldName = (insightServerModel.uid == WelcomeInsightsIds.irrigation.rawValue) ? translationService.localizedString(localizedString: insightServerModel.i18n_field_name, defaultValue: insightServerModel.field_name) : insightServerModel.field_name

        let farmName = insightServerModel.farm_name ?? ""

        let description = translationService.localizedString(localizedString: insightServerModel.i18n_description, defaultValue: insightServerModel.description)

        let subject = translationService.localizedString(localizedString: insightServerModel.i18n_subject, defaultValue: insightServerModel.subject)

        var affectedArea = insightServerModel.tags_area

        var affectedAreaUnit = defualtAreaUnit

        if let areaUnit = unitsByCountry.areaUnits[insightServerModel.field_country ?? defualtArea] {
            affectedArea = areaUnit.acreRelativeMultiplyFactor * insightServerModel.tags_area
            affectedAreaUnit = areaUnit.unit
        }
        
        guard let displayName = insightConfiguration.insightDisplayName?.title else {
            log.error("missing insightDisplayName items for insight uid \(insightServerModel.uid)")
            throw ParsingError(description: "insightDisplayName is nil")
        }
        
        var theHighlight: String? = nil
        if let highlight = insightServerModel.highlight, let highlightContent = highlight.content {
            theHighlight = translationService.localizedString(localizedString: highlight.i18n_content, defaultValue: highlightContent)
        }

        return IrrigationInsight(
            id: insightServerModel.id,
            uid: insightServerModel.uid,
            type: insightServerModel.type,
            subject: subject,
            fieldId: insightServerModel.field_id,
            fieldName: fieldName,
            farmName: farmName,
            farmId: insightServerModel.farm_id,
            description: description,
            publishDate: publishDate,
            affectedArea: affectedArea,
            affectedAreaUnit: affectedAreaUnit,
            isRead: userInsight?.tsRead != nil,
            tsFirstRead: userInsight?.tsFirstRead?.dateValue(),
            timeZone: insightServerModel.time_zone,
            imageDate: imageDate,
            thumbnail: thumbnail,
            images: nil,
            mainImage: mainInsightImage,
            review: nil,
            feedback: Feedback(insightId: insightServerModel.id,
                               rating: userInsight?.feedback?.rating,
                               reason: userInsight?.feedback?.reason,
                               otherReasonText: userInsight?.feedback?.otherReasonText),

            isSelected: false,
            tag: InsightTag(id: insightServerModel.tags[0].id, tag: geoJSON!),
            dateRegion: region, 
            category: insightServerModel.category,
            subCategory: insightServerModel.subcategory,
            displayName: displayName,
            highlight: theHighlight,
            cycleId: insightServerModel.cycle_id,
            publicationYear: insightServerModel.publication_year
        )
    }

    func map(insightImageServerModel: InsightImageServerModel?) -> InsightImage? {
        guard let insightImageServerModel = insightImageServerModel else { return nil }
        guard let imageType = AppImageType(rawValue: insightImageServerModel.type) else {
            log.error("Missing type: \(insightImageServerModel.type) when parsing \(InsightImageServerModel.self)")
            return nil
        }

        let previews = insightImageServerModel.preview.map { preview in map(previewImageServerModel: preview, imageId: insightImageServerModel.image_id, issue: insightImageServerModel.issue)
        }

        return InsightImage(date: insightImageServerModel.date.dateValue(),
                            id: insightImageServerModel.image_id,
                            bounds: ImageBounds(boundsLeft: insightImageServerModel.bounds.boundsLeft,
                                                boundsBottom: insightImageServerModel.bounds.boundsBottom,
                                                boundsRight: insightImageServerModel.bounds.boundsRight,
                                                boundsTop: insightImageServerModel.bounds.boundsTop),
                            type: imageType, issue: Issue(comment: insightImageServerModel.issue?.comment, isHidden: insightImageServerModel.issue?.is_hidden, issue: IssueType(rawValue: insightImageServerModel.issue?.issue ?? "empty")),
                            previews: previews,
                            sourceType: ImageSourceType(rawValue: insightImageServerModel.source_type ?? "") ?? .plane)
    }

    func map(previewImageServerModel: PreviewImageServerModel, imageId: Int, issue: LayerIssueServerModel?) -> PreviewImage {
        return PreviewImage(url: previewImageServerModel.url, height: previewImageServerModel.height, width: previewImageServerModel.width, imageId: imageId, issue: Issue(comment: issue?.comment, isHidden: issue?.is_hidden, issue: IssueType(rawValue: issue?.issue ?? "empty")))
    }
}
