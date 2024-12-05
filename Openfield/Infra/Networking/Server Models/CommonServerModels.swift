//
//  CommonServerModels.swift
//  Openfield
//
//  Created by Daniel Kochavi on 27/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation

struct ImageBoundsServerModel: Decodable, Hashable {
    var boundsLeft: Double
    var boundsBottom: Double
    var boundsRight: Double
    var boundsTop: Double

    enum CodingKeys: String, CodingKey {
        case boundsLeft = "left"
        case boundsBottom = "bottom"
        case boundsRight = "right"
        case boundsTop = "top"
    }
}

struct PreviewImageServerModel: Decodable {
    let url: String
    let layer: String // shoulkd be identical to the type of the image
    let height: Int
    let width: Int
}

struct PreviewImageMetadataServerModel: Decodable {
    let url: String
    let height: Int
    let width: Int
}

struct ImageSpatialServerModel: Decodable {
    let height: Int
    let width: Int
    let url: String
    let bounds: ImageBoundsServerModel
}
