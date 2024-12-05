//
//  UnitByCountryMapperTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 15/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Fakery
import Firebase
import Foundation
import Nimble
import Quick
import Resolver
import SwiftDate

@testable import Openfield

class UnitByCountryMapperTest: QuickSpec {
    override class func spec() {
        let translationService: TranslationService = Resolver.resolve()
        let unitByContryMapper = UnitByCountryModelMapper(translationService: translationService)

        describe("Unit By Country Mapper") {
            it("test_map_UnitByCountry_when_unit_is_US_then_unit_acres") {
                let unitByCountrySMUS = UnitByCountryTestModels.unitByCountryUS
                let unitByCountryUS = try? unitByContryMapper.map(unitByCountryServerModel: unitByCountrySMUS)

                expect(unitByCountryUS?.areaUnits["US"]?.unit).to(equal("Acres"))
            }

            it("test_map_UnitByCountry_when_unit_is_BR_then_unit_hectares") {
                let unitByCountrySMBR = UnitByCountryTestModels.unitByCountryBR
                let unitByCountryBR = try? unitByContryMapper.map(unitByCountryServerModel: unitByCountrySMBR)

                expect(unitByCountryBR?.areaUnits["BR"]?.unit).to(equal("Hectares"))
            }
        }
    }


}
