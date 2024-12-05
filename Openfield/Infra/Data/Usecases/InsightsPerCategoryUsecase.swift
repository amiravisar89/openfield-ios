//
//  InsightsPerCategoryUsecase.swift
//  Openfield
//
//  Created by Yoni Luz on 30/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class LatestInsightPerCategoryUsecase: InsightsPerCategoryUsecaseProtocol {
    
    private var insightForFieldUsecase: InsightsForFieldUsecaseProtocol
    
    init(insightForFieldUsecase: InsightsForFieldUsecaseProtocol) {
        self.insightForFieldUsecase = insightForFieldUsecase
    }
    
    func insights(byFieldId fieldId: Int) -> Observable<[Insight]> {
        return insightForFieldUsecase.insights(forFieldId: fieldId).map { insights in
            return self.getInsightsByCategory(insights: insights)
        }
    }
    
    func insightsWithFieldFilter(fieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]> {
        return insightForFieldUsecase.insightsWithFieldFilter(forFieldId: fieldId, criteria: criteria, order: order).map { insights in
            return self.getInsightsByCategory(insights: insights)
        }
    }
    
    private func getInsightsByCategory(insights: [Insight]) -> [Insight] {
        let insightsGroupedByCategory = Dictionary(grouping: insights) { $0.category }
        
        let insightByCategoryMap = insightsGroupedByCategory.mapValues { insights in
            insights.max { a, b in a.publishDate < b.publishDate }
        }
        let insightByCategory = insightByCategoryMap.values.compactMap { $0 }
        return insightByCategory
    }
}
