//
//  VirtualScoutingGrid.swift
//  Openfield
//
//  Created by Yoni Luz on 17/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import GEOSwift

struct VirtualScoutingGrid : Hashable {
    let gridID: Int
    let fieldID: Int
    let cycleID: Int
    let geojson: GeoJSON?
    let coverImages: [ScoutingGridImage]
}


class ScoutingGridImage: SpatialImage {
    
    let imageType: AppImageType

    init(height: Int, width: Int, url: String, bounds: ImageBounds, imageType: AppImageType) {
        self.imageType = imageType
        super.init(height: height, width: width, url: url, bounds: bounds)
    }
}
