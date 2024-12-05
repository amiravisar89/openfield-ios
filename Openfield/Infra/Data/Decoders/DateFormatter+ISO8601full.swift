//
//  DateFormatter+ISO8601full.swift
//  Openfield
//
//  Created by Daniel Kochavi on 15/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import Resolver
import RxSwift

extension DateFormatter {
    static let iso8601Mid: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let iso8601DateOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static func beautifullStringFormatter(format: String, timeZoneIdentifier: String? = nil, local: Locale? = nil) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if timeZoneIdentifier != nil {
            let timeZoneIdentifierUW = timeZoneIdentifier!
            dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifierUW)
        }

        if local == nil {
            dateFormatter.locale = Locale.current
        } else {
            dateFormatter.locale = local
        }
        return dateFormatter
    }
}
