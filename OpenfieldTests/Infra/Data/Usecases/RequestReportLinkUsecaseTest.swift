//
//  RequestReportLinkUsecaseTest.swift
//  OpenfieldTests
//
//  Created by Yoni Luz on 10/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo
import RxSwift

@testable import Openfield

class RequestReportLinkUsecaseTest : XCTestCase {
    
    private var requestReportLinkUsecase : MockRequestReportLinkUsecaseProtocol!
    
    override func setUpWithError() throws {
        requestReportLinkUsecase = MockRequestReportLinkUsecaseProtocol()
    }
    
    func testShowRequestReport() {
        let url = URL(string: "link")
        
        stub(requestReportLinkUsecase) { mock in
            when(mock.getRequestReportLink(field: any(), selectedSeasonOrder: 0)).thenReturn(Observable.just(url))
        }
        
        // Act
        var linkResult: URL? = URL(string: "")
        let disposeBag = DisposeBag()
         _ = requestReportLinkUsecase.getRequestReportLink(field: MockObjects.mockField, selectedSeasonOrder: 0).subscribe(onNext: { link in
            linkResult = link
        })
        .disposed(by: disposeBag)

        // Assert
        XCTAssertEqual(linkResult, url)
    }
}
