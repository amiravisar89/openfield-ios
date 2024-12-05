//
//  InsightsPerCategoryUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 13/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol InsightsPerCategoryUsecaseProtocol {
    func insights(byFieldId fieldId: Int) -> Observable<[Insight]>
    func insightsWithFieldFilter(fieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]> 
}
