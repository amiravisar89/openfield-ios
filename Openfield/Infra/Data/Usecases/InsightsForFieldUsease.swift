//
//  InsightsForFieldUsease.swift
//  Openfield
//
//  Created by Yoni Luz on 31/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class InsightsForFieldUsease: InsightsForFieldUsecaseProtocol {
    
    private let insightsRepo: InsightsRepositoryProtocol
    private let insightsUsecase: InsightsUsecaseProtocol
    
    init(insightsRepo: InsightsRepositoryProtocol, insightsUsecase: InsightsUsecaseProtocol) {
        self.insightsUsecase = insightsUsecase
        self.insightsRepo = insightsRepo
    }
    
    func insights(forFieldId fieldId: Int) -> Observable<[Insight]> {
        let insightsStream = insightsRepo.insightsStream(forFieldId: fieldId)
        return insightsUsecase.generateInsights(insightsStream: insightsStream)
    }
}
