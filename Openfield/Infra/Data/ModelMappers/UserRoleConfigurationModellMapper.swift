//
//  UserRoleConfigurationModellMapper.swift
//  Openfield
//
//  Created by amir avisar on 04/10/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

class UserRoleConfigurationModellMapper {
    func map(UserRoleServerModel: [UserRoleConfigurationServerModel]) throws -> [UserRoleConfiguration] {
        return UserRoleServerModel.map { userRoleConfigSM -> UserRoleConfiguration in
            UserRoleConfiguration(id: userRoleConfigSM.role, i18n_role: userRoleConfigSM.i18n_role)
        }
    }
}
