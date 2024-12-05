//
//  InsightsForFieldUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 31/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol InsightsForFieldUsecaseProtocol {
    
    
    func insights(forFieldId fieldId: Int) -> Observable<[Insight]>
    func insightsWithFieldFilter(forFieldId fieldId: Int, criteria: [FilterCriterion], order: Int) -> Observable<[Insight]> 
}
