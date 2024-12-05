//
//  IsUserFieldOwnerUseTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 11/04/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo
import RxSwift

@testable import Openfield

class IsUserFieldOwnerUseTest: XCTestCase {
    
    private var fieldRepo: MockFieldRepositoryProtocol!
    
    private var isUserFieldOwner: IsUserFieldOwnerUsecase!

    
    override func setUpWithError() throws {
        fieldRepo = MockFieldRepositoryProtocol()
        
        isUserFieldOwner = IsUserFieldOwnerUsecase(fieldRepo: fieldRepo)
    }
    
    func testUserFieldOwner() {
        
        stub(fieldRepo) { mock in
            when(mock.fieldStream(fieldId: equal(to: MockObjects.field1.id))).thenReturn(Observable.just(MockObjects.field1))
        }
        
        // Act
        var isOwnerResult = false
        let disposeBag = DisposeBag()
        _ = isUserFieldOwner.isUserField(fieldId: MockObjects.field1.id).subscribe(onNext: { isOwner in
            isOwnerResult = isOwner
        })
        .disposed(by: disposeBag)

        // Assert
        XCTAssertEqual(isOwnerResult, true)
    }
    
    
}
