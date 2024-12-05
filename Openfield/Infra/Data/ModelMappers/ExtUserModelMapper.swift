//
//  ExtUserModelMapper.swift
//  Openfield
//
//  Created by Itay Kaplan on 15/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

struct ExtUserModelMapper {
    func map(extUserServerModel: ExtUserServerModel) -> ExtUser {
        return ExtUser(id: extUserServerModel.id,
                       username: extUserServerModel.username ?? "",
                       organization: extUserServerModel.organization,
                       phone: extUserServerModel.phone,
                       tsFirstLogin: extUserServerModel.ts_first_login,
                       isDemo: extUserServerModel.is_demo,
                       isAdmin: extUserServerModel.user_type == "admin")
    }
}
