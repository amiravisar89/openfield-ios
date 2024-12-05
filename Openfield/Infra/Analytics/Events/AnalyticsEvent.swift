//
//  AnalyticsEvent.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

class AnalyticsEvent: TrackedEvent {
    private let eventName: String
    private var parameters: [String: String] = [:]

    init(eventName: String) {
        self.eventName = eventName
    }

    func getEventName() -> String {
        eventName
    }

    func getType() -> EventType {
        .analytic
    }

    func getParameters() -> [String: String] {
        parameters
    }

    func setParameter(key: String, value: String) {
        parameters[key] = value
    }

    func addParameters(parameters: [String: String]) {
        for (key, value) in parameters {
            self.parameters[key] = value
        }
    }
}
