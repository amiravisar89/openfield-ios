//
//  ExtUserTestModels.swift
//  OpenfieldTests
//
//  Created by amir avisar on 16/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Firebase
import Foundation

@testable import Openfield

enum ExtUserTestModels {
    static let extUserNoUserNameSM = ExtUserServerModel(id: 1234,
                                                        username: nil,
                                                        organization: "Valley_Insights",
                                                        phone: "+15155555555",
                                                        is_demo: false,
                                                        ts_first_login: Date(),
                                                        user_type: nil)

    static let extUserSM = ExtUserServerModel(id: 1234,
                                              username: "name",
                                              organization: "Valley_Insights",
                                              phone: "+15155555555",
                                              is_demo: false,
                                              ts_first_login: Date(),
                                              user_type: nil)
}
