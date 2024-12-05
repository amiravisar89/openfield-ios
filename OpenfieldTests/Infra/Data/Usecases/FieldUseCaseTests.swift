//
//  FieldWithImagesUsecaseTests.swift
//  OpenfieldTests
//
//  Created by Yoni Luz on 25/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

import XCTest
import Cuckoo
import RxSwift
@testable import Openfield

final class FieldUseCaseTests: XCTestCase {
    
    private var fieldUsecase: FieldUseCase!
    private var fieldRepo: MockFieldRepositoryProtocol!
    private var fieldMapper: FieldModelMapper!
    
    override func setUpWithError() throws {
        let translationService = TranslationService(translateProvider: MockTranslationPrivder())
        fieldRepo = MockFieldRepositoryProtocol()
        fieldMapper = FieldModelMapper(translationService: translationService)
        fieldUsecase = FieldUseCase(fieldRepo: fieldRepo, fieldMapper: fieldMapper)
    }
    
    func testFieldWithImagesStreamCreation() {
        
        // Set up and mock behavior
        stub(fieldRepo) { mock in
            when(mock.fieldStream(fieldId: equal(to: MockObjects.field1.id))).thenReturn(Observable.just(MockObjects.field1))
        }
        stub(fieldRepo) { mock in
            when(mock.imagesStream(fieldId: equal(to: MockObjects.field1.id))).thenReturn(Observable.just([MockObjects.fieldImage1]))
        }
        
        // Act
        let fieldsWithImages =  fieldUsecase.getFieldWithImages(fieldId: MockObjects.field1.id)
        var receivedField: Field?
        let disposeBag = DisposeBag()
        _ = fieldsWithImages.subscribe(onNext: { field in
            receivedField = field
        })
        .disposed(by: disposeBag)
        
        // Assert
        XCTAssertNotNil(receivedField)
        XCTAssertEqual(receivedField!.imageGroups.count, 1)
        
    }
}
