//
//  TranslationTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 15/06/2022.
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

class TranslationTest: QuickSpec {
    override class func spec() {
        let translationService = TranslationService(translateProvider: LokaliseTranslationProvider())

        describe("Translation Service") {
            it("test_translate_when_LoclaziedString_is_null_then_defaultValue") {
                let testString = "defualt"
                let result = translationService.localizedString(localizedString: nil, defaultValue: testString)
                expect(result).to(equal(testString))
            }

            it("test_translate_when_LoclaziedString_is_null_then_submit") {
                let testString = "defualt"
                let loclaizedString = LocalizeString(token: "submit", params: nil)
                let expectedResult = "Submit"
                let result = translationService.localizedString(localizedString: loclaizedString, defaultValue: testString)
                expect(result).to(equal(expectedResult))
            }
        }
    }
}
