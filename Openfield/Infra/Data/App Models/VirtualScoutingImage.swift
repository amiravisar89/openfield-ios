//
//  VirtualScoutingImage.swift
//  Openfield
//
//  Created by Yoni Luz on 17/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Firebase
import Foundation

struct VirtualScoutingImage: Codable, Equatable {
  let id: Int
  let gridID: Int
  let fieldID: Int
  let cycleID: Int
  let gridCellID: Int
  let tsTaken: Timestamp
  let imageURL: String
  let latitude: Double
  let longitude: Double
  let width: Int
  let height: Int
  let angle: Double
  let radius: Double
  let thumbnail: Thumbnail?
  let labels: [String]?

  enum CodingKeys: String, CodingKey {
    case id
    case gridID = "grid_id"
    case fieldID = "field_id"
    case cycleID = "cycle_id"
    case gridCellID = "grid_cell_id"
    case tsTaken = "ts_taken"
    case imageURL = "image_url"
    case latitude
    case longitude
    case width
    case height
    case angle
    case radius
    case thumbnail
    case labels
  }
}

struct Thumbnail: Codable, Equatable {
  let height: Int
  let width: Int
  let url: String

  enum CodingKeys: String, CodingKey {
    case height, width, url
  }
}

enum ImageLable: String {
  case nightImage
}
