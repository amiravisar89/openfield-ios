//
//  VirtualScoutingFeatureFlag.swift
//  Openfield
//
//  Created by Yoni Luz on 01/07/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
struct VirtualScoutingFeatureFlag : FeatureFlagProtocol {
    let key: String = "virtual-scouting"
    var defaultValue: Bool = false
}
