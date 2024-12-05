//
//  VirtualScoutingGridServerModel.swift
//  Openfield
//
//  Created by Yoni Luz on 18/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

struct VirtualScoutingGridServerModel: Decodable {
    
    let id: Int
    let field_id: Int
    let cycle_id: Int
    let geojson: String
    let cover_images: [ScoutingGridImageServerModel]
    
}

struct ScoutingGridImageServerModel: Decodable {
    let height: Int
    let width: Int
    let url: String
    let bounds: ImageBoundsServerModel
    let image_type: String
}
