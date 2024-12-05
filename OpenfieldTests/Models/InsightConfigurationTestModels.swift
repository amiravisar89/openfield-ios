//
//  InsightConfigurationTestModels.swift
//  OpenfieldTests
//
//  Created by amir avisar on 16/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Firebase
import Foundation

@testable import Openfield

enum InsightConfigurationTestModels {
    static let insightConfigSMECrop = ["crop_damage": InsightConfigurationServerModel(app_types: ["detection": AppTypeConfigServerModel(app_type: "enhancedLocationInsight", chips_config: nil, share_strategies: ["shape_file"], insight_explanation: [])], thumbnailUrl: "https://vi-apps.prospera.ag/assets/crop_damage_feed_icon.png", insightExplanation: [InsightExplenationTextServerModel(title: "Locations with Findings", i18n_title: LocalizeString(token: "locations_with_findings", params: [:]), subTitle: "The percentage of map locations in which issues were detected. Calculated out of the scanned area.", i18n_subTitle: LocalizeString(token: "config_insightExplanation_percentageOfMapLocations", params: [:]))], insightDisplayName: DisplayNameServerModel(title: "Crop", i18n_title: nil), category_image_strategy: "map")]

    static let insightConfigSMEWeeds = ["e_weeds": InsightConfigurationServerModel(app_types: ["detection": AppTypeConfigServerModel(app_type: "enhancedLocationInsight", chips_config: nil, share_strategies: ["share"], insight_explanation: [])], thumbnailUrl: "https://vi-apps.prospera.ag/assets/crop_damage_feed_icon.png", insightExplanation: [InsightExplenationTextServerModel(title: "Locations with Findings", i18n_title: LocalizeString(token: "locations_with_findings", params: [:]), subTitle: "The percentage of map locations in which issues were detected. Calculated out of the scanned area.", i18n_subTitle: LocalizeString(token: "config_insightExplanation_percentageOfMapLocations", params: [:]))], insightDisplayName: DisplayNameServerModel(title: "Weeds", i18n_title: nil), category_image_strategy: "map")]

    static let insightConfigIrrigation = ["irrigation": InsightConfigurationServerModel(app_types: ["detection": AppTypeConfigServerModel(app_type: "irrigationInsight", chips_config: nil, share_strategies: ["shape_file", "share"], insight_explanation: [])], thumbnailUrl: nil, insightExplanation: nil, insightDisplayName: DisplayNameServerModel(title: "Irrigation", i18n_title: nil), category_image_strategy: "none")]
    
    static let insightConfigSMECropFirstDetection = ["crop_damage": InsightConfigurationServerModel(app_types: ["first_detection": AppTypeConfigServerModel(app_type: "enhancedLocationInsight", chips_config: nil, share_strategies: ["shape_file"], insight_explanation: [InsightExplenationTextServerModel(title: "first detection", i18n_title: nil, subTitle: "The percentage of map locations in which issues were detected. Calculated out of the scanned area.", i18n_subTitle: nil)])], thumbnailUrl: "https://vi-apps.prospera.ag/assets/crop_damage_feed_icon.png", insightExplanation: [InsightExplenationTextServerModel(title: "Locations with Findings", i18n_title: LocalizeString(token: "locations_with_findings", params: [:]), subTitle: "The percentage of map locations in which issues were detected. Calculated out of the scanned area.", i18n_subTitle: LocalizeString(token: "config_insightExplanation_percentageOfMapLocations", params: [:]))], insightDisplayName: DisplayNameServerModel(title: "Crop", i18n_title: nil), category_image_strategy: "map")]
}

