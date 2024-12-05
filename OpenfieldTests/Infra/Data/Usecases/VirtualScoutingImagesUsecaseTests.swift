//
//  VirtualScoutingImagesUsecaseTests.swift
//  OpenfieldTests
//
//  Created by Yoni Luz on 30/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Cuckoo
import Foundation
import Firebase
import Resolver
import RxSwift
import XCTest

import FirebaseFirestoreInternal
@testable import Openfield

class VirtualScoutingImagesUsecaseTests: XCTestCase {
  private var virtualScoutingImagesUsecase: VirtualScoutingImagesUsecase!
  private var virtualScoutingRepository: MockVirtualScoutingRepositoryProtocol!

  override func setUpWithError() throws {
    virtualScoutingRepository = MockVirtualScoutingRepositoryProtocol()
    virtualScoutingImagesUsecase = VirtualScoutingImagesUsecase(virtualScoutingRepository: virtualScoutingRepository)
  }

  func testRepoCalled() {
    let cycleId = 1234
    let gridId = 1
    let gridCellId = 3
    let virtualScoutingImageServerModel = VirtualScoutingImage(id: 1, gridID: gridId, fieldID: 1, cycleID: cycleId, gridCellID: gridCellId, tsTaken: Timestamp(date: Date()), imageURL: "url", latitude: 1, longitude: 1, width: 1, height: 1, angle: 1, radius: 1, thumbnail: Thumbnail(height: 1, width: 1, url: "url"), labels: nil)
    stub(virtualScoutingRepository) { mock in
      when(mock.getImages(cellId: gridCellId)).thenReturn(Observable.just([virtualScoutingImageServerModel]))
    }

    // Act
    var imagesResult = [VirtualScoutingImage]()
    let disposeBag = DisposeBag()
    _ = virtualScoutingImagesUsecase.getImages(cellId: gridCellId).subscribe(onNext: { images in
      imagesResult = images
    })
    .disposed(by: disposeBag)

    // Assert
    XCTAssertEqual(imagesResult.count, 1)
  }
}
