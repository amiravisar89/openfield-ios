//
//  GetCategoriesUsecase.swift
//  Openfield
//
//  Created by amir avisar on 12/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase
import RxSwift

class GetCategoriesUsecase: GetCategoriesUsecaseProtocol {
    
    private let locationsFromInsightUsecase : LocationsFromInsightUsecaseProtocol
    private let insightsPerCategoryUsecase: InsightsPerCategoryUsecaseProtocol
    
    init(locationsFromInsightUsecase: LocationsFromInsightUsecaseProtocol, insightsPerCategoryUsecase: InsightsPerCategoryUsecaseProtocol) {
        self.locationsFromInsightUsecase = locationsFromInsightUsecase
        self.insightsPerCategoryUsecase = insightsPerCategoryUsecase
    }
    
    func categories(fieldId: Int) -> Observable<[InsightCategory]> {
        return insightsPerCategoryUsecase.insights(byFieldId: fieldId).flatMap { insights -> Observable<[InsightCategory]> in
            guard let locationInsights = insights.filter({$0 is LocationInsight}) as? [LocationInsight] else {return Observable.just([])}
            return self.getInsightsCategories(insights: locationInsights)
        }
    }
    
    func categoriesBySeason(field: Field, selectedSeasonOrder: Int) -> Observable<[InsightCategory]> {
        guard let latestFilter = field.filters.first(where: { $0.order == selectedSeasonOrder } ) else {
            return Observable.just([])
        }
        return insightsPerCategoryUsecase.insightsWithFieldFilter(fieldId: field.id, criteria: latestFilter.criteria, order: latestFilter.order).flatMap { insights -> Observable<[InsightCategory]> in
            guard let locationInsights = insights.filter({$0 is LocationInsight}) as? [LocationInsight] else {return Observable.just([])}
            return self.getInsightsCategories(insights: locationInsights)
        }
    }
    
    private func getInsightsCategories(insights : [LocationInsight]) -> Observable<[InsightCategory]> {
        let queries = insights.map { insight in
            return locationsFromInsightUsecase.locations(forInsightUID: insight.uid).map { locations in
                return InsightCategory(date: insight.endDate, categoryId: insight.category, insight: insight, locations: locations)
            }
        }
        return Observable.combineLatest(queries)
    }
    
}
