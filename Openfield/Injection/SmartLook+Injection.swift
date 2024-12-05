//
//  SmartLook+Injection.swift
//  Openfield
//
//  Created by amir avisar on 07/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import Resolver

extension Resolver {
    static func registerSmartLook() {
        register { SmartLookProviderAppDelegateSerivces(smartlookProvider: resolve()) }.scope(application)
        if ConfigEnvironment.boolValueFor(key: .useMock) || ConfigEnvironment.isDebugMode {
            register { SmartLookProviderEmpty() as SmartLookProvider }.scope(application)
        } else {
            register { SmartLookProviderRecord() as SmartLookProvider }.scope(application)
        }
    }
}
