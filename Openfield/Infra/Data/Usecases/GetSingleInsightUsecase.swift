//
//  GetSingleInsightUsecase.swift
//  Openfield
//
//  Created by amir avisar on 12/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class GetSingleInsightUsecase: GetSingleInsightUsecaseProtocol {
    
    private let insightsRepo: InsightsRepositoryProtocol
    private let insightsUsecase: InsightsUsecaseProtocol
    
    init(insightsRepo: InsightsRepositoryProtocol, insightsUsecase: InsightsUsecaseProtocol) {
        self.insightsUsecase = insightsUsecase
        self.insightsRepo = insightsRepo
    }
    
    func insight(byUID uid: String) -> Observable<Insight?> {
        let insightsStream = insightsRepo.insight(byUID: uid)
        return insightsUsecase.generateInsight(insightStream: insightsStream)
    }
}
