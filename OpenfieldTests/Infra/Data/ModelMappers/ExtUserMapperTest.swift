//
//  ExtUserMapperTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 15/08/2022.
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

class ExtUserMapperTest: QuickSpec {
    override class func spec() {
        func testExtUser() {
            let extUSerMapper = ExtUserModelMapper()

            describe("Ext User Mapper") {
                it("test_map_ExtUser_when_userName_is_null_then_userName_empty_string") {
                    let extUserSM = ExtUserTestModels.extUserNoUserNameSM
                    let extUser = extUSerMapper.map(extUserServerModel: extUserSM)

                    expect(extUser.username).to(equal(""))
                }

                it("test_map_ExtUser_when_userName_is_not_null_then_userName_userName") {
                    let extUserSM = ExtUserTestModels.extUserSM
                    let extUser = extUSerMapper.map(extUserServerModel: extUserSM)

                    expect(extUser.username).to(equal(extUserSM.username))
                }
            }
        }
    }
}
