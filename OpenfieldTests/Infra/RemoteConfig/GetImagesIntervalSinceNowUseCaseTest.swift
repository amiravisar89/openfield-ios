//
//  GetImagesIntervalSinceNowUseCaseTest.swift
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

class GetImagesIntervalSinceNowUseCaseTest: XCTestCase {

    var mockRemoteConfigRepository: MockRemoteConfigRepositoryProtocol = MockRemoteConfigRepositoryProtocol()
    var getImagesIntervalSinceNowUseCase: GetImagesIntervalSinceNowUseCase!

    override func setUp() {
        super.setUp()
        getImagesIntervalSinceNowUseCase = GetImagesIntervalSinceNowUseCase(remoteconfigRepository: mockRemoteConfigRepository)
    }

    func testValidInterval() {
        
        let interval = 172800.0
        let expectedResult = Date(timeIntervalSinceNow: -interval).startOfDay
  
        stub(mockRemoteConfigRepository) { mock in
            when(mock.double(forKey: equal(to: RemoteConfigParameterKey.images_interval_since_now))).thenReturn(interval)
        }

        let result = getImagesIntervalSinceNowUseCase.imagesIntervalSinceNow()

        XCTAssertEqual(result, expectedResult)

    }
    
    func testInValidInterval() {
        
        let validInterval = 172800.0
        let invalidInterval = -172800.0
        let expectedResult = Date(timeIntervalSinceNow: -validInterval).startOfDay
  
        stub(mockRemoteConfigRepository) { mock in
            when(mock.double(forKey: equal(to: RemoteConfigParameterKey.images_interval_since_now))).thenReturn(invalidInterval)
        }
        
        stub(mockRemoteConfigRepository) { mock in
            when(mock.getDefaultValue(forKey: equal(to: RemoteConfigParameterKey.images_interval_since_now.rawValue))).thenReturn(validInterval)
        }

        let result = getImagesIntervalSinceNowUseCase.imagesIntervalSinceNow()

        XCTAssertEqual(result, expectedResult)

    }
    
  
}
