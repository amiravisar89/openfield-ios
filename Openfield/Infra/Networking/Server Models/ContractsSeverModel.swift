//
//  ContractsSeverModel.swift
//  Openfield
//
//  Created by amir avisar on 14/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation

struct ContractsSeverModel: Decodable {
    let version: Double
    let date: Int
    let contracts: [ContractServerModel]
}

struct ContractServerModel: Decodable {
    let type: String
    let link: String
}
