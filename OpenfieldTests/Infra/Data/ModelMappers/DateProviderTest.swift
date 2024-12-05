//
//  DateProviderTest.swift
//  OpenfieldTests
//
//  Created by Daniel Kochavi on 24/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Nimble
import Quick
import Resolver
import SwiftDate

@testable import Openfield

class DateProviderTest: QuickSpec {

    override class func spec() {
        
        let dateProvider: DateProvider = Resolver.resolve()
        
        describe("TimeAgo") {
            it("test_dateProvider_when_7.25_days_then_1w_ago") {
                let testDate = Date() - 7.days - 6.hours
                expect(dateProvider.timeAgoSince(testDate)).to(contain("1w ago"))
            }
            it("test_dateProvider_when_7_days_then_1w_ago") {
                let testDate = Date() - 7.days
                expect(dateProvider.timeAgoSince(testDate)).to(contain("1w ago"))
            }
            it("test_dateProvider_when_6.5_days_then_1w_ago") {
                let testDate = Date() - 6.days - 18.hours
                expect(dateProvider.timeAgoSince(testDate)).to(contain("1w ago"))
            }
            it("test_dateProvider_when_6.5_days_then_6d_ago") {
                let testDate = Date() - 6.days - 6.hours
                expect(dateProvider.timeAgoSince(testDate)).to(contain("6d ago"))
            }
            it("test_dateProvider_when_5.75_days_then_6d_ago") {
                let testDate = Date() - 5.days - 18.hours
                expect(dateProvider.timeAgoSince(testDate)).to(contain("6d ago"))
            }
            it("test_dateProvider_when_29.75_days_then_1m_ago") {
                let testDate = Date() - 29.days - 18.hours
                expect(dateProvider.timeAgoSince(testDate)).to(contain("1mo ago"))
            }
            it("test_dateProvider_when_364_days_then_1y_ago") {
                let testDate = Date() - 364.days
                expect(dateProvider.timeAgoSince(testDate)).to(contain("12mo ago"))
            }
            it("test_dateProvider_when_364.75_days_then_1y_ago") {
                let testDate = Date() - 364.days - 18.hours
                expect(dateProvider.timeAgoSince(testDate)).to(contain("1y ago"))
            }
        }
    }
}
