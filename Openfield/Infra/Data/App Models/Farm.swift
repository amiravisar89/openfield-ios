//
//  Farm.swift
//  Openfield
//
//  Created by amir avisar on 01/10/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

struct Farm {
    let id: Int
    let name: String
    let fieldIds: [Int]
    let type: FarmType
}

enum FarmType {
    case defaultFarm
    case allFarms
}
