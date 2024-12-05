//
//  UnitByCountryTestModels.swift
//  OpenfieldTests
//
//  Created by amir avisar on 16/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Firebase
import Foundation

@testable import Openfield

enum UnitByCountryTestModels {
    static let unitByCountryUS = UnitsByCountryServerModel(area_units: ["US": AreaUnitsServerModel(unit: "Acres",
                                                                                                   i18n_unit: LocalizeString(token: "acres", params: nil), acre_relative_multiply_factor: 1)])
    static let unitByCountryBR = UnitsByCountryServerModel(area_units: ["BR": AreaUnitsServerModel(unit: "Hectares",
                                                                                                   i18n_unit: LocalizeString(token: "hectares", params: nil), acre_relative_multiply_factor: 0.404686)])
}
