//
//  DateProvider.swift
//  Openfield
//
//  Created by amir avisar on 12/10/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import RxSwift
import SwiftDate

class DateProvider {
    let disposeBag = DisposeBag()
    let languageService: LanguageService
    var currentLanguage: LanguageData = LanguageService.defaultLanguage

    init(languageService: LanguageService) {
        self.languageService = languageService
        languageService.currentLanguage.bind { self.currentLanguage = $0 }.disposed(by: disposeBag)
    }

    func format(date: Date, dateStyle: DateFormatter.Style = .none, timeStyle: DateFormatter.Style = .none, timeZone: TimeZone? = nil, locale: Locale? = nil, format: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.locale = locale ?? currentLanguage.locale
        dateFormatter.timeZone = timeZone ?? TimeZone.current
        if let dateFormat = format { dateFormatter.dateFormat = dateFormat }
        return dateFormatter.string(from: date)
    }

    func format(date: Date, region: Region = Region.local, format: DateFormat) -> String {
        return date.convertTo(region: region).toFormat(format.description)
    }

    func dayNumber(date: Date, region: Region = Region.local) -> Int {
        return date.convertTo(region: region).day
    }

    func monthName(date: Date, region: Region = Region.local) -> String {
        return date.convertTo(region: region).toFormat("MMMM", locale: currentLanguage.locale)
    }

    func weekDayName(date: Date, region: Region = Region.local) -> String {
        return date.convertTo(region: region).toFormat("EEEE", locale: currentLanguage.locale)
    }

    func timeAgoSince(_ date: Date) -> String {
        let now = Date()

        let daysDiff = date.getInterval(toDate: now, component: .day)
        let hoursDiff = date.getInterval(toDate: now, component: .hour)
        let minutesDiff = date.getInterval(toDate: now, component: .minute)

        if hoursDiff >= 364 * 24 + 12 {
            return R.string.localizable.timeAgoYears_MOBILE(Int(round(Double(daysDiff) / 365.0)))
        } else if hoursDiff >= 29 * 24 + 12 {
            return R.string.localizable.timeAgoMonths_MOBILE(Int(round(Double(daysDiff) / 30)))
        } else if hoursDiff >= 6 * 24 + 12 {
            return R.string.localizable.timeAgoWeeks_MOBILE(Int(round(Double(daysDiff) / 7)))
        } else if hoursDiff >= 12 {
            return R.string.localizable.timeAgoDays_MOBILE(Int(round(Double(hoursDiff) / 24)))
        } else if minutesDiff > 30 {
            return R.string.localizable.timeAgoHours_MOBILE(Int(round(Double(minutesDiff) / 60)))
        } else {
            return R.string.localizable.timeAgoNow()
        }
    }
    
    func daysTimeAgoSince(_ date: Date?) -> String? {
        guard let date else {
            return nil
        }
        if date.isToday {
            return R.string.localizable.today()
        } else if date.isYesterday {
            return R.string.localizable.yesterday()
        } else {
            return format(date: date, region: Region.local, format: .short)
        }
    }
}

enum DateFormat: CustomStringConvertible {
    case short
    case shortNoYear
    case shortNoDay
    case full
    case fullMonthYear
    case fullHourMinutes
    case shortDayName
    case shortHourTimeZone

    var description: String {
        switch self {
        case .short: return R.string.localizable.dateShort()
        case .shortNoYear: return R.string.localizable.dateShortNoYear()
        case .shortNoDay: return R.string.localizable.dateShortNoDay()
        case .full: return R.string.localizable.dateFull()
        case .fullMonthYear: return R.string.localizable.dateFullMonthYear()
        case .fullHourMinutes: return R.string.localizable.dateFullHourMinutes()
        case .shortDayName: return R.string.localizable.dateShortDayName()
        case .shortHourTimeZone: return R.string.localizable.dateShortHourTimeZone()
        }
    }
}
