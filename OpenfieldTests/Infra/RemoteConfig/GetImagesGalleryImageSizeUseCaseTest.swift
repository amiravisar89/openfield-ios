//
//  GetImagesGalleryImageSizeUseCaseTest.swift
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

class GetImagesGalleryImageSizeUseCaseTest: XCTestCase {

    var mockRemoteConfigRepository: MockRemoteConfigRepositoryProtocol = MockRemoteConfigRepositoryProtocol()
    var testedUsecase: GetImagesGalleryImageSizeUseCase!

    override func setUp() {
        super.setUp()
        testedUsecase = GetImagesGalleryImageSizeUseCase(remoteconfigRepository: mockRemoteConfigRepository)
    }

    func testValidLimit() {
        
        let interval = 600
        let expectedResult = interval

        stub(mockRemoteConfigRepository) { mock in
            when(mock.int(forKey: equal(to: RemoteConfigParameterKey.image_size_for_gallery))).thenReturn(interval)
        }

        let result = testedUsecase.size()

        XCTAssertEqual(result, expectedResult)

    }
    
    func testInValidLimit() {
        
        let validInterval = 600
        let invalidInterval = -10
        let expectedResult = validInterval
  
        stub(mockRemoteConfigRepository) { mock in
            when(mock.int(forKey: equal(to: RemoteConfigParameterKey.image_size_for_gallery))).thenReturn(invalidInterval)
        }
        
        stub(mockRemoteConfigRepository) { mock in
            when(mock.getDefaultValue(forKey: equal(to: RemoteConfigParameterKey.image_size_for_gallery.rawValue))).thenReturn(validInterval)
        }

        let result = testedUsecase.size()

        XCTAssertEqual(result, expectedResult)

    }
    
}
