//
//  InsightsPerCategoryUsecaseTests.swift
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

final class InsightsPerCategoryUsecaseTests: XCTestCase {
    
    private var insightUsecase: MockInsightsForFieldUsecaseProtocol!
    
    private var insightsPerCategoryUsecase: LatestInsightPerCategoryUsecase!
    
    override func setUpWithError() throws {
        insightUsecase = MockInsightsForFieldUsecaseProtocol()
        insightsPerCategoryUsecase = LatestInsightPerCategoryUsecase(insightForFieldUsecase: insightUsecase)
    }
    
    
    func testCreateInsightsPerCategory() {
        
        // Set up and mock behavior
        stub(insightUsecase) { mock in
            when(mock.insights(forFieldId: equal(to: MockObjects.field1.id))).thenReturn(Observable.just([MockObjects.mockMappedInsight1, MockObjects.mockMappedInsight2, MockObjects.mockMappedInsight3]))
        }
        
        // Act
        let insightsPerCategory = insightsPerCategoryUsecase.insights(byFieldId: MockObjects.field1.id)
        var receivedInsights: [Insight]?
        let disposeBag = DisposeBag()
        _ = insightsPerCategory.subscribe(onNext: { insights in
            receivedInsights = insights
        })
        .disposed(by: disposeBag)
        
        // Assert
        XCTAssertNotNil(receivedInsights)
        XCTAssertEqual(receivedInsights!.count, 2)
        XCTAssertNotEqual(receivedInsights![0].category, receivedInsights![1].category)
    }
    
}
