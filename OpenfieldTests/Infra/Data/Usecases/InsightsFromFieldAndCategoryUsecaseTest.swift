//
//  InsightsFromFieldAndCategoryUsecaseTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 19/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo
import RxSwift

@testable import Openfield

class InsightsFromFieldAndCategoryUsecaseTest: XCTestCase {
    
    private var insightsRepo: MockInsightsRepositoryProtocol!
    private var insightsUsecase: MockInsightsUsecaseProtocol!
    
    private var insightsFromFieldAndCategoryUsecase: InsightsFromFieldAndCategoryUsecase!

    
    override func setUpWithError() throws {
        insightsUsecase = MockInsightsUsecaseProtocol()
        insightsRepo = MockInsightsRepositoryProtocol()
        insightsFromFieldAndCategoryUsecase = InsightsFromFieldAndCategoryUsecase(insightsRepo: insightsRepo, insightsUsecase: insightsUsecase)
    }
    
    func testQueryInsightsForFieldWithParamsUsecase() {
        
        stub(insightsRepo) { mock in
            when(mock.insightsStream(byFieldId: equal(to: MockObjects.field1.id), byCategory: equal(to: MockObjects.mockInsightServerModel.category), onlyHighlights: false, cycleId: equal(to: nil), publicationYear: equal(to: MockObjects.mockInsightServerModel.publication_year))).thenReturn(Observable.just([MockObjects.mockInsightServerModel]))
        }
        stub(insightsUsecase) { mock in
            when(mock.generateInsights(insightsStream: any())).thenReturn(Observable.just([MockObjects.mockMappedInsight1]))
        }
        
        // Act
        var receivedInsights: [Insight]?
        let disposeBag = DisposeBag()
        _ = insightsFromFieldAndCategoryUsecase.insights(byFieldId: MockObjects.mockMappedInsight1.fieldId, byCategory: MockObjects.mockMappedInsight1.category, publicationYear: MockObjects.mockMappedInsight1.publicationYear).subscribe(onNext: { insights in
            receivedInsights = insights
        })
        .disposed(by: disposeBag)
        
        // Assert
        XCTAssertNotNil(receivedInsights)
        XCTAssertEqual(receivedInsights!.count, 1)
    }
    
}
