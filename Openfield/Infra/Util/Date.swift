//
//  Date.swift
//  Openfield
//
//  Created by dave bitton on 13/04/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import SwiftDate

extension Date {
    func isTheSameWeek(as date: Date) -> Bool {
        return weekInYearNum == date.weekInYearNum &&
            year == date.year
    }

    func isTheSameDay(as date: Date) -> Bool {
        return day == date.day &&
            month == date.month &&
            year == date.year
    }
    
    func minus(component: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(byAdding: component, value: -value, to: date)
    }

    var weekInYearNum: Int {
        return AppTime.calendar.component(.weekOfYear, from: self)
    }

    var startOfWeek: Date {
        return AppTime.calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date ?? self
    }

    var endOfWeek: Date {
        return startOfWeek + 6.days
    }
    
    var isToday: Bool {
        return self.compare(.isToday)
    }
    
    var isYesterday: Bool {
        return self.compare(.isYesterday)
    }
    
    var startOfDay: Date {
         Calendar.current.startOfDay(for: self)
    }
    
    
}
