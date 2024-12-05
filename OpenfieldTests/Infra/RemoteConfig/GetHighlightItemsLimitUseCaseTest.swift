//
//  GetHighlightItemsLimitUseCaseTest.swift
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

class GetHighlightItemsLimitUseCaseTest: XCTestCase {

    var mockRemoteConfigRepository: MockRemoteConfigRepositoryProtocol = MockRemoteConfigRepositoryProtocol()
    var testedUsecase: GetHighlightItemsLimitUseCase!

    override func setUp() {
        super.setUp()
        testedUsecase = GetHighlightItemsLimitUseCase(remoteconfigRepository: mockRemoteConfigRepository)
    }

    func testValidLimit() {
        
        let interval = 10
        let expectedResult = interval

        stub(mockRemoteConfigRepository) { mock in
            when(mock.int(forKey: equal(to: RemoteConfigParameterKey.highlight_items))).thenReturn(interval)
        }

        let result = testedUsecase.highlightItemsLimit()

        XCTAssertEqual(result, expectedResult)

    }
    
    func testInValidLimit() {
        
        let validInterval = 10
        let invalidInterval = -10
        let expectedResult = validInterval
  
        stub(mockRemoteConfigRepository) { mock in
            when(mock.int(forKey: equal(to: RemoteConfigParameterKey.highlight_items))).thenReturn(invalidInterval)
        }
        
        stub(mockRemoteConfigRepository) { mock in
            when(mock.getDefaultValue(forKey: equal(to: RemoteConfigParameterKey.highlight_items.rawValue))).thenReturn(validInterval)
        }

        let result = testedUsecase.highlightItemsLimit()

        XCTAssertEqual(result, expectedResult)

    }
    
}

