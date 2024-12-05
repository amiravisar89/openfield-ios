//
//  GetRequestReportStartYearUseCaseTest.swift
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

class GetRequestReportStartYearUseCaseTest: XCTestCase {

    var mockRemoteConfigRepository: MockRemoteConfigRepositoryProtocol = MockRemoteConfigRepositoryProtocol()
    var testedUseCase: GetRequestReportStartYearUseCase!

    override func setUp() {
        super.setUp()
        testedUseCase = GetRequestReportStartYearUseCase(remoteconfigRepository: mockRemoteConfigRepository)
    }

    func testValidInterval() {
        
        let year = 2024
        let expectedResult = year
  
        stub(mockRemoteConfigRepository) { mock in
            when(mock.int(forKey: equal(to: RemoteConfigParameterKey.start_year_for_request_report))).thenReturn(year)
        }

        let result = testedUseCase.year()

        XCTAssertEqual(result, expectedResult)

    }
    
    func testInValidInterval() {
        
        let validYear = 2024
        let invalidYear = Date().year + 1
        let expectedResult = validYear
  
        stub(mockRemoteConfigRepository) { mock in
            when(mock.int(forKey: equal(to: RemoteConfigParameterKey.start_year_for_request_report))).thenReturn(invalidYear)
        }
        
        stub(mockRemoteConfigRepository) { mock in
            when(mock.getDefaultValue(forKey: equal(to: RemoteConfigParameterKey.start_year_for_request_report.rawValue))).thenReturn(validYear)
        }

        let result = testedUseCase.year()

        XCTAssertEqual(result, expectedResult)

    }
    
}
