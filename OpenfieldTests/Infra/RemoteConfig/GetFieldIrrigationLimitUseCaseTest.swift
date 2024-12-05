//
//  GetFieldIrrigationLimitUseCaseTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo
import RxSwift
import Resolver
import Firebase

@testable import Openfield

class GetFieldIrrigationLimitUseCaseTest: XCTestCase {

    var mockRemoteConfigRepository: MockRemoteConfigRepositoryProtocol = MockRemoteConfigRepositoryProtocol()
    var testedUsecase: GetFieldIrrigationLimitUseCase!

    override func setUp() {
        super.setUp()
        testedUsecase = GetFieldIrrigationLimitUseCase(remoteconfigRepository: mockRemoteConfigRepository)
    }

    func testValidLimit() {
        
        let interval = 2
        let expectedResult = interval

        stub(mockRemoteConfigRepository) { mock in
            when(mock.int(forKey: equal(to: RemoteConfigParameterKey.field_irrigation_limit))).thenReturn(interval)
        }

        let result = testedUsecase.fieldIrrigationLimit()

        XCTAssertEqual(result, expectedResult)

    }
    
    func testInValidLimit() {
        
        let validInterval = 2
        let invalidInterval = -2
        let expectedResult = validInterval
  
        stub(mockRemoteConfigRepository) { mock in
            when(mock.int(forKey: equal(to: RemoteConfigParameterKey.field_irrigation_limit))).thenReturn(invalidInterval)
        }
        
        stub(mockRemoteConfigRepository) { mock in
            when(mock.getDefaultValue(forKey: equal(to: RemoteConfigParameterKey.field_irrigation_limit.rawValue))).thenReturn(validInterval)
        }

        let result = testedUsecase.fieldIrrigationLimit()

        XCTAssertEqual(result, expectedResult)

    }
    
}

