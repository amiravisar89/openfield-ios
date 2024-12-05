//
//  GetHighlightDaysLimitUseCaseTest.swift
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

class GetHighlightDaysLimitUseCaseTest: XCTestCase {

    var mockRemoteConfigRepository: MockRemoteConfigRepositoryProtocol = MockRemoteConfigRepositoryProtocol()
    var testedUsecase: GetHighlightDaysLimitUseCase!

    override func setUp() {
        super.setUp()
        testedUsecase = GetHighlightDaysLimitUseCase(remoteconfigRepository: mockRemoteConfigRepository)
    }

    func testValidLimit() {
        
        let interval = 14
        let expectedResult = interval

        stub(mockRemoteConfigRepository) { mock in
            when(mock.int(forKey: equal(to: RemoteConfigParameterKey.highlight_days))).thenReturn(interval)
        }

        let result = testedUsecase.highlightDaysLimit()

        XCTAssertEqual(result, expectedResult)

    }
    
    func testInValidLimit() {
        
        let validInterval = 14
        let invalidInterval = -14
        let expectedResult = validInterval
  
        stub(mockRemoteConfigRepository) { mock in
            when(mock.int(forKey: equal(to: RemoteConfigParameterKey.highlight_days))).thenReturn(invalidInterval)
        }
        
        stub(mockRemoteConfigRepository) { mock in
            when(mock.getDefaultValue(forKey: equal(to: RemoteConfigParameterKey.highlight_days.rawValue))).thenReturn(validInterval)
        }

        let result = testedUsecase.highlightDaysLimit()

        XCTAssertEqual(result, expectedResult)

    }
    
}

