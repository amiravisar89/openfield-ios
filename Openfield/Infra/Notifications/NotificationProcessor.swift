//
//  NotificationProcessor.swift
//  Openfield
//
//  Created by Daniel Kochavi on 03/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationProcessor {
    private let jsonDecoder: JSONDecoder // TODO-Daniel: Inject this
    private let defaultBaseUrlComponents = DeepLinkingSettings.deeplinkBaseUrlComponents

    init() {
        jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601DateOnly)
    }

    public func processNotification(userInfo: [AnyHashable: Any]) -> (url: URL?, payload: IsPayload?) {
        guard let payload = parseNotificationPayload(userInfo: userInfo)
        else { return (nil, nil) }

        switch payload {
        case let userReportPayload as UserReportNotificationPayload:
            if userReportPayload.report_id != nil {
                let reportId = userReportPayload.report_id
                var components = defaultBaseUrlComponents
                components.path = "/r/" + String(reportId!)
                return (components.url!, payload)
            } else {
                return (defaultBaseUrlComponents.url, payload)
            }
        case let insightsPayload as InsightNotificationPayload:
            if insightsPayload.insights.count == 1 {
                let insightUID = insightsPayload.insights[0].uid
                var components = defaultBaseUrlComponents
                components.path = "/i/\(insightUID)"
                return (components.url!, payload)
            } else {
                return (defaultBaseUrlComponents.url, payload)
            }
        case let imageryPayload as ImageryNotificationPayload:
            if let date = imageryPayload.date.dateTruncated(from: .hour)?.toISO() {
                var components = defaultBaseUrlComponents
                components.path = "/imagery/\(date)"
                return (components.url!, payload)
            }
            return (defaultBaseUrlComponents.url, payload)
        case _ as ReminderNotificationPayload:
            return (defaultBaseUrlComponents.url, payload)
        default:
            return (nil, nil)
        }
    }

    private func parseNotificationPayload(userInfo: [AnyHashable: Any]) -> IsPayload? {
        guard let typeString = userInfo["type"] as? String,
              let type = NotificationPayloadType(rawValue: typeString),
              let payload: String = userInfo["payload"] as? String,
              let data = payload.data(using: .utf8)
        else {
            log.error("Error parsing the following push notification: \(userInfo)")
            return nil
        }
        switch type {
        case .report:
            guard let userReportPayload = try? jsonDecoder.decode(UserReportNotificationPayload.self, from: data) else {
              log.error("Error parsing payload type: \(type)")
                return nil
            }
            return userReportPayload
        case .insights, .insight_highlight, .detection_insight:
            guard let insightsPayload = try? jsonDecoder.decode(InsightNotificationPayload.self, from: data) else {
                log.error("Error parsing payload type: \(type)")
                return nil
            }
            return insightsPayload
        case .imagery:
            guard let imageryPayload = try? jsonDecoder.decode(ImageryNotificationPayload.self, from: data) else {
                log.error("Error parsing payload type: \(type)")
                return nil
            }
            return imageryPayload
        case .insight_reminder:
            return ReminderNotificationPayload()
        }
    }
}
