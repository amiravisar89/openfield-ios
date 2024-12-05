//
//  GetFieldImageryUsecaseTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 14/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo
import RxSwift

@testable import Openfield

class GetFieldImageryUsecaseTest: XCTestCase {
    
    private var fieldUseCase: MockFieldUseCaseProtocol!
    
    private var fieldRepo: MockFieldRepositoryProtocol!
    private var fieldMapper: FieldModelMapper!
    private var getFieldImageryUsecase: GetFieldImageryUsecase!
    
    override func setUpWithError() throws {
        let translationService = TranslationService(translateProvider: MockTranslationPrivder())
        fieldUseCase = MockFieldUseCaseProtocol()
        fieldRepo = MockFieldRepositoryProtocol()
        fieldMapper = FieldModelMapper(translationService: translationService)
        getFieldImageryUsecase = GetFieldImageryUsecase(fieldRepo: fieldRepo, fieldMapper: fieldMapper, fieldUseCase: fieldUseCase)
    }
    
    func testGetFieldImageryUsecase() {
        
        stub(fieldUseCase) { mock in
            when(mock.getFieldWithImages(fieldId: equal(to: MockObjects.mockField.id))).thenReturn(Observable.just(MockObjects.mockField))
        }
        
        // Act
        var receivedImages: [FieldImage] = []
        let disposeBag = DisposeBag()
        _ = getFieldImageryUsecase.fieldImages(fieldId: MockObjects.mockField.id).subscribe(onNext: { images in
            receivedImages = images
        })
        .disposed(by: disposeBag)

        // Assert
        XCTAssertNotNil(receivedImages)
        XCTAssertEqual(receivedImages.count, 1)
    }
    
}
