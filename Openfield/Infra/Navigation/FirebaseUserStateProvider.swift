//
//  FirebaseUserStateProvider.swift
//  Openfield
//
//  Created by Daniel Kochavi on 03/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Firebase
import Foundation
import SwiftyUserDefaults

struct FirebaseUserStateProvider: UserStateProvider {
    private let auth: Auth

    init(auth: Auth) {
        self.auth = auth
    }

    func isUserLoggedIn() -> Bool {
        return (auth.currentUser?.uid != nil && Defaults.userId != 0)
    }
}
