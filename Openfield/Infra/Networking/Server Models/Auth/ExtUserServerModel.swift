//
//  ExtUserServerModel.swift
//  Openfield
//
//  Created by Daniel Kochavi on 01/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable {
    let ext_user: ExtUserServerModel
}

struct ImpersonateResponse: Decodable {
    let token: String
    let ext_user: ExtUserServerModel
}

struct ExtUserServerModel: Decodable {
    let id: Int
    let username: String?
    let organization: String
    let phone: String
    let is_demo: Bool?
    let ts_first_login: Date?
    let user_type: String?
}
