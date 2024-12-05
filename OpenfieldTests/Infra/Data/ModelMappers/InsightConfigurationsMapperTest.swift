//
//  InsightConfigurationsMapperTest.swift
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

class InsightConfigurationsMapperTest: QuickSpec {
    override class func spec() {
        let translationService = TranslationService(translateProvider: MockTranslationPrivder())
        let chipMapper = ChipConfigModelMapper(translationService: translationService)

        let insightConfigurationMapper = InsightConfigurationModellMapper(translationService: translationService, chipConfigModelMapper: chipMapper)

        describe("Insight Configuration Mapper") {
            it("test_map_insightConfiguration_when_ECropDamage_then_appType_enhancedLocationInsight") {
                let insightConfigSM = InsightConfigurationTestModels.insightConfigSMECrop
                let insightConfig = try? insightConfigurationMapper.map(configurationServerModel: insightConfigSM)

                expect(insightConfig?["crop_damage"]?.appTypes["detection"]?.appType).to(equal(InsightType.enhancedLocationInsight))
            }
        }
        
        describe("Insight Configuration Mapper test share strategy shapefile") {
            it("test_map_insightConfiguration_when_ECropDamage_then_share_strategy_is_shapefile") {
                let insightConfigSM = InsightConfigurationTestModels.insightConfigSMECrop
                let insightConfig = try? insightConfigurationMapper.map(configurationServerModel: insightConfigSM)

                expect(insightConfig?["crop_damage"]?.appTypes["detection"]?.shareStrategies).to(equal([ShareStrategy.shapeFile]))
            }
        }
        
        describe("Insight Configuration Mapper test share strategy share") {
            it("test_map_insightConfiguration_when_Eweeds_then_share_strategy_is_share") {
                let insightConfigSM = InsightConfigurationTestModels.insightConfigSMEWeeds
                let insightConfig = try? insightConfigurationMapper.map(configurationServerModel: insightConfigSM)

                expect(insightConfig?["e_weeds"]?.appTypes["detection"]?.shareStrategies).to(equal([ShareStrategy.share]))
            }
        }
        
        describe("Insight Configuration Mapper test share strategy share and shapefile") {
            it("test_map_insightConfiguration_when_Eweeds_then_share_strategy_is_share") {
                let insightConfigSM = InsightConfigurationTestModels.insightConfigIrrigation
                let insightConfig = try? insightConfigurationMapper.map(configurationServerModel: insightConfigSM)

                expect(insightConfig?["irrigation"]?.appTypes["detection"]?.shareStrategies).to(equal([ShareStrategy.shapeFile,ShareStrategy.share]))
            }
        }
        
        describe("Insight Configuration Mapper test explanation text first detection") {
            it("test_map_insightConfiguration_when_first_detection_then_explanation_is_first_detection") {
                let insightConfigSM = InsightConfigurationTestModels.insightConfigSMECropFirstDetection
                let insightConfig = try? insightConfigurationMapper.map(configurationServerModel: insightConfigSM)

                expect(insightConfig?["crop_damage"]?.insightExplanation?.first?.title).to(equal("first detection"))
            }
        }
    }

}
