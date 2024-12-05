//
//  FirebaseEventTrackingService.swift
//  Openfield
//
//  Created by Daniel Kochavi on 09/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import FirebaseAnalytics
import SwiftyUserDefaults

enum UserProperties: String {
    case language
    case deviceLanguage = "device_language"
    case isImpersonating = "is_impersonating"
    case impersonator
}

class FirebaseEventTrackingAnalyticsService: EventTrackingAnalyticsService {
    init() {
        setAnalyticsAccount(account: EventTrackingAnalyticsServiceAccount(id: "\(Defaults.extUser?.id ?? -1)",
                                                                          imperonator:  Defaults.impersonatorId.map { String($0) }))
    }

    func setAnalyticsAccount(account: EventTrackingAnalyticsServiceAccount) {
        FirebaseEventTrackingAnalyticsService.updateUser(userId: account.id)
        FirebaseEventTrackingAnalyticsService.setUserProperty(propertyName: .isImpersonating, value: account.imperonator != nil ? "yes" : "no")
        FirebaseEventTrackingAnalyticsService.setUserProperty(propertyName: .impersonator, value: account.imperonator)
    }

    static func updateUser(userId: String) {
        Analytics.setUserID(userId)
    }

    static func setUserProperty(propertyName: UserProperties, value: String?) {
        Analytics.setUserProperty(value, forName: propertyName.rawValue)
    }

    func send(event: TrackedEvent) {
        Analytics.logEvent(event.getEventName(), parameters: event.getParameters())
    }

    var enabled: Bool = true
}
