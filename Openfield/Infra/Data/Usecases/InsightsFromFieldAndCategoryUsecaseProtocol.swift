//
//  InsightsFromFieldAndCategoryUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 18/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol InsightsFromFieldAndCategoryUsecaseProtocol {
    func insights(byFieldId : Int, byCategory: String, onlyHighlights: Bool, cycleId: Int?, publicationYear: Int?) -> Observable<[Insight]>
}

extension InsightsFromFieldAndCategoryUsecaseProtocol {
    func insights(byFieldId : Int, byCategory: String) -> Observable<[Insight]> {
        return insights(byFieldId: byFieldId, byCategory: byCategory, onlyHighlights: false)
    }

    func insights(byFieldId : Int, byCategory: String, onlyHighlights: Bool) -> Observable<[Insight]> {
        return insights(byFieldId: byFieldId, byCategory: byCategory, onlyHighlights: onlyHighlights, cycleId: nil, publicationYear: nil)
    }
}

