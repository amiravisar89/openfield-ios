//
//  FeatureFlagManager.swift
//  Openfield
//
//  Created by Amitai Efrati on 17/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Firebase
import Foundation
import SwiftyUserDefaults
import LaunchDarkly

class FeatureFlagManager {
    
    init(auth: Auth) {
        listenToAuthUserChanges(auth: auth)
    }
    
    private func listenToAuthUserChanges(auth: Auth) {
        auth.addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            let extUser = Defaults.extUser
            self.updateFeatureFlagWithUserDetails(extUser: extUser)
        }
    }
    
    func updateFeatureFlagWithUserDetails(extUser: ExtUser?) {
        guard let user = extUser else { return }
               
        guard let context = buildContext(user: user) else {
            log.error("Failed to build LDContext with user details")
            return
        }
        
        LDClient.get()?.identify(context: context) { result in
            log.info("LDContext - identify succeded")
        }
    }
    
    private func buildContext(user: ExtUser) -> LDContext? {
        var contextBuilder = LDContextBuilder(key: "\(user.id)")
        contextBuilder.kind(LDKeys.kindUser)
        contextBuilder.trySetValue(LDKeys.id, user.id.toLDValue())
        contextBuilder.trySetValue(LDKeys.phone, user.phone.toLDValue())
        
        do {
            return try contextBuilder.build().get()
        } catch {
            return nil
        }
    }
}

struct LDKeys {
    static let kindUser = "user"
    static let kindAnonymous = "anonymous"
    static let id = "id"
    static let phone = "phone"
}
