//
//  FieldsUsecaseTests.swift
//  OpenfieldTests
//
//  Created by Yoni Luz on 09/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import XCTest
import Cuckoo
import RxSwift
import Firebase

@testable import Openfield

final class FieldsUsecaseTests: XCTestCase {
    
    private var fieldUsecase: FieldsUsecase!
    private var fieldsRepo: MockFieldsRepositoryProtocol!
    private var fieldList: [FieldServerModel]!
    private var fieldImageList: [FieldImageServerModel]!
    
    override func setUpWithError() throws {
        let translationService = TranslationService(translateProvider: MockTranslationPrivder())
        fieldsRepo = MockFieldsRepositoryProtocol()
        fieldUsecase = FieldsUsecase(fieldsRepo: fieldsRepo, fieldMapper: FieldModelMapper(translationService: translationService))
        fieldList = [MockObjects.field1, MockObjects.field2, MockObjects.field3]
        fieldImageList = [MockObjects.fieldImage1, MockObjects.fieldImage2, MockObjects.fieldImage3, MockObjects.fieldImage4, MockObjects.fieldImage5]
    }
    
    func testGet3FieldsWithImagesFromRepoAndShouldOutput3FieldsWithTheirImages() throws {
        
        // Set up and mock behavior
        stub(fieldsRepo) { mock in
            when(mock.fieldsStream()).thenReturn(Observable.just(fieldList))
        }
        stub(fieldsRepo) { mock in
            let dateMatcher = equal(to: Date(timeIntervalSince1970: 0), equalWhen: { $0.timeIntervalSince1970.isAlmostEqual(to: $1.timeIntervalSince1970) })
            
            when(mock.imagesStream(whereDateGreaterThanOrEqualTo: dateMatcher)).thenReturn(Observable.just(fieldImageList))
        }
        // Act
        let fieldsWithImages =  fieldUsecase.getFieldsWithImages()
        var receivedFields: [Field]?
        let disposeBag = DisposeBag()
        _ = fieldsWithImages.subscribe(onNext: { fields in
            receivedFields = fields
        })
        .disposed(by: disposeBag)
        
        // Assert
        XCTAssertNotNil(receivedFields)
        XCTAssertEqual(receivedFields!.count, 3)
        XCTAssertEqual(receivedFields![0].imageGroups.count, 1)
        XCTAssertEqual(receivedFields![1].imageGroups.count, 1)
        XCTAssertEqual(receivedFields![2].imageGroups.count, 2)
        
        // Verify that fieldsStream method was called on fieldsRepo
        verify(fieldsRepo).fieldsStream()
    }
    
    func testGetFieldsWithImagesLast2Days() throws {
        
        let imagesFromDate = Date(timeIntervalSinceNow: -172800).startOfDay
        // Set up and mock behavior
        stub(fieldsRepo) { mock in
            when(mock.fieldsStream()).thenReturn(Observable.just(fieldList))
        }
        stub(fieldsRepo) { mock in
            let imagesList = fieldImageList.filter {
                $0.date.dateValue() >= imagesFromDate
            }
            let dateMatcher = equal(to: imagesFromDate, equalWhen: { $0.timeIntervalSince1970.isAlmostEqual(to: $1.timeIntervalSince1970) })
            when(mock.imagesStream(whereDateGreaterThanOrEqualTo: dateMatcher)).thenReturn(Observable.just(imagesList))
        }
        // Act
        let fieldsWithImages = fieldUsecase.getFieldsWithImages(imagesFromDate: imagesFromDate)
        var receivedFields: [Field]?
        let disposeBag = DisposeBag()
        _ = fieldsWithImages.subscribe(onNext: { fields in
            receivedFields = fields
        })
        .disposed(by: disposeBag)
        
        // Assert
        XCTAssertNotNil(receivedFields)
        XCTAssertEqual(receivedFields!.count, 3)
        XCTAssertTrue(receivedFields![0].imageGroups.isEmpty, "should be empty because the image is 80 hours ago")
        XCTAssertEqual(receivedFields![1].imageGroups.count, 1)
        XCTAssertEqual(receivedFields![2].imageGroups.count, 2)
    }
    
    func testGetFieldsWithoutImages() throws {
        
        // Set up and mock behavior
        stub(fieldsRepo) { mock in
            when(mock.fieldsStream()).thenReturn(Observable.just(fieldList))
        }
        // Act
        var receivedFields: [Field]?
        let disposeBag = DisposeBag()
        _ = fieldUsecase.getFieldsWithoutImages().subscribe(onNext: { fields in
            receivedFields = fields
        })
        .disposed(by: disposeBag)
        
        // Assert
        XCTAssertNotNil(receivedFields)
        XCTAssertEqual(receivedFields!.count, 3)
        XCTAssertTrue(receivedFields![0].imageGroups.isEmpty, "should be empty because we requested without images")
        XCTAssertTrue(receivedFields![1].imageGroups.isEmpty, "should be empty because we requested without images")
        XCTAssertTrue(receivedFields![2].imageGroups.isEmpty, "should be empty because we requested without images")
    }
    
}

extension TimeInterval {
    func isAlmostEqual(to other: TimeInterval, tolerance: TimeInterval = 0.001) -> Bool {
        return abs(self - other) < tolerance
    }
}
