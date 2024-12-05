//
//  FeatureFlagsRepositoryProtocol.swift
//  Openfield
//
//  Created by Amitai Efrati on 04/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
protocol FeatureFlagsRepositoryProtocol {
    func isFeatureFlagEnabled(featureFlag: FeatureFlagProtocol) -> Bool
}
