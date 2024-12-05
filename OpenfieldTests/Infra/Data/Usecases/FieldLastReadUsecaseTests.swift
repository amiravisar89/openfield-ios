//
//  FieldLastReadUsecaseTests.swift
//  OpenfieldTests
//
//  Created by Yoni Luz on 14/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import XCTest
import Cuckoo
import RxSwift
import Resolver
import Firebase

@testable import Openfield

class FieldLastReadUsecaseTests: XCTestCase {

    var mockFieldsRepo: MockFieldsRepositoryProtocol!
    var mockFieldLastReadMapper: FieldLastReadMapper = Resolver.resolve()
    var fieldLastReadUsecase: FieldLastReadUsecase!

    override func setUp() {
        super.setUp()
        mockFieldsRepo = MockFieldsRepositoryProtocol()
        fieldLastReadUsecase = FieldLastReadUsecase(fieldsRepo: mockFieldsRepo, fieldLastReadMapper: mockFieldLastReadMapper)
    }

    override func tearDown() {
        super.tearDown()
        mockFieldsRepo = nil
        fieldLastReadUsecase = nil
    }

    func testFieldsLastReadStreamIsWorkAndMakeMap() {
        // Arrange
        let date = Date()
        let mockFieldLastReads = [FieldLastReadServerModel(ts_read: Timestamp(date: date), ts_first_read: Timestamp(date: date), fieldId: "1")]
        let expectedMappedResult = [1: FieldLastRead(tsRead: date, tsFirstRead: date)]

        // Stub the mockFieldsRepo's fieldsLastReadStream method
        stub(mockFieldsRepo) { mock in
            when(mock.fieldsLastReadStream()).thenReturn(Observable.just(mockFieldLastReads))
        }

        // Act
        var result: [Int: FieldLastRead]?
        let disposeBag = DisposeBag()
        _ = fieldLastReadUsecase.fieldsLastReadStream().subscribe(onNext: { lastReadMap in
            result = lastReadMap
        })
        .disposed(by: disposeBag)

        // Assert
        XCTAssertNotNil(result, "Result should not be null")
        XCTAssertEqual(result?.count, expectedMappedResult.count, "Mapped result should match count")
        XCTAssertEqual(result?.keys, expectedMappedResult.keys,  "Mapped result should match the keys")

        // Verify that fieldsLastReadStream method was called on appRepo
        verify(mockFieldsRepo).fieldsLastReadStream()

    }
    
    func testUpdateFieldLastReadUsesRepoToUpdate() {
        // Arrange
        let date = Date()
        let id = 1
        let lastRead = FieldLastRead(tsRead: date, tsFirstRead: date)

        // Stub the appRepo's updateFieldLastRead method
        stub(mockFieldsRepo) { mock in
            when(mock.updateFieldLastRead(id: any(), lastRead: any())).thenReturn(Observable.just(()))
        }

        // Act
        let disposeBag = DisposeBag()
        _ = fieldLastReadUsecase.updateFieldLastRead(id: id, lastRead: lastRead).subscribe(onNext: { _ in
        })
        .disposed(by: disposeBag)

        // Verify that updateFieldLastRead method was called on appRepo with the correct parameters
        verify(mockFieldsRepo).updateFieldLastRead(id: equal(to: id), lastRead: equal(to: lastRead))
    }
}

