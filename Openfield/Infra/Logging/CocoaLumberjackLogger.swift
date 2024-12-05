//
//  CocoaLumberjackLogger.swift
//  Openfield
//
//  Created by amir avisar on 15/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import CocoaLumberjack
import Foundation

class CocoaLumberjackLogger: AppLogger {
    let lumberjackLogger: DDTTYLogger?

    init() {
        // TTY = Xcode console
        self.lumberjackLogger = DDTTYLogger.sharedInstance
        guard let lumberjackLogger = lumberjackLogger else { return }
        lumberjackLogger.do {
            $0.logFormatter = LogFormatter()
            $0.colorsEnabled = false /* true */ // Note: doesn't work in Xcode 8
            $0.setForegroundColor(DDMakeColor(30, 121, 214), backgroundColor: nil, for: .info)
            $0.setForegroundColor(DDMakeColor(50, 143, 72), backgroundColor: nil, for: .debug)
            DDLog.add($0)
        }

        // File logger
        DDFileLogger().do {
            $0.rollingFrequency = TimeInterval(60 * 60 * 24) // 24 hours
            $0.logFileManager.maximumNumberOfLogFiles = 7
            DDLog.add($0)
        }
    }

    func error(_: Any..., message: String, file: StaticString, function: StaticString, line: UInt) {
        DDLogError(message, file: file, function: function, line: line)
    }

    func warning(_: Any..., message: String, file: StaticString, function: StaticString, line: UInt) {
        DDLogWarn(message, file: file, function: function, line: line)
    }

    func info(_: Any..., message: String, file: StaticString, function: StaticString, line: UInt) {
        DDLogInfo(message, file: file, function: function, line: line)
    }

    func debug(_: Any..., message: String, file: StaticString, function: StaticString, line: UInt) {
        DDLogDebug(message, file: file, function: function, line: line)
    }

    func verbose(_: Any..., message: String, file: StaticString, function: StaticString, line: UInt) {
        DDLogVerbose(message, file: file, function: function, line: line)
    }
}

private class LogFormatter: NSObject, DDLogFormatter {
    static let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }

    public func format(message logMessage: DDLogMessage) -> String? {
        let timestamp = LogFormatter.dateFormatter.string(from: logMessage.timestamp)
        let level = logMessage.flag.level
        let filename = logMessage.fileName
        let function = logMessage.function ?? ""
        let line = logMessage.line
        let message = logMessage.message.components(separatedBy: "\n").joined(separator: "\n    ")
        return "\(timestamp) \(level) \(filename).\(function):\(line) - \(message)"
    }

    private func formattedDate(from date: Date) -> String {
        return LogFormatter.dateFormatter.string(from: date)
    }
}

public extension DDLogFlag {
    var level: String {
        switch self {
        case DDLogFlag.error: return "❤️ 📜 ERROR"
        case DDLogFlag.warning: return "💛 📜 WARNING"
        case DDLogFlag.info: return "💙 📜 INFO"
        case DDLogFlag.debug: return "💚 📜 DEBUG"
        case DDLogFlag.verbose: return "💜 📜 VERBOSE"
        default: return "☠️ UNKNOWN"
        }
    }
}
