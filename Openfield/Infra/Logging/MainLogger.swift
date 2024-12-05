//
//  MainLogger.swift
//  Openfield
//
//  Created by Daniel Kochavi on 14/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Resolver
import SwiftyUserDefaults

/// A shared instance of `MainLogger`.
let log: MainLogger = Resolver.resolve()

final class MainLogger {
    // MARK: Initialize

    let loggers: [AppLogger]

    init(loggers: [AppLogger]) {
        setenv("XcodeColors", "YES", 0)
        self.loggers = loggers
    }

    // MARK: Logging

    func error(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        loggers.forEach { $0.error(items, message: message, file: file, function: function, line: line) }
    }

    func warning(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        loggers.forEach { $0.warning(items, message: message, file: file, function: function, line: line) }
    }

    func info(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        loggers.forEach { $0.info(items, message: message, file: file, function: function, line: line) }
    }

    func debug(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        loggers.forEach { $0.debug(items, message: message, file: file, function: function, line: line) }
    }

    func verbose(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        loggers.forEach { $0.verbose(items, message: message, file: file, function: function, line: line) }
    }

    // MARK: Utils

    private func message(from items: [Any]) -> String {
        return items
            .map { String(describing: $0) }
            .joined(separator: " ")
    }
}

enum DataDogAttributeKeys: String {
    case user_id
    case line
    case function
    case version
}
