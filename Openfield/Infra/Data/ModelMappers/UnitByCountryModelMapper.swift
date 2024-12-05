//
//  UnitByCountryModelMapper.swift
//  Openfield
//
//  Created by amir avisar on 30/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

struct UnitByCountryModelMapper {
    let translationService: TranslationService

    init(translationService: TranslationService) {
        self.translationService = translationService
    }

    func map(unitByCountryServerModel: UnitsByCountryServerModel) throws -> UnitsByCountry {
        let areaUnit = unitByCountryServerModel.area_units.mapValues { areaUnitServerModel -> AreaUnits in
            let unit = translationService.localizedString(localizedString: areaUnitServerModel.i18n_unit, defaultValue: areaUnitServerModel.unit)
            return AreaUnits(unit: unit, acreRelativeMultiplyFactor: areaUnitServerModel.acre_relative_multiply_factor)
        }
        return UnitsByCountry(areaUnits: areaUnit)
    }
}
