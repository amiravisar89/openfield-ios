//
//  AnalyticsEventFactory.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import FirebaseAnalytics

enum AnalyticsEventFactory {
    static func buildClickEvent(_ category: String, _ itemId: String) -> AnalyticsEvent {
        let event = AnalyticsEvent(eventName: Events.buttonClick.rawValue)
        event.setParameter(key: EventParamKey.itemId, value: itemId)
        event.setParameter(key: EventParamKey.category, value: category)
        return event
    }

    static func buildClickEvent(_ category: String, _ itemId: String, _ parameters: [String: String]) -> AnalyticsEvent {
        let event = buildClickEvent(category, itemId)
        event.addParameters(parameters: parameters)
        return event
    }

    static func buildDialogEvent(_ category: String, _ itemId: String, _ shown: Bool) -> AnalyticsEvent {
        let event = AnalyticsEvent(eventName: shown ? Events.dialogShown.rawValue : Events.dialogDismiss.rawValue)
        event.setParameter(key: EventParamKey.itemId, value: itemId)
        event.setParameter(key: EventParamKey.category, value: category)
        return event
    }

    static func buildDialogEvent(_ category: String, _ itemId: String, _ shown: Bool, _ parameters: [String: String]) -> AnalyticsEvent {
        let event = buildDialogEvent(category, itemId, shown)
        event.addParameters(parameters: parameters)
        return event
    }

    static func buildErrorEvent(_ category: String, _ error: String) -> AnalyticsEvent {
        let event = AnalyticsEvent(eventName: Events.errorShown.rawValue)
        event.setParameter(key: EventParamKey.error, value: error)
        event.setParameter(key: EventParamKey.category, value: category)
        return event
    }

    static func buildErrorEvent(_ category: String, _ error: String, _ parameters: [String: String]) -> AnalyticsEvent {
        let event = buildErrorEvent(category, error)
        event.addParameters(parameters: parameters)
        return event
    }

    static func buildEvent(_ category: String, _ event: Events) -> AnalyticsEvent {
        let event = AnalyticsEvent(eventName: event.rawValue)
        event.setParameter(key: EventParamKey.category, value: category)
        return event
    }

    static func buildEvent(_ category: String, _ event: Events, _ parameters: [String: String]) -> AnalyticsEvent {
        let event = buildEvent(category, event)
        event.addParameters(parameters: parameters)
        return event
    }
}
