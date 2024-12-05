//
//  GetfieldIrrigationUsecase.swift
//  Openfield
//
//  Created by amir avisar on 14/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase
import RxSwift

class GetFieldIrrigationUsecase : GetFieldIrrigationUsecaseProtocol {
    
    private let insightsForFieldUsecase : InsightsForFieldUsecaseProtocol
    private let getFieldIrrigationLimitUseCase : GetFieldIrrigationLimitUseCaseProtocol
    
    init(InsightsForFieldUsecase: InsightsForFieldUsecaseProtocol, getFieldIrrigationLimitUseCase : GetFieldIrrigationLimitUseCaseProtocol) {
        self.insightsForFieldUsecase = InsightsForFieldUsecase
        self.getFieldIrrigationLimitUseCase = getFieldIrrigationLimitUseCase
    }
    
    func irrigations(field: Field, selectedSeasonOrder: Int) -> Observable<[FieldIrrigation]> {
        guard let latestFilter = field.filters.first(where: { $0.order == selectedSeasonOrder } ) else {
            return Observable.just([])
        }
        let limit = getFieldIrrigationLimitUseCase.fieldIrrigationLimit() + 1
        return insightsForFieldUsecase.insightsWithFieldFilter(forFieldId: field.id, criteria: latestFilter.criteria, order: latestFilter.order).map { insights in
            guard let irrigationInsights = insights.filter({$0 is IrrigationInsight}) as? [IrrigationInsight],
                  let firstInsight = irrigationInsights.first,
                  !irrigationInsights.isEmpty else {return []}
            let sortedInsights = irrigationInsights.sorted(by: {$0.publishDate > $1.publishDate})
            let date = sortedInsights.first?.publishDate ?? Date()
            return [FieldIrrigation(categoryId: firstInsight.category, insights: Array(sortedInsights.prefix(limit)), date: date)]
        }
    }
}
