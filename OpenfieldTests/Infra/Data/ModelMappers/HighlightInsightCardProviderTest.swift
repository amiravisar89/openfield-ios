//
//  ContractMapperTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 21/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Fakery
import Firebase
import Foundation
import Nimble
import Quick
import Resolver
import SwiftDate

@testable import Openfield

class HighlightInsightCardProviderTest: QuickSpec {
    override class func spec() {
        
        let dateProvider: DateProvider = Resolver.resolve()
        let cardProvider = HighlightInsightCardProvider(dateProvider: dateProvider)
        
        describe("HighlightInsightCardProvider test") {
            it("map_cards_when_count_is_2_then_return_count_2") {
                let irrigationInsights1 = InsightTestModels.irrigationInsight
                let irrigationInsights2 = InsightTestModels.irrigationInsight
                let items = [HighlightItem(type: HighlightItemType.getHighlightItemType(for: Highlight(insight: irrigationInsights1, imageUrl: "")), identity: irrigationInsights1.id, date: irrigationInsights1.publishDate),
                             HighlightItem(type: HighlightItemType.getHighlightItemType(for: Highlight(insight: irrigationInsights2, imageUrl: "")), identity: irrigationInsights2.id, date: irrigationInsights2.publishDate)]
                let highlightUiElements = cardProvider.cards(highlights: items)
                expect(highlightUiElements.count).to(equal(2))
            }

            it("map_card_when_insight_subject_then_card_insight") {
                let irrigationInsight = InsightTestModels.irrigationInsight
                    let item = HighlightItem(type: HighlightItemType.getHighlightItemType(for: Highlight(insight: irrigationInsight, imageUrl: "")), identity: irrigationInsight.id, date: irrigationInsight.publishDate)
                let highlightUiElements = cardProvider.cards(highlights: [item])
                let highlightUiElement = highlightUiElements.first?.type
                switch highlightUiElement {
                case .cardData(let card):
                    expect(card.insight).to(equal(irrigationInsight.highlight))
                case .empty, .none:
                    expect(true).to(beTrue(), description: "Encountered empty case, which is expected in this case")
                }
                 
            }
            
            it("map_card_when_insight_irrigation_then_card_insightType_irrigation") {
                let irrigationInsight = InsightTestModels.irrigationInsight
                    let item = HighlightItem(type: HighlightItemType.getHighlightItemType(for: Highlight(insight: irrigationInsight, imageUrl: "")), identity: irrigationInsight.id, date: irrigationInsight.publishDate)
                let highlightUiElements = cardProvider.cards(highlights: [item])
                let highlightUiElement = highlightUiElements.first?.type
                switch highlightUiElement {
                case .cardData(let card):
                    expect(card.insightType).to(equal(R.string.localizable.fieldIrrigationInsights()))
                case .empty, .none:
                    expect(true).to(beTrue(), description: "Encountered empty case, which is expected in this case")
                }
            }
            
            it("map_card_when_insight_irrigation_then_card_insightType_single_location") {
                let singleLocationInsight = InsightTestModels.singleLocationInsight
                    let item = HighlightItem(type: HighlightItemType.getHighlightItemType(for: Highlight(insight: singleLocationInsight, imageUrl: "")), identity: singleLocationInsight.id, date: singleLocationInsight.publishDate)
                let highlightUiElements = cardProvider.cards(highlights: [item])
                let highlightUiElement = highlightUiElements.first?.type
                switch highlightUiElement {
                case .cardData(let card):
                    expect(card.insightType).to(equal(R.string.localizable.insightFirstDetectionLowerCase()))
                case .empty, .none:
                    expect(true).to(beTrue(), description: "Encountered empty case, which is expected in this case")
                }
            }
    
        }
    }
}
