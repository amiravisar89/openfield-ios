//
//  NightImagesFeatureFlag.swift
//  Openfield
//
//  Created by amir avisar on 24/07/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
struct NightImagesFeatureFlag : FeatureFlagProtocol {
    let key: String = "night-images"
    var defaultValue: Bool = false
}
