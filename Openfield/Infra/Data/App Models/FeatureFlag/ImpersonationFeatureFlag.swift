//
//  ImpersonationFeatureFlag.swift
//  Openfield
//
//  Created by Yoni Luz on 28/07/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
struct ImpersonationFeatureFlag : FeatureFlagProtocol {
    let key: String = "support-impersonation"
    var defaultValue: Bool = false
}
