//
//  UserRoleConfigurationServerModel.swift
//  Openfield
//
//  Created by amir avisar on 04/10/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

struct UserRoleConfigurationServerModel: Decodable {
    let role: String
    let i18n_role: LocalizeString?
}

struct UserRoleConfiguration: Decodable {
    static let OtherRoleId = "Other"

    let id: String
    let i18n_role: LocalizeString?
}
