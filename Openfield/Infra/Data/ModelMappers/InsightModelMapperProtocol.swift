//
//  InsightModelMapperProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

// Define a protocol for the InsightModelMapper
protocol InsightModelMapperProtocol {
    func map(insightConfiguration: InsightConfiguration,
             insightServerModel: InsightServerModel,
             userInsight: UserInsight?,
             unitByCountry: UnitsByCountry
    ) throws -> Insight?
}
