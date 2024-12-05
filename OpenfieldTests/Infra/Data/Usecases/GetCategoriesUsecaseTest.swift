//
//  GetCategoriesUsecaseTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 13/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo
import RxSwift

@testable import Openfield

class GetCategoriesUsecaseTest: XCTestCase {
    
    private var mockLocationsFromInsightUsecase: MockLocationsFromInsightUsecaseProtocol!
    private var mockInsightsPerCategoryUsecase: MockInsightsPerCategoryUsecaseProtocol!
    
    private var getCategoriesUsecase: GetCategoriesUsecase!
    
    override func setUpWithError() throws {
        mockLocationsFromInsightUsecase = MockLocationsFromInsightUsecaseProtocol()
        mockInsightsPerCategoryUsecase = MockInsightsPerCategoryUsecaseProtocol()
        getCategoriesUsecase = GetCategoriesUsecase(locationsFromInsightUsecase: mockLocationsFromInsightUsecase, insightsPerCategoryUsecase: mockInsightsPerCategoryUsecase)
    }
    
    
    func testGetCategoriesUsecase() {

        stub(mockInsightsPerCategoryUsecase) { mock in
            when(mock.insights(byFieldId: equal(to: MockObjects.field1.id))).thenReturn(Observable.just([MockObjects.mockMappedLocationInsight1]))
        }
        stub(mockLocationsFromInsightUsecase) { mock in
            when(mock.locations(forInsightUID: MockObjects.mockMappedLocationInsight1.uid)).thenReturn(Observable.just([MockObjects.mockLocations1]))
        }

        // Act
        var receivedCategories: [InsightCategory]?
        let disposeBag = DisposeBag()
        _ = getCategoriesUsecase.categories(fieldId: MockObjects.field1.id).subscribe(onNext: { categories in
            receivedCategories = categories
        })
        .disposed(by: disposeBag)

        // Assert
        XCTAssertNotNil(receivedCategories)
        XCTAssertEqual(receivedCategories!.count, 1)
        XCTAssertEqual(receivedCategories![0].categoryId, "canopy_cover")
    }
    
}
