//
//  InsightMapperTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 26/04/2022.
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

class InsightMapperTest: QuickSpec {
    override class func spec() {
        let translationService = TranslationService(translateProvider: MockTranslationPrivder())
        let chipMapper = ChipConfigModelMapper(translationService: translationService)

        let unitByContryMapper = UnitByCountryModelMapper(translationService: translationService)
        let insightConfigurationMapper = InsightConfigurationModellMapper(translationService: translationService, chipConfigModelMapper: chipMapper)
        let userInsight = UserInsight(tsFirstRead: Timestamp(), tsRead: Timestamp(), feedback: nil)

        describe("Insight Mapper") {
            it("test_map_irrigationInsight_when_userInsight_is_null_then_isRead_false") {
                let irrigationInsightMapper: IrrigationInsightModelMapper = .init()
                let irrigationInsightSM = InsightTestModels.irrigationInsightServerModel
                let unitByCountrySMUS = UnitByCountryTestModels.unitByCountryUS
                let insightConfigSM = InsightConfigurationTestModels.insightConfigIrrigation

                guard let unitByCountryUS = try? unitByContryMapper.map(unitByCountryServerModel: unitByCountrySMUS),
                      let insightConfig = try? insightConfigurationMapper.map(configurationServerModel: insightConfigSM),
                      let irrigationInsightConfiguration = insightConfig[irrigationInsightSM.type]
                else {
                    fail()
                    return
                }

                let irrigationInsight = try? irrigationInsightMapper.map(insightServerModel: irrigationInsightSM, userInsight: nil, translationService: translationService, unitsByCountry: unitByCountryUS, insightConfiguration: irrigationInsightConfiguration)

                expect(irrigationInsight?.isRead).to(equal(false))
            }

            it("test_map_irrigationInsight_UserInsight_is_not_null_then_isRead_true") {
                let irrigationInsightMapper: IrrigationInsightModelMapper = .init()
                let irrigationInsightSM = InsightTestModels.irrigationInsightServerModel
                let unitByCountrySMUS = UnitByCountryTestModels.unitByCountryUS
                let insightConfigSM = InsightConfigurationTestModels.insightConfigIrrigation

                guard let unitByCountryUS = try? unitByContryMapper.map(unitByCountryServerModel: unitByCountrySMUS),
                      let insightConfig = try? insightConfigurationMapper.map(configurationServerModel: insightConfigSM),
                      let irrigationInsightConfiguration = insightConfig[irrigationInsightSM.type]
                else {
                    fail()
                    return
                }

                let irrigationInsight = try? irrigationInsightMapper.map(insightServerModel: irrigationInsightSM, userInsight: userInsight, translationService: translationService, unitsByCountry: unitByCountryUS, insightConfiguration: irrigationInsightConfiguration)

                expect(irrigationInsight?.isRead).to(equal(true))
            }

            it("test_map_locationWeedsInsight_UserInsight_is_null_then_isRead_false") {
                let enhancedLocationMapper: EnhancedLocationInsightModelMapper = .init(locationInsightModelMapper: LocationInsightModelMapper())

                let weedInsightSM = InsightTestModels.locationInsight
                let unitByCountrySMUS = UnitByCountryTestModels.unitByCountryUS
                let insightConfigSM = InsightConfigurationTestModels.insightConfigSMEWeeds

                guard let unitByCountryUS = try? unitByContryMapper.map(unitByCountryServerModel: unitByCountrySMUS),
                      let insightConfig = try? insightConfigurationMapper.map(configurationServerModel: insightConfigSM),
                      let weedInsightConfiguration = insightConfig[weedInsightSM.type]
                else {
                    fail()
                    return
                }

                let weedInsight = try? enhancedLocationMapper.map(insightServerModel: weedInsightSM, insightConfiguration: weedInsightConfiguration, userInsight: nil, translationService: translationService, unitsByCountry: unitByCountryUS)

                expect(weedInsight?.isRead).to(equal(false))
            }

            it("test_map_locationWeedsInsight_UserInsight_is_null_then_isRead_true") {
                let enhancedLocationMapper: EnhancedLocationInsightModelMapper = .init(locationInsightModelMapper: LocationInsightModelMapper())

                let weedInsightSM = InsightTestModels.locationInsight
                let unitByCountrySMUS = UnitByCountryTestModels.unitByCountryUS
                let insightConfigSM = InsightConfigurationTestModels.insightConfigSMEWeeds

                guard let unitByCountryUS = try? unitByContryMapper.map(unitByCountryServerModel: unitByCountrySMUS),
                      let insightConfig = try? insightConfigurationMapper.map(configurationServerModel: insightConfigSM),
                      let weedInsightConfiguration = insightConfig[weedInsightSM.type]
                else {
                    fail()
                    return
                }

                let weedInsight = try? enhancedLocationMapper.map(insightServerModel: weedInsightSM, insightConfiguration: weedInsightConfiguration, userInsight: userInsight, translationService: translationService, unitsByCountry: unitByCountryUS)

                expect(weedInsight?.isRead).to(equal(true))
            }
        }
    }
}
