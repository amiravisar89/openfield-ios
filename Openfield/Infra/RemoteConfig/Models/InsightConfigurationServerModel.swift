//
//  InsightConfigurationServerModel.swift
//  Openfield
//
//  Created by Itay Kaplan on 27/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import UIKit

struct InsightConfigurationServerModel: Decodable {
    let app_types: [String : AppTypeConfigServerModel]
    let thumbnailUrl: String?
    let insightExplanation: [InsightExplenationTextServerModel]?
    let insightDisplayName: DisplayNameServerModel?
    let category_image_strategy: String
}

struct AppTypeConfigServerModel: Decodable {
    let app_type: String
    let chips_config: InsightChipsConfigServerModel?
    let share_strategies: [String]
    let insight_explanation: [InsightExplenationTextServerModel]?
}

struct InsightChipsConfigServerModel: Decodable {
    let main_color: String
    let secondary_color: String
    let chips: [InsightChipServerModel]
}

struct InsightChipServerModel: Decodable {
    let title: String
    let i18n_title: LocalizeString
}

struct InsightExplenationTextServerModel: Decodable {
    let title: String
    let i18n_title: LocalizeString?
    let subTitle: String
    let i18n_subTitle: LocalizeString?
}

struct DisplayNameServerModel: Decodable {
    let title: String
    let i18n_title: LocalizeString?
}

