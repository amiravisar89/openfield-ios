//
//  DatadogLogger.swift
//  Openfield
//
//  Created by amir avisar on 15/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import DatadogLogs
import DatadogCore
import Foundation
import SwiftyUserDefaults

class DataDogLogger: AppLogger {
    // MARK: Initialize

    let dataDogLogger: LoggerProtocol

    init() {
      Datadog.initialize(
        with: Datadog.Configuration(
          clientToken: ConfigEnvironment.valueFor(key: .dataDogClientToken),
          env: ConfigEnvironment.scheme().rawValue,
          service: ConfigEnvironment.valueFor(key: .dataDogService)
        ),
        trackingConsent: .granted
      )

      Datadog.verbosityLevel = ConfigEnvironment.isDebugMode ? .debug : nil
      
      Logs.enable()
      
      dataDogLogger = Logger.create(
        with: Logger.Configuration(
          service: ConfigEnvironment.valueFor(key: .dataDogService),
          networkInfoEnabled: true,
          remoteSampleRate: ConfigEnvironment.isDebugMode ? 0 : 100,
          remoteLogThreshold: .info
        )
      )
    }
    
    func error(_: Any..., message: String, file _: StaticString, function: StaticString, line: UInt) {
      let attributes = getDataDogAttributes(function: function, line: line)
      dataDogLogger.error(message, attributes: attributes)
    }
    
    func warning(_: Any..., message: String, file _: StaticString, function: StaticString, line: UInt) {
      let attributes = getDataDogAttributes(function: function, line: line)
      dataDogLogger.warn(message, attributes: attributes)
    }
    
    func info(_: Any..., message: String, file _: StaticString, function: StaticString, line: UInt) {
      let attributes = getDataDogAttributes(function: function, line: line)
      dataDogLogger.info(message, attributes: attributes)
    }
    
    func debug(_: Any..., message: String, file _: StaticString, function: StaticString, line: UInt) {
      let attributes = getDataDogAttributes(function: function, line: line)
      dataDogLogger.debug(message, attributes: attributes)
    }
    
    func verbose(_: Any..., message _: String, file _: StaticString, function _: StaticString, line _: UInt) {}
    
    func getDataDogAttributes(function: StaticString = #function,
                              line: UInt = #line) -> [String: Encodable]
    {
      return [DataDogAttributeKeys.user_id.rawValue: Defaults.userId,
              DataDogAttributeKeys.line.rawValue: String(describing: line),
              DataDogAttributeKeys.function.rawValue: String(describing: function),
              DataDogAttributeKeys.version.rawValue: ConfigEnvironment.appVersion]
    }
}
