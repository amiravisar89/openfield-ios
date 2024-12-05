//
//  GetFieldIrrigationUsecaseTest.swift
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

class GetFieldIrrigationUsecaseTest: XCTestCase {
    
    private var insightsForFieldUsecase : MockInsightsForFieldUsecaseProtocol!
    private var getFieldIrrigationInsightLimitUseCase : MockGetFieldIrrigationLimitUseCaseProtocol!
    
    private var getFieldIrrigationUsecase: GetFieldIrrigationUsecase!
    
    override func setUpWithError() throws {
        insightsForFieldUsecase = MockInsightsForFieldUsecaseProtocol()
        getFieldIrrigationInsightLimitUseCase = MockGetFieldIrrigationLimitUseCaseProtocol()
        getFieldIrrigationUsecase = GetFieldIrrigationUsecase(InsightsForFieldUsecase: insightsForFieldUsecase, getFieldIrrigationLimitUseCase: getFieldIrrigationInsightLimitUseCase)
    }
    
    func testGetFirldIrrigationUsecase() {
        
        stub(insightsForFieldUsecase) { mock in
            when(mock.insights(forFieldId: equal(to: MockObjects.mockField.id))).thenReturn(Observable.just([InsightTestModels.irrigationInsight]))
            
            when(mock.insightsWithFieldFilter(forFieldId: equal(to: MockObjects.mockField.id), criteria: any(), order: equal(to: 0))).thenReturn(Observable.just([InsightTestModels.irrigationInsight]))
        }
        
        stub(getFieldIrrigationInsightLimitUseCase) { mock in
            when(mock.fieldIrrigationLimit()).thenReturn(2)
        }
        
        // Act
        var receivedIrrigations: [FieldIrrigation] = []
        let disposeBag = DisposeBag()
        _ = getFieldIrrigationUsecase.irrigations(field: MockObjects.mockField, selectedSeasonOrder: 0).subscribe(onNext: { irrigations in
            receivedIrrigations = irrigations
        })
        .disposed(by: disposeBag)

        // Assert
        XCTAssertNotNil(receivedIrrigations)
        XCTAssertEqual(receivedIrrigations.count, 1)
    }
    
}
