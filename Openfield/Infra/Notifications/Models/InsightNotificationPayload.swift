//
//  InsightNotificationPayload.swift
//  Openfield
//
//  Created by Daniel Kochavi on 14/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

struct InsightNotificationPayload: Decodable, IsPayload {
    let insights: [SingleInsightItem]
}

struct SingleInsightItem: Decodable {
    let uid: String
}
