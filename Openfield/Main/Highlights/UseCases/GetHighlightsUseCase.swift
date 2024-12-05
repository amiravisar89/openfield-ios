//
//  GetHighlightsUseCase.swift
//  Openfield
//
//  Created by amir avisar on 10/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Dollar
import Foundation
import RxSwift
import SwiftDate

class GetHighlightsUseCase: GetHighlightsUseCaseProtocol {
  let insightsFromDateUsecase: InsightsFromDateUsecaseProtocol
  let insightsFromFieldAndCategoryUsecase: InsightsFromFieldAndCategoryUsecaseProtocol
  private let locationsFromInsightUsecase: LocationsFromInsightUsecaseProtocol
  let farmFilter: FarmFilterProtocol

  init(insightsFromDateUsecase: InsightsFromDateUsecaseProtocol, insightsFromFieldAndCategoryUsecase: InsightsFromFieldAndCategoryUsecaseProtocol, locationsFromInsightUsecase: LocationsFromInsightUsecaseProtocol, farmFilter: FarmFilterProtocol) {
    self.insightsFromDateUsecase = insightsFromDateUsecase
    self.insightsFromFieldAndCategoryUsecase = insightsFromFieldAndCategoryUsecase
    self.locationsFromInsightUsecase = locationsFromInsightUsecase
    self.farmFilter = farmFilter
  }

  func highlights(limit: Int? = nil, fromDate: Date? = nil) -> Observable<[Highlight]> {
    let insights = insights(limit: limit, fromDate: fromDate)
    return insightsToHighlights(insights: insights)
  }

  func highlights(byFieldId: Int, byCategory: String) -> Observable<[SectionHighlightItem]> {
    let insights = insights(byFieldId: byFieldId, byCategory: byCategory)
    return insightsToHighlights(insights: insights).compactMap { [weak self] insights -> [SectionHighlightItem]? in
      guard let self = self else { return nil }
      let higlights = insights.map { HighlightItem(type: HighlightItemType.getHighlightItemType(for: $0), identity: $0.insight.id, date: $0.insight.publishDate) }
      return self.getSectionItems(items: higlights)
    }
  }

  func highlights() -> Observable<[SectionHighlightItem]> {
    return insightsToHighlights(insights: insights()).compactMap { [weak self] insights -> [SectionHighlightItem]? in
      guard let self = self else { return nil }
      let higlights = insights.map {
        HighlightItem(type: HighlightItemType.getHighlightItemType(for: $0), identity: $0.insight.id, date: $0.insight.publishDate)
      }
      return self.getSectionItems(items: higlights)
    }
  }

  func insightsToHighlights(insights: Observable<[Insight]>) -> Observable<[Highlight]> {
    let queries = insights
      .map { $0.filter { $0.highlight != nil }} // this filter only wrong insights created by BE
      .flatMap { insights in
        let highlightsQuery = insights.map { insight in
          if insight is IrrigationInsight, let imageUrl = insight.thumbnail {
            return Observable.just(Highlight(insight: insight, imageUrl: imageUrl))
          } else {
            return self.locationsFromInsightUsecase.locations(forInsightUID: insight.uid).map { locations in
              guard let imageMetaData = self.getImageMetadata(locations: locations),
                    !imageMetaData.previews.isEmpty,
                    let firstImage = imageMetaData.previews.first
              else {
                return Highlight(insight: insight, imageUrl: insight.thumbnail ?? "")
              }
              return Highlight(insight: insight, imageUrl: firstImage.url)
            }
          }
        }
        return Observable.combineLatest(highlightsQuery)
      }
    return queries
  }

  private func insights(limit: Int? = nil, fromDate: Date? = nil) -> Observable<[Insight]> {
    let insightsStream = insightsFromDateUsecase.getInsights(insightsFromDate: fromDate ?? Date(timeIntervalSince1970: .zero), limit: limit, onlyHighlights: true)
    return Observable.combineLatest(insightsStream, farmFilter.farms).map { [weak self] insights, farms in
      guard let self = self else { return [] }
      return self.filterByFarm(insights: insights, farms: farms)
    }
  }

  private func insights(byFieldId fieldId: Int, byCategory categoryId: String) -> Observable<[Insight]> {
    return insightsFromFieldAndCategoryUsecase.insights(byFieldId: fieldId, byCategory: categoryId, onlyHighlights: true)
  }

  private func filterByFarm(insights: [Insight], farms: [FilteredFarm]) -> [Insight] {
    let selectedFarms = Set(farms.filter { $0.isSelected }.map { $0.name })
    return insights.filter {
      selectedFarms.contains($0.farmName)
    }
  }

  private func getSectionItems(items: [HighlightItem]) -> [SectionHighlightItem] {
    let sectionItemsHash = Dollar.groupBy(items) { item -> String in
      String(format: "%d %d", item.date.weekInYearNum, item.date.year)
    }
    let sectionItems = sectionItemsHash.compactMap { (weekUniqueId: String, items: [HighlightItem]) -> SectionHighlightItem? in
      let sortedItems = items.sorted { $0.date > $1.date }
      guard let firstItemDate = sortedItems.first else { return nil }
      return SectionHighlightItem(startDate: firstItemDate.date.startOfWeek, endDate: firstItemDate.date.endOfWeek, items: sortedItems, id: weekUniqueId)
    }
    return sectionItems.sorted(by: { $0.startDate > $1.startDate })
  }

  private func getImageMetadata(locations: [Location]) -> LocationImageMeatadata? {
    guard let firstLocation = locations.filter({ !$0.images.isEmpty }).first else { return nil }
    return firstLocation.images.first
  }
}
