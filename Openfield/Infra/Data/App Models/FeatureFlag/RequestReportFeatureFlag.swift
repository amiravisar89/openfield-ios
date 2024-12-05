//
//  RequestReportFeatureFlag.swift
//  Openfield
//
//  Created by Amitai Efrati on 05/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
struct RequestReportFeatureFlag: FeatureFlagProtocol {
    let key: String = "request-report-for-field"
    var defaultValue: Bool = false
}
