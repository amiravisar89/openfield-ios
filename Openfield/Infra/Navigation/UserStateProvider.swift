//
//  UserStateProvider.swift
//  Openfield
//
//  Created by amir avisar on 06/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation

protocol UserStateProvider {
    func isUserLoggedIn() -> Bool
}
