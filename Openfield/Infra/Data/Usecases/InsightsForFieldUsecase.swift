//
//  InsightsForFieldUsease.swift
//  Openfield
//
//  Created by Yoni Luz on 31/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class InsightsForFieldUsecase: InsightsForFieldUsecaseProtocol {
    
    private let insightsRepo: InsightsRepositoryProtocol
    private let insightsUsecase: InsightsUsecaseProtocol
        
    init(insightsRepo: InsightsRepositoryProtocol, insightsUsecase: InsightsUsecaseProtocol) {
        self.insightsUsecase = insightsUsecase
        self.insightsRepo = insightsRepo
    }
    
    func insights(forFieldId fieldId: Int) -> Observable<[Insight]> {
        let insightsStream = insightsRepo.insightsStream(byFieldId: fieldId)
        return insightsUsecase.generateInsights(insightsStream: insightsStream)
    }
    
    func insightsWithFieldFilter(forFieldId fieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]> {
       let insightsStream = insightsRepo.insightsStreamFilteredByCriteria(fieldId: fieldId, criteria: criteria)
       return insightsUsecase.generateInsights(insightsStream: insightsStream)
    }
}
