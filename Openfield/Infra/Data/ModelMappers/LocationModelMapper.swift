//
//  LocationModelMapper.swift
//  Openfield
//
//  Created by Itay Kaplan on 14/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import AVKit
import Foundation

struct LocationModelMapper {
    
    private let nightImagesFeatureFlag: FeatureFlagProtocol
    private let featureFlagRepository: FeatureFlagsRepositoryProtocol
    
    init(featureFlagRepository: FeatureFlagsRepositoryProtocol, nightImagesFeatureFlag: FeatureFlagProtocol ) {
        self.featureFlagRepository = featureFlagRepository
        self.nightImagesFeatureFlag = nightImagesFeatureFlag
    }
    
    func map(locationDetailServerModel: LocationDetailServerModel) throws -> Location {
        let locationImages = locationDetailServerModel.images.filter { $0.is_selected }
            .map { locationImageMetaDataServerModel -> LocationImageMeatadata in

                let previews = locationImageMetaDataServerModel.previews.map { previewImageMetadataServerModel -> AppImage in
                    AppImage(
                        height: previewImageMetadataServerModel.height,
                        width: previewImageMetadataServerModel.width,
                        url: previewImageMetadataServerModel.url
                    )
                }

                let tags = locationImageMetaDataServerModel.tags.map { locationTagServerModel -> LocationTag in
                    let tagPoints = locationTagServerModel.points.map { $0 != nil ? CGPoint(x: $0![0], y: $0![1]) : nil }
                    return LocationTag(type: locationTagServerModel.type, points: tagPoints)
                }
                
                var nightImage = false
                if featureFlagRepository.isFeatureFlagEnabled(featureFlag: nightImagesFeatureFlag) {
                    nightImage = locationImageMetaDataServerModel.is_night_image ?? false
                   
                }

                return LocationImageMeatadata(
                    id: locationImageMetaDataServerModel.id,
                    date: locationImageMetaDataServerModel.date,
                    itemId: locationImageMetaDataServerModel.item_id,
                    isCover: locationImageMetaDataServerModel.is_cover,
                    previews: previews,
                    tags: tags,
                    lat: locationImageMetaDataServerModel.lat,
                    long: locationImageMetaDataServerModel.long,
                    levelId: locationImageMetaDataServerModel.level_id, 
                    isNightImage: nightImage
                )
            }

        return Location(
            id: locationDetailServerModel.id,
            issuesIds: locationDetailServerModel.item_ids,
            latitude: locationDetailServerModel.latitude,
            longitude: locationDetailServerModel.longitude,
            images: locationImages
        )
    }
}
