//
//  FeatureFlagsRepository.swift
//  Openfield
//
//  Created by Amitai Efrati on 04/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import LaunchDarkly

class FeatureFlagsRepository: FeatureFlagsRepositoryProtocol {
    
    private let ldClient: LDClient?
    
    init(ldClient: LDClient?) {
        self.ldClient = ldClient
    }
    
    func isFeatureFlagEnabled(featureFlag: FeatureFlagProtocol) -> Bool {
        guard let ldClient = ldClient else {
            return featureFlag.defaultValue
        }
        return ldClient.boolVariation(forKey: featureFlag.key, defaultValue: featureFlag.defaultValue)
    }
}
