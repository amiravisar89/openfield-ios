//
//  SmartLookManager.swift
//  Openfield
//
//  Created by amir avisar on 24/06/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Firebase
import Smartlook
import SwiftyUserDefaults
import UIKit

class SmartLookManager: NSObject {
    static var SmartLookAPIkey: String {
        return ConfigEnvironment.valueFor(key: .smartLookAPIKey)
    }

    static func track(name: SmartLookEvent, params: [String: String]) {
        Smartlook.trackCustomEvent(name: name.rawValue, props: params)
    }

    static func setupSmartlook() {
        let smartlookConfig = Smartlook.SetupConfiguration(key: SmartLookAPIkey)
        var integrations = [Smartlook.Integration]()
        integrations.append(Smartlook.FirebaseAnalyticsIntegration(integrationWith: Firebase.Analytics.self))
        integrations.append(Smartlook.FirebaseCrashlyticsIntegration(integrationWith: Firebase.Crashlytics.crashlytics()))
        smartlookConfig.enableIntegrations = integrations
        smartlookConfig.framerate = 2
        Smartlook.setup(configuration: smartlookConfig)
        Smartlook.setUserIdentifier("\(Defaults.extUser?.id ?? -1)")
    }

    static func startRecording() {
        Smartlook.startRecording()
    }

    static func updateUser(user: ExtUser) {
        if Smartlook.isRecording() {
            Smartlook.setUserIdentifier(String(user.id))
            SmartLookManager.track(name: SmartLookEvent.USER, params:
                [SmartLookEventKeys.USER_NAME.rawValue: user.username,
                 SmartLookEventKeys.USER_ID.rawValue: String(user.id),
                 SmartLookEventKeys.USER_PHONE.rawValue: user.phone])
        }
    }

    static func stopRecording() {
        Smartlook.stopRecording()
    }
}

enum SmartLookEvent: String {
    case USER = "user"
}

enum SmartLookEventKeys: String {
    case USER_NAME = "user_name"
    case USER_ID = "user_id"
    case USER_PHONE = "user_phone"
}
