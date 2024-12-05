//
//  EventTrackingManager.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

class EventTrackingManager {
    static let notificationName = NSNotification.Name("EventTrackingManagerNotification")

    static let sharedInstance = EventTrackingManager()

    private var config: EventTrackingManagerConfig?

    private var observer: NSObjectProtocol?

    private init() {}

    func configure(config: EventTrackingManagerConfig) {
        self.config = config

        observer = NotificationCenter.default.addObserver(
            forName: EventTrackingManager.notificationName,
            object: nil,
            queue: nil,
            using: onEvent
        )
    }

    deinit {
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
    }

    func setAnalyticsAccount(account: EventTrackingAnalyticsServiceAccount) {
        enabledServices()?.forEach {
            $0.setAnalyticsAccount(account: account)
        }
    }

    private func onEvent(notification: Notification) {
        if var event = notification.object as? TrackedEvent {
            DispatchQueue.main.async {
                if event.getParameters().isEmpty {
                    log.verbose("Tracking event: \(event.getEventName())")
                } else {
                    var params: String = ""
                    for (key, value) in event.getParameters().sorted(by: { $0.0.lowercased() < $1.0.lowercased() }) {
                        params += "\(key): \(value), "
                    }
                    log.verbose("Tracking event: \(event.getEventName()), with params: [\(params)]")
                }
                self.config?.enrichments.forEach {
                    event = $0.enrich(event: event)
                }
                self.enabledServices()?.forEach {
                    $0.send(event: event)
                }
            }
        }
    }

    private func enabledServices() -> [EventTrackingAnalyticsService]? {
        return config?.analyticsServices.filter { $0.enabled }
    }
}
