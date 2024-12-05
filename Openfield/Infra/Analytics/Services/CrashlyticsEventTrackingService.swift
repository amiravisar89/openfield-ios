//
//  CrashlyticsEventTrackingService.swift
//  Openfield
//
//  Created by Daniel Kochavi on 09/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import FirebaseCrashlytics
import SwiftyUserDefaults

class CrashlyticsEventTrackingService: EventTrackingAnalyticsService {
    init() {
        setAnalyticsAccount(account: EventTrackingAnalyticsServiceAccount(id: "\(Defaults.extUser?.id ?? -1)",
                                                                          imperonator: Defaults.impersonatorId.map { String($0) })
        )
    }

    func setAnalyticsAccount(account: EventTrackingAnalyticsServiceAccount) {
        CrashlyticsEventTrackingService.updateUser(userId: account.id)
        CrashlyticsEventTrackingService.setCustomValue(account.imperonator != nil ? "yes" : "no", forKey: "is_impersonating")
        CrashlyticsEventTrackingService.setCustomValue(account.imperonator, forKey: "impersonator")
    }

    static func updateUser(userId: String) {
        Crashlytics.crashlytics().setUserID(userId)
    }

    static func setCustomValue(_ value: String?, forKey key: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }

    func send(event _: TrackedEvent) {}

    var enabled: Bool = true
}
