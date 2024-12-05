//
//  ImageryNotificationPayload.swift
//  Openfield
//
//  Created by Daniel Kochavi on 14/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

struct ImageryNotificationPayload: Decodable, IsPayload {
    let fields_ids: [Int]
    let date: Date
}
