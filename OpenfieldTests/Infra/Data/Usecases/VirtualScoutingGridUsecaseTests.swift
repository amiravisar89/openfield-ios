//
//  VirtualScoutingGridUsecaseTests.swift
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

class VirtualScoutingGridUsecaseTests : XCTestCase {
    
    private var virtualScoutingGridUsecase : VirtualScoutingGridUsecase!
    private var virtualScoutingRepository: MockVirtualScoutingRepositoryProtocol!
    
    override func setUpWithError() throws {
        virtualScoutingRepository = MockVirtualScoutingRepositoryProtocol()
        virtualScoutingGridUsecase = VirtualScoutingGridUsecase(virtualScoutingRepository: virtualScoutingRepository, virtualScoutingModelsMapper: Resolver.resolve())
    }
    
    func testMapper() {
        let cycleId = 1234
        let gridId = 1
        let virtualScoutingGridServerModel = VirtualScoutingGridServerModel(id: gridId, field_id: 1, cycle_id: cycleId, geojson: "{}", cover_images: [ScoutingGridImageServerModel(height: 1, width: 1, url: "url", bounds: ImageBoundsServerModel(boundsLeft: 0, boundsBottom: 0, boundsRight: 0, boundsTop: 0), image_type: "rgb")])
        stub(virtualScoutingRepository) { mock in
            when(mock.getGrid(gridId: String(1))).thenReturn(Observable.just(virtualScoutingGridServerModel))
        }
        
        // Act
        var gridResult : VirtualScoutingGrid? = nil
        let disposeBag = DisposeBag()
        _ = virtualScoutingGridUsecase.getGrid(gridId: String(gridId)).subscribe(onNext: { grid in
            gridResult = grid
        })
        .disposed(by: disposeBag)

        // Assert
        XCTAssertNotNil(gridResult, "Result should not be nil")
        XCTAssertEqual(gridResult!.coverImages.count, 1)
    }
    
    
}
