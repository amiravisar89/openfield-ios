//
//  InsightsFromDateUsecase.swift
//  Openfield
//
//  Created by Yoni Luz on 31/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class InsightsFromDateUsecase: InsightsFromDateUsecaseProtocol {
  private let insightsRepo: InsightsRepositoryProtocol
  private let insightsUsecase: InsightsUsecaseProtocol

  init(insightsRepo: InsightsRepositoryProtocol, insightsUsecase: InsightsUsecaseProtocol) {
    self.insightsUsecase = insightsUsecase
    self.insightsRepo = insightsRepo
  }

  func getInsights(insightsFromDate: Date = Date(timeIntervalSince1970: 0), limit: Int? = nil, onlyHighlights: Bool = false) -> Observable<[Insight]> {
    let insightsStream = insightsRepo.insightsStream(whereDateGreaterThanOrEqualTo: insightsFromDate, limit: limit, onlyHighlights: onlyHighlights)
    return insightsUsecase.generateInsights(insightsStream: insightsStream)
  }

  func getInsightsByFarms(insightsFromDate: Date = Date(timeIntervalSince1970: 0), limit: Int? = nil, onlyHighlights: Bool = false, fieldsIds: [Int]) -> Observable<[Insight]> {
    let insightsStream = insightsRepo.insightsStreamByFarms(whereDateGreaterThanOrEqualTo: insightsFromDate, limit: limit, onlyHighlights: onlyHighlights, fieldsIds: fieldsIds)
    return insightsUsecase.generateInsights(insightsStream: insightsStream)
  }
}
