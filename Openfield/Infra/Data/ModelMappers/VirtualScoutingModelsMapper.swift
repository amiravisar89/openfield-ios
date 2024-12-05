//
//  VirtualScoutingModelsMapper.swift
//  Openfield
//
//  Created by Yoni Luz on 18/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import GEOSwift

class VirtualScoutingModelsMapper {
    
    let dateProvider: DateProvider

    init(dateProvider: DateProvider) {
        self.dateProvider = dateProvider
    }
    
    func map(virtualScoutingDateServerModel: VirtualScoutingDateServerModel) -> VirtualScoutingDate {
        return VirtualScoutingDate(gridId: virtualScoutingDateServerModel.grid_id,
                                   fieldId: virtualScoutingDateServerModel.field_id,
                                   cycleId: virtualScoutingDateServerModel.cycle_id,
                                   day: virtualScoutingDateServerModel.day)
    }
    
    func map(virtualScoutingGridServerModel: VirtualScoutingGridServerModel) -> VirtualScoutingGrid {
        
        let coverImages = virtualScoutingGridServerModel.cover_images.map {
            ScoutingGridImage(height: $0.height, width: $0.width, url: $0.url, bounds: ImageBounds(boundsLeft: $0.bounds.boundsLeft, boundsBottom: $0.bounds.boundsBottom, boundsRight: $0.bounds.boundsRight, boundsTop: $0.bounds.boundsTop), imageType: AppImageType(rawValue: $0.image_type) ?? .rgb)
        }
        let geojson = try? JSONDecoder().decode(GeoJSON.self, from: virtualScoutingGridServerModel.geojson.data(using: .utf8)!)
        return VirtualScoutingGrid(gridID: virtualScoutingGridServerModel.id, fieldID: virtualScoutingGridServerModel.field_id, cycleID: virtualScoutingGridServerModel.cycle_id, geojson: geojson, coverImages: coverImages)
    }
}
