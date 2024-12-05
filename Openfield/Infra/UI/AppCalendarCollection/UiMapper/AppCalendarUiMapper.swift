//
//  AppCalendarUiMapper.swift
//  Openfield
//
//  Created by amir avisar on 17/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

class AppCalendarUiMapper {
    
    private var dateProvider: DateProvider
    
    init(dateProvider: DateProvider) {
        self.dateProvider = dateProvider
    }
    
    func map(elements: [AppCallendarElement]) -> [AppCallendarUIElement] {
        return elements.map { element in
            let dayName = dateProvider.weekDayName(date: element.date.date, region: element.date.region).prefix(3).uppercased()
            let dayNumber = "\(dateProvider.dayNumber(date: element.date.date, region: element.date.region))"
            let monthName = dateProvider.monthName(date: element.date.date, region: element.date.region).prefix(3).uppercased()
            return AppCallendarUIElement(selected: element.selected, enabled: element.enabled, monthName: monthName, dayNumber: dayNumber, dayName: dayName)
        }
    }
    
}
