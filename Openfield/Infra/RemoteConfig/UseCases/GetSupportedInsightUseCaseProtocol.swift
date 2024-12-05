//
//  GetSupportedInsightUseCaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

protocol GetSupportedInsightUseCaseProtocol {
    func supportedInsights() -> [String: InsightConfiguration]
}
