//
//  UserStateProvider+Injection.swift
//  Openfield
//
//  Created by amir avisar on 06/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Firebase
import Foundation
import Resolver

extension Resolver {
    static func registerUserStateProvider() {
        if ConfigEnvironment.boolValueFor(key: .useMock) {
            register { MockUserStateProvider() as UserStateProvider }.scope(application)
        } else {
            register { FirebaseUserStateProvider(auth: Auth.auth()) as UserStateProvider }
        }
    }
}
