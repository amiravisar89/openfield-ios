//
//  InsightConfigurationModellMapper.swift
//  Openfield
//
//  Created by amir avisar on 29/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import UIKit

enum InsightConfigurationModellMapperError: Error {
    case unsupportedInsightType(description: String)
    case unsupportedImageStrategy(description: String)
    case unsupportedShareStrategy(description: String)

}

struct InsightConfigurationModellMapper {
    let translationService: TranslationService
    let chipConfigModelMapper: ChipConfigModelMapper
    
    init(translationService: TranslationService, chipConfigModelMapper: ChipConfigModelMapper) {
        self.translationService = translationService
        self.chipConfigModelMapper = chipConfigModelMapper
    }
    
    func map(configurationServerModel: [String: InsightConfigurationServerModel]) throws -> [String: InsightConfiguration] {
        return try configurationServerModel.mapValues { configSM -> InsightConfiguration in
            
            var explenationText = configSM.insightExplanation?.map { expTextServerModel -> InsightExplenationText in
                let title = translationService.localizedString(localizedString: expTextServerModel.i18n_title, defaultValue: expTextServerModel.title)
                let subtitle = translationService.localizedString(localizedString: expTextServerModel.i18n_subTitle, defaultValue: expTextServerModel.subTitle)
                return InsightExplenationText(title: title, subTitle: subtitle)
            }
            
            guard let imageStrategy = CategoryImageStrategy(rawValue: configSM.category_image_strategy) else {
                throw InsightConfigurationModellMapperError.unsupportedImageStrategy(description: "Unsupported Category Strategy: \(configSM.category_image_strategy)")
            }
            
            let appTypes = try configSM.app_types.mapValues { appType in
                guard let insightType = InsightType(rawValue: appType.app_type) else {
                    throw InsightConfigurationModellMapperError.unsupportedInsightType(description: "Unsupported Insight Type: \(appType)")
                }
                let chipsConfig = chipConfigModelMapper.map(serverModel: appType.chips_config)
                
                let shareStrategies = try appType.share_strategies.map { strategySM in
                    guard let shareStrategy = ShareStrategy(rawValue: strategySM) else {
                        throw InsightConfigurationModellMapperError.unsupportedShareStrategy(description: "Unsupported Share Strategy: \(strategySM)")
                    }
                    return shareStrategy
                }
                explenationText = appType.insight_explanation != nil ? appType.insight_explanation?.map { expTextServerModel -> InsightExplenationText in
                    let title = translationService.localizedString(localizedString: expTextServerModel.i18n_title, defaultValue: expTextServerModel.title)
                    let subtitle = translationService.localizedString(localizedString: expTextServerModel.i18n_subTitle, defaultValue: expTextServerModel.subTitle)
                    return InsightExplenationText(title: title, subTitle: subtitle)
                } : explenationText
                
                return AppTypeConfig(appType: insightType, chipsConfig: chipsConfig, shareStrategies: shareStrategies)
            }
            
            let insightDisplayName = configSM.insightDisplayName.map {
                DisplayName(title: translationService.localizedString(localizedString: $0.i18n_title, defaultValue: $0.title))
            }
            
            return InsightConfiguration(appTypes: appTypes, thumbnailUrl: configSM.thumbnailUrl, insightExplanation: explenationText, insightDisplayName: insightDisplayName, categoryImageStrategy: imageStrategy)
        }
    }
}
