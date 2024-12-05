//
//  FieldModelMapper.swift
//  Openfield
//
//  Created by Daniel Kochavi on 27/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Dollar
import Foundation
import SwiftDate

struct FieldModelMapper {
    let translationService: TranslationService
    
    init(translationService: TranslationService){
        self.translationService = translationService
    }
    
    func map(fieldServerModel: FieldServerModel, imagesServerModel: [FieldImageServerModel]) -> Field {
        var region = Region.local

        if let timeZoneString = fieldServerModel.time_zone,
           let timeZone = Zones(rawValue: timeZoneString)
        {
            region = Region(calendar: AppTime.calendar, zone: timeZone, locale: Locales.english)
        }

        let imageGroups = Dollar.uniq(map(fieldImageServerModels: imagesServerModel, field: fieldServerModel, region: region)) { (imageGroup: FieldImageGroup) in
            imageGroup.date
        }

        var coverImage: SpatialImage? = nil
        if let coverServerFieldImage = fieldServerModel.cover_image {
            coverImage = SpatialImage(
                height: coverServerFieldImage.height,
                width: coverServerFieldImage.width,
                url: coverServerFieldImage.url,
                bounds: ImageBounds(boundsLeft: coverServerFieldImage.bounds.boundsLeft, boundsBottom: coverServerFieldImage.bounds.boundsBottom, boundsRight: coverServerFieldImage.bounds.boundsRight, boundsTop: coverServerFieldImage.bounds.boundsTop)
            )
        }
        
        let filters = getFilters(fieldServerModel: fieldServerModel).sorted {$0.order < $1.order}
        return Field(id: fieldServerModel.id,
                     country: fieldServerModel.country,
                     name: fieldServerModel.name,
                     farmName: fieldServerModel.farm_name,
                     dateUpdated: Date(), // TODO-Daniel: Change this
                     imageGroups: imageGroups,
                     coverImage: coverImage,
                     region: region,
                     farmId: fieldServerModel.farm_id,
                     filters: filters,
                     subscriptionTypes: fieldServerModel.subscription_types)
                    
    }

    private func map(fieldImageServerModels: [FieldImageServerModel], field: FieldServerModel, region: Region) -> [FieldImageGroup] {
        return fieldImageServerModels.compactMap { fieldImage -> FieldImageGroup? in

            var imagesByLayer: [AppImageType: [PreviewImage]] = [:]
            for (imageTypeString, layerImageServerModel) in fieldImage.layers {
                if let imageType = AppImageType(rawValue: imageTypeString) {
                    let fieldImages: [PreviewImage] = map(previews: layerImageServerModel.previews, imageId: fieldImage.id, issue: layerImageServerModel.issue)
                    imagesByLayer.updateValue(fieldImages, forKey: imageType)
                }
            }

            let image = getImageryImage(fieldId: field.id, date: fieldImage.date.dateValue(), layers: imagesByLayer)

            let bounds = ImageBounds(boundsLeft: fieldImage.bounds.boundsLeft,
                                     boundsBottom: fieldImage.bounds.boundsBottom,
                                     boundsRight: fieldImage.bounds.boundsRight,
                                     boundsTop: fieldImage.bounds.boundsTop)

            var region: Region = .local

            if let timeZoneString = field.time_zone,
               let timeZone: Zones = Zones(rawValue: timeZoneString)
            {
                region = Region(calendar: AppTime.calendar, zone: timeZone, locale: Locales.english)
            }

            if imagesByLayer.isEmpty {
                return nil
            }

            return FieldImageGroup(fieldId: field.id,
                                   fieldName: field.name,
                                   imageryMainImage: image.0,
                                   imageryMainType: image.1,
                                   date: fieldImage.date.dateValue(),
                                   bounds: bounds,
                                   imagesByLayer: imagesByLayer,
                                   region: region,
                                   sourceType: ImageSourceType(rawValue: fieldImage.source_type ?? "") ?? .plane)
        }
    }

    private func getImageryImage(fieldId: Int, date: Date, layers: [AppImageType: [PreviewImage]]) -> (String, AppImageType) {
        let imageTypePriority: [AppImageType] = [.rgb, .ndvi, .thermal]
        for type in imageTypePriority {
            guard let previews = layers[type] else { continue }
            guard previews.count > 0 else { continue }
            return (previews[0].url, type)
        }
        log.debug("No images found in any layer on \(date) in field: \(fieldId)")
        return ("", .rgb)
    }

    private func map(previews: [PreviewImageServerModel], imageId: Int, issue: LayerIssueServerModel?) -> [PreviewImage] {
        return previews.map { PreviewImage(url: $0.url, height: $0.height, width: $0.width,
                                           imageId: imageId,
                                           issue: Issue(comment: issue?.comment, isHidden: issue?.is_hidden, issue: IssueType(rawValue: issue?.issue ?? "empty")))
        }
    }
    
    private func getFilters(fieldServerModel: FieldServerModel) -> [FieldFilter] {
        return fieldServerModel.filters.map { filterItem in
            FieldFilter(
                order: filterItem.order,
                name: translationService.localizedString(localizedString: filterItem.i18n_name, defaultValue: filterItem.name),
                criteria: filterItem.criteria.map { criterionItem in
                    FilterCriterion(
                        collection: criterionItem.collection,
                        filterBy: criterionItem.filter_by.map { valueItem in
                            FilterBy(property: valueItem.property, value: valueItem.value)
                        }
                    )
                }
            )
        }
    }

}
