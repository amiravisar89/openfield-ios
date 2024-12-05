//
//  FeatureFlagProtocol.swift
//  Openfield
//
//  Created by Amitai Efrati on 05/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
protocol FeatureFlagProtocol {
    var key: String { get }
    var defaultValue: Bool { get }
}
