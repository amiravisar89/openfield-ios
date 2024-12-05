//
//  Contracts.swift
//  Openfield
//
//  Created by amir avisar on 14/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation

struct Contracts {
    let version: Double
    let date: Date
    let contracts: [Contract]
}

struct Contract {
    let title: String
    let type: ContractType
    let url: String
}

enum ContractType: String {
    case terms
    case privacy
    case changes
    case support
}
