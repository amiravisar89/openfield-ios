//
//  VirtualScoutingDatesUseCaseTests.swift
//  OpenfieldTests
//
//  Created by Yoni Luz on 18/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo
import RxSwift
import Resolver

@testable import Openfield

class VirtualScoutingDatesUseCaseTests : XCTestCase {
    
    private var virtualScoutingDatesUseCase : VirtualScoutingDatesUseCase!
    private var virtualScoutingRepository: MockVirtualScoutingRepositoryProtocol!
    
    override func setUpWithError() throws {
        virtualScoutingRepository = MockVirtualScoutingRepositoryProtocol()
        virtualScoutingDatesUseCase = VirtualScoutingDatesUseCase(virtualScoutingRepository: virtualScoutingRepository, virtualScoutingModelsMapper: Resolver.resolve())
    }
    
    func testMapper() {
        let cycleId = 1234
        let virtualScoutingDateServerModelList = [VirtualScoutingDateServerModel(grid_id: 1, field_id: MockObjects.field1.id, cycle_id: cycleId, day: "")]
        stub(virtualScoutingRepository) { mock in
            when(mock.getDates(fieldId: MockObjects.mockField.id, cycleId: cycleId, limit: 1)).thenReturn(Observable.just(virtualScoutingDateServerModelList))
        }
        
        // Act
        var datesResult = [VirtualScoutingDate]()
        let disposeBag = DisposeBag()
        _ = virtualScoutingDatesUseCase.getDates(fieldId: MockObjects.mockField.id, cycleId: cycleId, limit: 1).subscribe(onNext: { dates in
            datesResult = dates
        })
        .disposed(by: disposeBag)

        // Assert
        XCTAssertEqual(datesResult.count, 1)
    }
    
}
