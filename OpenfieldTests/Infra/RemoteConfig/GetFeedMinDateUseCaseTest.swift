//
//  GetFeedMinDateUseCaseTest.swift
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

class GetFeedMinDateUseCaseTest: XCTestCase {

    var mockRemoteConfigRepository: MockRemoteConfigRepositoryProtocol = MockRemoteConfigRepositoryProtocol()
    var testedUsecase: GetFeedMinDateUseCase!

    override func setUp() {
        super.setUp()
        testedUsecase = GetFeedMinDateUseCase(remoteconfigRepository: mockRemoteConfigRepository)
    }

    func testValidInterval() {
        
        let interval = 1609459200.0
        let expectedResult = Date(timeIntervalSince1970: interval)
        let oneMonthAgo = Date().minus(component: .month, value: 1) ?? Date()
        
        stub(mockRemoteConfigRepository) { mock in
            when(mock.double(forKey: equal(to: RemoteConfigParameterKey.feed_min_date_v2))).thenReturn(interval)
        }

        let result = testedUsecase.date() < oneMonthAgo

        XCTAssertEqual(result, true)

    }
    
    func testInValidInterval() {
        
        let validInterval = 1609459200.0
        let invalidInterval = 1640995200000.0
        let expectedResult = Date(timeIntervalSince1970: validInterval)
        let oneMonthAgo = Date().minus(component: .month, value: 1) ?? Date()
  
        stub(mockRemoteConfigRepository) { mock in
            when(mock.double(forKey: equal(to: RemoteConfigParameterKey.feed_min_date_v2))).thenReturn(invalidInterval)
        }
        
        stub(mockRemoteConfigRepository) { mock in
            when(mock.getDefaultValue(forKey: equal(to: RemoteConfigParameterKey.feed_min_date_v2.rawValue))).thenReturn(validInterval)
        }

        let result = testedUsecase.date() < oneMonthAgo

        XCTAssertEqual(result, true)

    }
    
  
}

