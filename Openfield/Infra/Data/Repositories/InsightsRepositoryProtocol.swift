//
//  InsightsRepositoryProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 15/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol InsightsRepositoryProtocol {
  func insightsStream(whereDateGreaterThanOrEqualTo fromDate: Date, limit: Int?, onlyHighlights: Bool) -> Observable<[InsightServerModel]>
  func insightsStream(byFieldId: Int?, byCategory: String?, onlyHighlights: Bool, cycleId: Int?, publicationYear: Int?) -> Observable<[InsightServerModel]>
  func insightsStreamByFarms(whereDateGreaterThanOrEqualTo fromDate: Date, limit: Int?, onlyHighlights: Bool, fieldsIds: [Int]) -> Observable<[InsightServerModel]>
  func insightsStreamFilteredByCriteria(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[InsightServerModel]>
  func welcomeInsightStream() -> Observable<[InsightServerModel]>
  func locations(forInsightUID insightUID: String) -> Observable<[InsightAttachmentServerModel]>
  func insight(byUID uid: String) -> Observable<InsightServerModel?>
}

extension InsightsRepositoryProtocol {
  func insightsStream(byFieldId fieldId: Int) -> Observable<[InsightServerModel]> {
    return insightsStream(byFieldId: fieldId, byCategory: nil, onlyHighlights: false, cycleId: nil, publicationYear: nil)
  }
}
