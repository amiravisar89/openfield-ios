//
//  ContractMapperTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 21/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo
import RxSwift

@testable import Openfield

class GethighlightsUseCaseTest: XCTestCase {
    
    private var insightsFromDateUsecase: MockInsightsFromDateUsecaseProtocol!
    private var insightsFromFieldAndCategoryUsecase: MockInsightsFromFieldAndCategoryUsecaseProtocol!
    private var locationsFromInsightUsecase: MockLocationsFromInsightUsecaseProtocol!
    private var farmFilter: MockFarmFilterProtocol!
    private var gethighlightsUseCaseTest: GetHighlightsUseCase!

    
    override func setUpWithError() throws {
        insightsFromDateUsecase = MockInsightsFromDateUsecaseProtocol()
        insightsFromFieldAndCategoryUsecase = MockInsightsFromFieldAndCategoryUsecaseProtocol()
        locationsFromInsightUsecase = MockLocationsFromInsightUsecaseProtocol()
        farmFilter = MockFarmFilterProtocol()
        
        gethighlightsUseCaseTest = GetHighlightsUseCase(insightsFromDateUsecase: insightsFromDateUsecase, insightsFromFieldAndCategoryUsecase: insightsFromFieldAndCategoryUsecase, locationsFromInsightUsecase: locationsFromInsightUsecase, farmFilter: farmFilter)
    }
    
    func testGetAllHighlights() {
        
        let date = Date(timeIntervalSince1970: 0)
        stub(insightsFromDateUsecase) { mock in
            when(mock.getInsights(insightsFromDate: equal(to: date), limit: equal(to: nil), onlyHighlights: true)).thenReturn(Observable.just([InsightTestModels.irrigationInsight]))
        }
        
        stub(farmFilter) { mock in
            when(mock.farms).get.then { _ in
                BehaviorSubject(value: FarmTestModel.allFarmsSelected)
            }
        }
        stub (locationsFromInsightUsecase) { mock in
            when(mock.locations(forInsightUID: equal(to: InsightTestModels.irrigationInsight.uid)))
                .thenReturn(Observable.just([Openfield.Location]()))
        }
        
        // Act
        var receivedSections: [SectionHighlightItem] = []
        let disposeBag = DisposeBag()
        _ = gethighlightsUseCaseTest.highlights().subscribe(onNext: { sections in
            receivedSections = sections
        })
        .disposed(by: disposeBag)

        // Assert
        XCTAssertNotNil(receivedSections)
        XCTAssertEqual(receivedSections.count, 1)
    }
    
    func testGetHighlightByFieldAndLimits() {
        
        let date = Date(timeIntervalSince1970: 0)
        stub(insightsFromDateUsecase) { mock in
            when(mock.getInsights(insightsFromDate: equal(to: date), limit: equal(to: nil), onlyHighlights: true)).thenReturn(Observable.just([InsightTestModels.irrigationInsight]))
        }
        
        stub(insightsFromFieldAndCategoryUsecase) { mock in
            when(mock.insights(byFieldId: equal(to: MockObjects.mockField.id), byCategory: equal(to: InsightTestModels.irrigationInsight.category), onlyHighlights: true, cycleId: equal(to: nil), publicationYear: equal(to: nil))).thenReturn(Observable.just([InsightTestModels.irrigationInsight]))
        }
        
        stub(farmFilter) { mock in
            when(mock.farms).get.then { _ in
                BehaviorSubject(value: FarmTestModel.allFarmsSelected)
            }
        }
        
        // Act
        var receivedSections: [SectionHighlightItem] = []
        let disposeBag = DisposeBag()
        _ = gethighlightsUseCaseTest.highlights(byFieldId: MockObjects.mockField.id, byCategory: InsightTestModels.irrigationInsight.category).subscribe(onNext: { sections in
            receivedSections = sections
        })
        .disposed(by: disposeBag)

        // Assert
        XCTAssertNotNil(receivedSections)
        XCTAssertEqual(receivedSections.count, 1)
    }
    
    
    
}
