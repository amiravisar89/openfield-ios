//
//  LatestHighlightsByFarmsUseCase.swift
//  Openfield
//
//  Created by Amitai Efrati on 13/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class LatestHighlightsByFarmsUseCase: LatestHighlightsByFarmsUseCaseProtocol {
  private let insightsFromDateUseCase: InsightsFromDateUsecaseProtocol
  private let getHighlightsUseCase: GetHighlightsUseCaseProtocol

  init(
    insightsFromDateUseCase: InsightsFromDateUsecaseProtocol,
    getHighlightsUseCase: GetHighlightsUseCaseProtocol
  ) {
    self.insightsFromDateUseCase = insightsFromDateUseCase
    self.getHighlightsUseCase = getHighlightsUseCase
  }

  func getHighlightsForFarms(
    limit: Int?,
    fromDate: Date?,
    fieldsIds: [Int]
  ) -> Observable<[HighlightItem]> {
    let getHightlightsByDateForFarms = getHightlightsByDateForFarms(limit: limit, fromDate: fromDate, fieldsIds: fieldsIds)
    let hasAtLeastOneHighlightForFarms = hasAtLeastOneHighlightForFarms(fromDate: nil, fieldsIds: fieldsIds)
    return Observable.combineLatest(getHightlightsByDateForFarms, hasAtLeastOneHighlightForFarms).map { highlights, anyHighlights in
      var result = highlights.map {
        HighlightItem(type: HighlightItemType.getHighlightItemType(for: $0), identity: $0.insight.id, date: $0.insight.publishDate)
      }
      if result.isEmpty && anyHighlights {
        result.append(HighlightItem(type: .empty, identity: .zero, date: Date()))
      }
      return result
    }
  }

  private func getHightlightsByDateForFarms(
    limit: Int?,
    fromDate: Date?,
    fieldsIds: [Int]
  ) -> Observable<[Highlight]> {
    let date = fromDate ?? Date(timeIntervalSince1970: .zero)
    let insights = getInsights(limit: limit, date: date, fieldsIds: fieldsIds)
    return getHighlightsUseCase.insightsToHighlights(insights: insights)
  }

  private func hasAtLeastOneHighlightForFarms(fromDate: Date?, fieldsIds: [Int]) -> Observable<Bool> {
    let insights = getInsights(limit: 1, date: fromDate, fieldsIds: fieldsIds)
    return insights.map {
      !$0.isEmpty
    }
  }

  private func getInsights(limit: Int?, date: Date?, fieldsIds: [Int]) -> Observable<[Insight]> {
    return insightsFromDateUseCase.getInsightsByFarms(insightsFromDate: date ?? Date(timeIntervalSince1970: 0), limit: limit, onlyHighlights: true, fieldsIds: fieldsIds)
  }
}
