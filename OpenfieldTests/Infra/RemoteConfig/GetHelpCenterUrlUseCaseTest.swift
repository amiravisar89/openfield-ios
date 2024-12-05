//
//  GetHelpCenterUrlUseCaseTest.swift
//  OpenfieldTests
//
//  Created by Amitai Efrati on 12/11/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo
import RxSwift
import Resolver
import Firebase

@testable import Openfield

class GetHelpCenterUrlUseCaseTest: XCTestCase {

    var mockRemoteConfigRepository: MockRemoteConfigRepositoryProtocol!
    var testedUsecase: GetHelpCenterUrlUseCase!

    override func setUp() {
        super.setUp()
        mockRemoteConfigRepository = MockRemoteConfigRepositoryProtocol()
        testedUsecase = GetHelpCenterUrlUseCase(remoteconfigRepository: mockRemoteConfigRepository)
    }
  
    override func tearDown() {
        mockRemoteConfigRepository = nil
        testedUsecase = nil
        super.tearDown()
    }

    func testValidEnUrl() {
        let stringUrl = "https://prospera.ag/contact"
        let expectedResult = URL(string: stringUrl)

        stub(mockRemoteConfigRepository) { mock in
            when(mock.string(forKey: equal(to: RemoteConfigParameterKey.mobile_help_center_url))).thenReturn(stringUrl)
        }

        let result = testedUsecase.getUrl()

        XCTAssertEqual(result, expectedResult)
    }
    
    func testInValidEnUrl() {
        let invalidString = ""
        let validStringUrl = "https://prospera.ag/contact"
        let expectedResult = URL(string: validStringUrl)

        stub(mockRemoteConfigRepository) { mock in
            when(mock.string(forKey: equal(to: RemoteConfigParameterKey.mobile_help_center_url))).thenReturn(invalidString)
        }
        
        stub(mockRemoteConfigRepository) { mock in
            when(mock.getDefaultValue(forKey: equal(to: RemoteConfigParameterKey.mobile_help_center_url.rawValue))).thenReturn(validStringUrl)
        }

        let result = testedUsecase.getUrl()

        XCTAssertEqual(result, expectedResult)
    }
}

