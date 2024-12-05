//
//  File.swift
//  Openfield
//
//  Created by Amitai Efrati on 17/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import Firebase
import Resolver

extension Resolver {
    static func registerFeatureFlag() {
        register { FeatureFlagManager(auth: Auth.auth()) }.scope(application)
        register { FeatureFlagAppDelegateSerivce() }.scope(application)
    }
}
