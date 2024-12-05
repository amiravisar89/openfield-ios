//
//  InsightsForFieldUsecaseTests.swift
//  OpenfieldTests
//
//  Created by Yoni Luz on 11/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo
import RxSwift

@testable import Openfield

class InsightsForFieldUsecaseTests: XCTestCase {
    
    private var mockInsightsRepo: MockInsightsRepositoryProtocol!
    private var mockInsightsUsecase: MockInsightsUsecaseProtocol!
    
    private var insightsForFieldUsecase: InsightsForFieldUsecase!
    
    override func setUpWithError() throws {
        mockInsightsRepo = MockInsightsRepositoryProtocol()
        mockInsightsUsecase = MockInsightsUsecaseProtocol()
        insightsForFieldUsecase = InsightsForFieldUsecase(insightsRepo: mockInsightsRepo, insightsUsecase: mockInsightsUsecase)
    }
    
    func testCreateInsightsForField() {
        
        stub(mockInsightsRepo) { mock in
            when(mock.insightsStream(byFieldId: equal(to: MockObjects.field1.id), byCategory: equal(to: nil), onlyHighlights: false, cycleId: equal(to: nil), publicationYear: equal(to: nil))).thenReturn(Observable.just([MockObjects.mockInsightServerModel]))
        }
        stub(mockInsightsUsecase) { mock in
            when(mock.generateInsights(insightsStream: any())).thenReturn(Observable.just([MockObjects.mockMappedInsight1]))
        }
        
        // Act
        var receivedInsights: [Insight]?
        let disposeBag = DisposeBag()
        _ = insightsForFieldUsecase.insights(forFieldId: MockObjects.field1.id).subscribe(onNext: { insights in
            receivedInsights = insights
        })
        .disposed(by: disposeBag)
        
        // Assert
        XCTAssertNotNil(receivedInsights)
        XCTAssertEqual(receivedInsights!.count, 1)
        XCTAssertEqual(receivedInsights![0].category, "irrigation")
    }
    
}
