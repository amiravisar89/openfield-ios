//
//  AppTime.swift
//  Openfield
//
//  Created by amir avisar on 25/05/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

enum AppTime {
    static var calendar: Calendar {
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone.current
        return calendar
    }

    static let weekStartDay = DaysOfWeek.MONDAY.rawValue

    enum DaysOfWeek: Int {
        case SUNDAY = 1
        case MONDAY
        case TUESDAY
        case WEDNESDAY
        case THURSDAY
        case FRIDAY
        case SATURDAY
    }
}
