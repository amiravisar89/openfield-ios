//
//  FieldImageServerModel.swift
//  Openfield
//
//  Created by amir avisar on 11/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Firebase
import Foundation

struct FieldImageServerModel: Decodable {
    let bounds: ImageBoundsServerModel
    let date: Timestamp
    let id: Int
    let layers: [String: LayerImageServerModel]
    let source_type: String?
    let field_id: Int
}
