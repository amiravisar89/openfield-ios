//
//  EventTrackingService.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

protocol EventTrackingAnalyticsService {
    func send(event: TrackedEvent)

    func setAnalyticsAccount(account: EventTrackingAnalyticsServiceAccount)

    var enabled: Bool { get }
}

struct EventTrackingAnalyticsServiceAccount {
    let id: String
    let imperonator: String?
}
