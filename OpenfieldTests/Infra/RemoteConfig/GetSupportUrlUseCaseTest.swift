//
//  GetSupportUrlUseCaseTest.swift
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

class GetSupportUrlUseCaseTest: XCTestCase {

    var mockRemoteConfigRepository: MockRemoteConfigRepositoryProtocol = MockRemoteConfigRepositoryProtocol()
    var testedUsecase: GetSupportUrlUseCase!

    override func setUp() {
        super.setUp()
        testedUsecase = GetSupportUrlUseCase(remoteconfigRepository: mockRemoteConfigRepository)
    }

    func testValidEnUrl() {
        let stringUrl = "https://prospera.ag/contact"
        let expectedResult = URL(string: stringUrl)

        stub(mockRemoteConfigRepository) { mock in
            when(mock.string(forKey: equal(to: RemoteConfigParameterKey.mobile_support_url))).thenReturn(stringUrl)
        }

        let result = testedUsecase.url()

        XCTAssertEqual(result, expectedResult)

    }
    
    func testInValidEnUrl() {
        let invalidString = ""
        let validStringUrl = "https://prospera.ag/contact"
        let expectedResult = URL(string: validStringUrl)

        stub(mockRemoteConfigRepository) { mock in
            when(mock.string(forKey: equal(to: RemoteConfigParameterKey.mobile_support_url))).thenReturn(invalidString)
        }
        
        stub(mockRemoteConfigRepository) { mock in
            when(mock.getDefaultValue(forKey: equal(to: RemoteConfigParameterKey.mobile_support_url.rawValue))).thenReturn(validStringUrl)
        }

        let result = testedUsecase.url()

        XCTAssertEqual(result, expectedResult)

    }
    
    
}
