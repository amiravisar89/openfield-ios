//
//  UnitsByCountryServerModel.swift
//  Openfield
//
//  Created by amir avisar on 30/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

let defualtArea = "US"
let defualtAreaUnit = "Acres"

struct UnitsByCountryServerModel: Decodable {
    let area_units: [String: AreaUnitsServerModel]
}

struct AreaUnitsServerModel: Decodable {
    let unit: String
    let i18n_unit: LocalizeString
    let acre_relative_multiply_factor: Double
}

struct UnitsByCountry {
    let areaUnits: [String: AreaUnits]
}

struct AreaUnits {
    let unit: String
    let acreRelativeMultiplyFactor: Double
}
