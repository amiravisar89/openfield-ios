//
//  VirtualScoutingDateServerModel.swift
//  Openfield
//
//  Created by Yoni Luz on 18/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

struct VirtualScoutingDateServerModel: Decodable {
    
    let grid_id: Int
    let field_id: Int
    let cycle_id: Int
    let day: String
}
