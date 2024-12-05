//
//  LatestHighlightsByFarmsUseCaseTest.swift
//  OpenfieldTests
//
//  Created by Amitai Efrati on 14/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
import Foundation
import RxSwift
import XCTest

@testable import Openfield

class LatestHighlightsByFarmsUseCaseTest: XCTestCase {
  private var mockInsightsFromDateUseCase: MockInsightsFromDateUsecaseProtocol!
  private var mockGetHighlightsUseCase: MockGetHighlightsUseCaseProtocol!

  private var latestHighlightsByFarmsUseCase: LatestHighlightsByFarmsUseCase!

  private var disposeBag: DisposeBag!

  override func setUp() {
    super.setUp()

    disposeBag = DisposeBag()
    mockInsightsFromDateUseCase = MockInsightsFromDateUsecaseProtocol()
    mockGetHighlightsUseCase = MockGetHighlightsUseCaseProtocol()
    latestHighlightsByFarmsUseCase = LatestHighlightsByFarmsUseCase(
      insightsFromDateUseCase: mockInsightsFromDateUseCase,
      getHighlightsUseCase: mockGetHighlightsUseCase
    )
  }

  override func tearDown() {
    disposeBag = nil
    mockInsightsFromDateUseCase = nil
    mockGetHighlightsUseCase = nil
    latestHighlightsByFarmsUseCase = nil

    super.tearDown()
  }

  func test_givenSelectedFarms_whenGettingHighlights_thenReturnsExpectedHighlights() {
    let limit = 5
    let date = Date(timeIntervalSince1970: 0)
    let fieldsIds = [1_447_612]
    let insight: Insight = InsightTestModels.irrigationInsight
    let insights = [insight]
    let highlights = [Highlight(insight: insight, imageUrl: "")]
    let excpectedHighlights: [HighlightItem] = [HighlightItem(type: HighlightItemType.getHighlightItemType(for: Highlight(insight: insight, imageUrl: "")), identity: insight.id, date: insight.publishDate)]

    stub(mockInsightsFromDateUseCase) { mock in
      when(mock.getInsightsByFarms(insightsFromDate: any(), limit: any(), onlyHighlights: equal(to: true), fieldsIds: equal(to: fieldsIds)))
        .thenReturn(Observable.just(insights))
    }

    stub(mockGetHighlightsUseCase) { mock in
      when(mock.insightsToHighlights(insights: any()))
        .thenReturn(Observable.just(highlights))
    }

    var result: [HighlightItem]?

    latestHighlightsByFarmsUseCase.getHighlightsForFarms(limit: limit, fromDate: date, fieldsIds: fieldsIds)
      .subscribe(onNext: { highlights in
        result = highlights
      }).disposed(by: disposeBag)

    XCTAssertEqual(result?.count, excpectedHighlights.count)
    XCTAssertEqual(result?.first?.identity, excpectedHighlights.first?.identity)
    verify(mockInsightsFromDateUseCase, times(1)).getInsightsByFarms(
      insightsFromDate: any(),
      limit: limit,
      onlyHighlights: true,
      fieldsIds: fieldsIds
    )

    verify(mockInsightsFromDateUseCase, times(1)).getInsightsByFarms(
      insightsFromDate: any(),
      limit: 1,
      onlyHighlights: true,
      fieldsIds: fieldsIds
    )

    verify(mockGetHighlightsUseCase, times(1)).insightsToHighlights(insights: any())
  }

  func test_givenNoHighlights_whenGettingHighlights_thenReturnsEmptyList() {
    let limit = 5
    let date = Date(timeIntervalSince1970: 0)
    let fieldsIds = [1_447_612]

    stub(mockInsightsFromDateUseCase) { mock in
      when(mock.getInsightsByFarms(insightsFromDate: any(), limit: any(), onlyHighlights: equal(to: true), fieldsIds: equal(to: fieldsIds)))
        .thenReturn(Observable.just([]))
    }

    stub(mockGetHighlightsUseCase) { mock in
      when(mock.insightsToHighlights(insights: any()))
        .thenReturn(Observable.just([]))
    }

    var result: [HighlightItem]?

    latestHighlightsByFarmsUseCase.getHighlightsForFarms(limit: limit, fromDate: date, fieldsIds: fieldsIds)
      .subscribe(onNext: { highlights in
        result = highlights
      }).disposed(by: disposeBag)

    XCTAssertNotNil(result)
    XCTAssertTrue(result!.isEmpty)

    verify(mockInsightsFromDateUseCase, times(1)).getInsightsByFarms(
      insightsFromDate: any(),
      limit: limit,
      onlyHighlights: true,
      fieldsIds: fieldsIds
    )

    verify(mockInsightsFromDateUseCase, times(1)).getInsightsByFarms(
      insightsFromDate: any(),
      limit: 1,
      onlyHighlights: true,
      fieldsIds: fieldsIds
    )

    verify(mockGetHighlightsUseCase, times(1)).insightsToHighlights(insights: any())
  }
}
