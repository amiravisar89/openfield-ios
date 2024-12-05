//
//  UserTestModels.swift
//  OpenfieldTests
//
//  Created by amir avisar on 16/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Firebase
import Foundation

@testable import Openfield

enum UserTestModels {
    static let userNoOwner = UserServerModel(email: nil,
                                             first_name: nil,
                                             id: 1234,
                                             last_name: nil,
                                             phone: "+15155555555",
                                             username: nil,
                                             insights: [:],
                                             user_reports: [:],
                                             settings: nil,
                                             tracking: nil,
                                             is_owner: nil,
                                             subscription_types: ["aerial", "panda"])

    static let userOwner = UserServerModel(email: nil,
                                           first_name: nil,
                                           id: 1234,
                                           last_name: nil,
                                           phone: "+15155555555",
                                           username: nil,
                                           insights: [:],
                                           user_reports: [:],
                                           settings: nil,
                                           tracking: nil,
                                           is_owner: true,
                                           subscription_types: ["aerial", "panda"])
}
