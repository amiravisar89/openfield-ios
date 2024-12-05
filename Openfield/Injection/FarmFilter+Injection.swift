//
//  FarmFilter+Injection.swift
//  Openfield
//
//  Created by amir avisar on 01/10/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import Resolver

extension Resolver {
    static func registerFarmFilter() {
        register {
            let insightsFromDateUseCase: InsightsFromDateUsecase = resolve()
            let allFarmUseCase: GetAllFarmsUseCase = resolve()
            return FarmFilter(insightsFromDateUseCase: insightsFromDateUseCase, allFarmUseCase: allFarmUseCase)
        }.scope(cached)
    }
}
