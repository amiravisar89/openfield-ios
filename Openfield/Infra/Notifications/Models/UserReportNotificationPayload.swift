//
//  UserReportNotificationPayload.swift
//  Openfield
//
//  Created by amir avisar on 01/09/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

struct UserReportNotificationPayload: Decodable, IsPayload {
    let report_id: Int?
}
