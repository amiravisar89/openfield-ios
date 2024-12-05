//
//  ContractMapperTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 21/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Fakery
import Firebase
import FirebaseFirestoreSwift
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
                let irrigationInsights = [InsightTestModels.irrigationInsight,InsightTestModels.irrigationInsight]
                let cards = cardProvider.cards(insights: irrigationInsights)

                expect(cards.count).to(equal(2))
            }

            it("map_card_when_insight_subject_then_card_insight") {
                let irrigationInsight = InsightTestModels.irrigationInsight
                let cards = cardProvider.cards(insights: [irrigationInsight])
                let card = cards.first
                expect(card?.insight).to(equal(irrigationInsight.subject))
            }
            
            it("map_card_when_insight_irrigation_then_card_insightType_irrigation") {
                let irrigationInsight = InsightTestModels.irrigationInsight
                let cards = cardProvider.cards(insights: [irrigationInsight])
                let card = cards.first
                expect(card?.insightType).to(equal(R.string.localizable.fieldIrrigationInsights() + " (\(dateProvider.format(date: Date(), format: .shortNoDay)))"))
            }
            
            it("map_card_when_insight_irrigation_then_card_insightType_single_location") {
                let singleLocationInsight = InsightTestModels.singleLocationInsight
                let cards = cardProvider.cards(insights: [singleLocationInsight])
                let card = cards.first
                expect(card?.insightType).to(equal(R.string.localizable.insightFirstDetectionLowerCase() + " (\(dateProvider.format(date: Date(), format: .shortNoDay)))"))
            }
    
        }
    }
}
