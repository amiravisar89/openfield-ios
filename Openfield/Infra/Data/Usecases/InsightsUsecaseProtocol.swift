//
//  InsightsUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

// Define a protocol for the InsightsUsecase
protocol InsightsUsecaseProtocol {
    func generateInsights(insightsStream: Observable<[InsightServerModel]>) -> Observable<[Insight]>
    func generateInsight(insightStream: Observable<InsightServerModel?>) -> Observable<Insight?>
}
