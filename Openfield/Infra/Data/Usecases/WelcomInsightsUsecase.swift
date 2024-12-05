//
//  WelcomInsightsUsecase.swift
//  Openfield
//
//  Created by Yoni Luz on 28/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class WelcomInsightsUsecase: WelcomInsightsUsecaseProtocol {
    
    private let insightsRepo: InsightsRepositoryProtocol
    private let insightsUsecase: InsightsUsecaseProtocol
    
    init(insightsRepo: InsightsRepositoryProtocol, insightsUsecase: InsightsUsecaseProtocol) {
        self.insightsUsecase = insightsUsecase
        self.insightsRepo = insightsRepo
    }
    
    func insights() -> Observable<[Insight]> {
        let insightsStream = insightsRepo.welcomeInsightStream()
        return insightsUsecase.generateInsights(insightsStream: insightsStream)
    }
}
