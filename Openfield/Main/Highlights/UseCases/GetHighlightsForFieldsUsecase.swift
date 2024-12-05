//
//  GetHighlightsForFieldsUsecase.swift
//  Openfield
//
//  Created by amir avisar on 28/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import Foundation
import RxSwift
import SwiftDate
import Dollar

class GetHighlightsForFieldsUsecase: GetHighlightsForFieldsUseCaseProtocol {
    
    let getHighlightsUseCase : GetHighlightsUseCaseProtocol
    
    init(getHighlightsUseCase : GetHighlightsUseCaseProtocol) {
        self.getHighlightsUseCase = getHighlightsUseCase
    }
    
    func highlights(limit : Int?, fromDate: Date?) -> Observable<[HighlightItem]> {
        let highlightsStream = getHighlightsUseCase.highlights(limit: limit, fromDate: fromDate)
        let anyHighlightStream = getHighlightsUseCase.highlights(limit: 1, fromDate: nil).map { !$0.isEmpty }
        return Observable.combineLatest(highlightsStream, anyHighlightStream).map { highlights, anyHighlights in
            var result = highlights.map {
                HighlightItem(type: HighlightItemType.getHighlightItemType(for: $0), identity: $0.insight.id, date: $0.insight.publishDate)
            }
            if result.isEmpty && anyHighlights {
                result.append(HighlightItem(type: .empty, identity: .zero, date: Date()))
            }
            return result
        }
    }
}
