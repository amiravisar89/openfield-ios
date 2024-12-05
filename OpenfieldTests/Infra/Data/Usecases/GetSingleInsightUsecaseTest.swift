//
//  GetSingleInsightUsecaseTest.swift
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

class GetSingleInsightUsecaseTest: XCTestCase {
    
    private var mockInsightsRepo: MockInsightsRepositoryProtocol!
    private var mockInsightsUsecase: MockInsightsUsecaseProtocol!
    
    private var getSingleInsightUsecase: GetSingleInsightUsecase!
    
    override func setUpWithError() throws {
        mockInsightsRepo = MockInsightsRepositoryProtocol()
        mockInsightsUsecase = MockInsightsUsecaseProtocol()
        getSingleInsightUsecase = GetSingleInsightUsecase(insightsRepo: mockInsightsRepo, insightsUsecase: mockInsightsUsecase)
    }
    
    func testSingleInsightUseCase() {

        stub(mockInsightsRepo) { mock in
            when(mock.insight(byUID: equal(to: MockObjects.mockInsightServerModel.uid))).thenReturn(Observable.just(MockObjects.mockInsightServerModel))
        }
        
        stub(mockInsightsUsecase) { mock in
            when(mock.generateInsight(insightStream: any()))
                .thenReturn(Observable.just(MockObjects.mockMappedInsight1))
        }

        // Act
        var receivedInsight: Insight?
        let disposeBag = DisposeBag()
        _ = getSingleInsightUsecase.insight(byUID: MockObjects.mockInsightServerModel.uid).subscribe(onNext: { insight in
            receivedInsight = insight
        })
        .disposed(by: disposeBag)

        // Assert
        XCTAssertNotNil(receivedInsight)
    }
    
}
