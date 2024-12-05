//
//  SmartLookProvider.swift
//  Openfield
//
//  Created by amir avisar on 07/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Firebase
import Foundation
import Smartlook
import SwiftyUserDefaults
import UIKit

protocol SmartLookProvider {
    func track(name: SmartLookEvent, params: [String: String])
    func setupSmartlook()
    func startRecording()
    func stopRecording()
    func updateUser(user: ExtUser)
}

struct SmartLookProviderRecord: SmartLookProvider {
    func track(name: SmartLookEvent, params: [String: String]) {
        Smartlook.trackCustomEvent(name: name.rawValue, props: params)
    }

    func setupSmartlook() {
        let smartlookConfig = Smartlook.SetupConfiguration(key: ConfigEnvironment.valueFor(key: .smartLookAPIKey))
        var integrations = [Smartlook.Integration]()
        integrations.append(Smartlook.FirebaseAnalyticsIntegration(integrationWith: Firebase.Analytics.self))
        integrations.append(Smartlook.FirebaseCrashlyticsIntegration(integrationWith: Firebase.Crashlytics.crashlytics()))
        smartlookConfig.enableIntegrations = integrations
        smartlookConfig.framerate = 2
        Smartlook.setup(configuration: smartlookConfig)
        Smartlook.setUserIdentifier("\(Defaults.extUser?.id ?? -1)")
    }

    func startRecording() {
        Smartlook.startRecording()
    }

    func stopRecording() {
        Smartlook.stopRecording()
    }

    func updateUser(user: ExtUser) {
        if Smartlook.isRecording() {
            Smartlook.setUserIdentifier(String(user.id))
            track(name: SmartLookEvent.USER, params:
                [SmartLookEventKeys.USER_NAME.rawValue: user.username,
                 SmartLookEventKeys.USER_ID.rawValue: String(user.id),
                 SmartLookEventKeys.USER_PHONE.rawValue: user.phone])
        }
    }
}

struct SmartLookProviderEmpty: SmartLookProvider {
    func track(name _: SmartLookEvent, params _: [String: String]) {}

    func setupSmartlook() {}

    func startRecording() {}

    func stopRecording() {}

    func updateUser(user _: ExtUser) {}
}

enum SmartLookEvent: String {
    case USER = "user"
}

enum SmartLookEventKeys: String {
    case USER_NAME = "user_name"
    case USER_ID = "user_id"
    case USER_PHONE = "user_phone"
}
