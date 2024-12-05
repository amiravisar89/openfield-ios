//
//  InsightsFromDateUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 19/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol InsightsFromDateUsecaseProtocol {
  func getInsights(insightsFromDate: Date, limit: Int?, onlyHighlights: Bool) -> Observable<[Insight]>
  func getInsightsByFarms(insightsFromDate: Date, limit: Int?, onlyHighlights: Bool, fieldsIds: [Int]) -> Observable<[Insight]>
}

extension InsightsFromDateUsecaseProtocol {
  func getInsights(insightsFromDate: Date, limit: Int?) -> Observable<[Insight]> {
    return getInsights(insightsFromDate: insightsFromDate, limit: limit, onlyHighlights: false)
  }

  func getInsightsByFarms(insightsFromDate: Date = Date(timeIntervalSince1970: 0), limit: Int? = nil, onlyHighlights _: Bool = false, fieldsIds: [Int]) -> Observable<[Insight]> {
    return getInsightsByFarms(insightsFromDate: insightsFromDate, limit: limit, onlyHighlights: false, fieldsIds: fieldsIds)
  }
}
