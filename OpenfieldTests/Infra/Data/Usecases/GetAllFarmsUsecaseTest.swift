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

final class GetAllFarmsUsecaseTest: XCTestCase {
  
  private var testedUseCase: GetAllFarmsUseCase!
  private var fieldsUseCase: MockFieldsUsecaseProtocol!
  
  override func setUpWithError() throws {
    fieldsUseCase = MockFieldsUsecaseProtocol()
    testedUseCase = GetAllFarmsUseCase(fieldsUseCase: fieldsUseCase)
  }
  
  func test1FarmFor1Field() {
    
    // Set up and mock behavior
    stub(fieldsUseCase) { mock in
      when(mock.getFieldsWithoutImages()).thenReturn(Observable.just([MockObjects.mockField]))
    }
    
    // Act
    let farms = testedUseCase.farms()
    var receivedFarms: [Farm] = []
    let disposeBag = DisposeBag()
    _ = farms.subscribe(onNext: { farms in
      receivedFarms = farms
    })
    .disposed(by: disposeBag)
    
    // Assert
    XCTAssertEqual(receivedFarms.count, 1)
    
  }
  
  func test1FarmFor2Field() {
    
    // Set up and mock behavior
    stub(fieldsUseCase) { mock in
      when(mock.getFieldsWithoutImages()).thenReturn(Observable.just([MockObjects.mockField, MockObjects.mockField]))
    }
    
    // Act
    let farms = testedUseCase.farms()
    var receivedFarms: [Farm] = []
    let disposeBag = DisposeBag()
    _ = farms.subscribe(onNext: { farms in
      receivedFarms = farms
    })
    .disposed(by: disposeBag)
    
    // Assert
    XCTAssertEqual(receivedFarms.count, 1)
    
  }
  
  func test2FarmFor2Field() {
    
    // Set up and mock behavior
    stub(fieldsUseCase) { mock in
      when(mock.getFieldsWithoutImages()).thenReturn(Observable.just([MockObjects.mockField, MockObjects.mockField1]))
    }
    
    // Act
    let farms = testedUseCase.farms()
    var receivedFarms: [Farm] = []
    let disposeBag = DisposeBag()
    _ = farms.subscribe(onNext: { farms in
      receivedFarms = farms
    })
    .disposed(by: disposeBag)
    
    // Assert
    XCTAssertEqual(receivedFarms.count, 2)
    
  }
}
