//
//  EventTracker.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

enum EventTracker {
    static func track(event: TrackedEvent) {
        NotificationCenter.default.post(name: EventTrackingManager.notificationName, object: event)
    }
}
