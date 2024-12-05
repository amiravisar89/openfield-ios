//
//  ContractMapperTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 21/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo
import RxSwift

@testable import Openfield

class GetHighlightsForFieldsUsecaseTest: XCTestCase {
    

    private var getHighlightsUseCase: MockGetHighlightsUseCaseProtocol!
    private var getHighlightsForFieldsUsecase: GetHighlightsForFieldsUsecase!

    
    override func setUpWithError() throws {
        getHighlightsUseCase = MockGetHighlightsUseCaseProtocol()
        getHighlightsForFieldsUsecase = GetHighlightsForFieldsUsecase(getHighlightsUseCase: getHighlightsUseCase)
    }
    
    func testHighlightsForField() {
        
        let date = Date(timeIntervalSince1970: 0)
        
        stub(getHighlightsUseCase) { mock in
            when(mock.highlights(limit: equal(to: nil), fromDate: equal(to: date))).thenReturn(Observable.just([Highlight(insight: InsightTestModels.irrigationInsight, imageUrl: "")]))
        }
        
        stub(getHighlightsUseCase) { mock in
            when(mock.highlights(limit: equal(to: 1), fromDate: equal(to: nil))).thenReturn(Observable.just([Highlight(insight: InsightTestModels.irrigationInsight, imageUrl: "")]))
        }
        
        // Act
        var receivedItems: [HighlightItem] = []
        let disposeBag = DisposeBag()
        _ = getHighlightsForFieldsUsecase.highlights(limit : nil, fromDate: date).subscribe(onNext: { items in
            receivedItems = items
        })
        .disposed(by: disposeBag)

        // Assert
        XCTAssertNotNil(receivedItems)
        XCTAssertEqual(receivedItems.count, 1)
    }
    
    
}
