//
//  InsightsFromFieldAndCategoryUsecase.swift
//  Openfield
//
//  Created by amir avisar on 18/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//


import Foundation
import CodableFirebase
import Firebase
import RxSwift

class InsightsFromFieldAndCategoryUsecase : InsightsFromFieldAndCategoryUsecaseProtocol {
    
    private let insightsRepo: InsightsRepositoryProtocol
    private let insightsUsecase: InsightsUsecaseProtocol
    
    init(insightsRepo: InsightsRepositoryProtocol, insightsUsecase: InsightsUsecaseProtocol) {
        self.insightsUsecase = insightsUsecase
        self.insightsRepo = insightsRepo
    }
    
    func insights(byFieldId : Int, byCategory: String, onlyHighlights: Bool = false, cycleId: Int? = nil, publicationYear: Int? = nil) -> Observable<[Insight]> {
        let insightsStream = insightsRepo.insightsStream(byFieldId: byFieldId, byCategory: byCategory, onlyHighlights: onlyHighlights, cycleId: cycleId, publicationYear: publicationYear)
        return insightsUsecase.generateInsights(insightsStream: insightsStream)
    }
}

