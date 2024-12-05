//
//  GetRequestReportUrlUseCaseTest.swift
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

class GetRequestReportUrlUseCaseTest: XCTestCase {

    var mockRemoteConfigRepository: MockRemoteConfigRepositoryProtocol = MockRemoteConfigRepositoryProtocol()
    var testedUsecase: GetRequestReportUrlUseCase!

    override func setUp() {
        super.setUp()
        testedUsecase = GetRequestReportUrlUseCase(remoteconfigRepository: mockRemoteConfigRepository)
    }

    func testValidEnUrl() {
        let stringUrl = "https://forms.office.com"
        let locale = Locale(identifier: "en_US")
        let expectedResult = URL(string: stringUrl)

        stub(mockRemoteConfigRepository) { mock in
            when(mock.string(forKey: equal(to: RemoteConfigParameterKey.request_report_en_url))).thenReturn(stringUrl)
        }

        let result = testedUsecase.url(locale: locale)

        XCTAssertEqual(result, expectedResult)

    }
    
    func testInValidEnUrl() {
        let invalidString = ""
        let validStringUrl = "https://forms.office.com"
        let locale = Locale(identifier: "en_US")
        let expectedResult = URL(string: validStringUrl)

        stub(mockRemoteConfigRepository) { mock in
            when(mock.string(forKey: equal(to: RemoteConfigParameterKey.request_report_en_url))).thenReturn(invalidString)
        }
        
        stub(mockRemoteConfigRepository) { mock in
            when(mock.getDefaultValue(forKey: equal(to: RemoteConfigParameterKey.request_report_en_url.rawValue))).thenReturn(validStringUrl)
        }

        let result = testedUsecase.url(locale: locale)

        XCTAssertEqual(result, expectedResult)

    }
    
    func testValidPtUrl() {
        let stringUrl = "https://forms.office.com"
        let locale = Locale(identifier: "pt_BR")
        let expectedResult = URL(string: stringUrl)

        stub(mockRemoteConfigRepository) { mock in
            when(mock.string(forKey: equal(to: RemoteConfigParameterKey.request_report_pt_url))).thenReturn(stringUrl)
        }

        let result = testedUsecase.url(locale: locale)

        XCTAssertEqual(result, expectedResult)

    }
    
    func testInValidPtUrl() {
        let invalidString = ""
        let validStringUrl = "https://forms.office.com"
        let locale = Locale(identifier: "pt_BR")
        let expectedResult = URL(string: validStringUrl)

        stub(mockRemoteConfigRepository) { mock in
            when(mock.string(forKey: equal(to: RemoteConfigParameterKey.request_report_pt_url))).thenReturn(invalidString)
        }
        
        stub(mockRemoteConfigRepository) { mock in
            when(mock.getDefaultValue(forKey: equal(to: RemoteConfigParameterKey.request_report_pt_url.rawValue))).thenReturn(validStringUrl)
        }

        let result = testedUsecase.url(locale: locale)

        XCTAssertEqual(result, expectedResult)

    }
    
}
