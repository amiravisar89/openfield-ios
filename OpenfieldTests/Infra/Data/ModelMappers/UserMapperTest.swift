//
//  UserMapperTest.swift
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

class UserMapperTest: QuickSpec {
    override class func spec() {
        let userMapper = UserModelMapper()

        describe("User Mapper") {
            it("test_map_User_when_owner_is_null_then_owner_false") {
                let userReportSM = UserTestModels.userNoOwner
                let user = userMapper.map(userServerModel: userReportSM)

                expect(user.isOwner).to(equal(false))
            }

            it("test_map_User_when_owner_is_null_then_owner_true") {
                let userReportSM = UserTestModels.userOwner
                let user = userMapper.map(userServerModel: userReportSM)

                expect(user.isOwner).to(equal(userReportSM.is_owner))
            }
        }
    }

    
}
