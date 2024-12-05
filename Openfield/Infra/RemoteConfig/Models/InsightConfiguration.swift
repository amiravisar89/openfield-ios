//
//  InsightConfiguration.swift
//  Openfield
//
//  Created by amir avisar on 18/04/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit

struct InsightConfiguration {
    let appTypes: [String: AppTypeConfig]
    let thumbnailUrl: String?
    let insightExplanation: [InsightExplenationText]?
    let insightDisplayName: DisplayName?
    let categoryImageStrategy : CategoryImageStrategy
}

struct AppTypeConfig {
    let appType: InsightType
    let chipsConfig: InsightChipConfig?
    let shareStrategies : [ShareStrategy]
}

struct InsightChipConfig {
    let mainColor: UIColor
    let secondaryColor: UIColor
    let chips: [InsightChip]
}

struct InsightChip {
    let text: String
}

struct InsightExplenationText {
    let title: String
    let subTitle: String
}

struct DisplayName {
    let title: String
}
