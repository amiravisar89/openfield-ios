//
//  NotificationPayloadType.swift
//  Openfield
//
//  Created by Daniel Kochavi on 14/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

enum NotificationPayloadType: String, Decodable {
    case report
    case insights
    case imagery
    case insight_reminder
    case insight_highlight
    case detection_insight
}
