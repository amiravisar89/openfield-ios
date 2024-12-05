//
//  AppLogger.swift
//  Openfield
//
//  Created by amir avisar on 15/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation

protocol AppLogger {
    func error(_ items: Any..., message: String, file: StaticString, function: StaticString, line: UInt)
    func warning(_ items: Any..., message: String, file: StaticString, function: StaticString, line: UInt)
    func info(_ items: Any..., message: String, file: StaticString, function: StaticString, line: UInt)
    func debug(_ items: Any..., message: String, file: StaticString, function: StaticString, line: UInt)
    func verbose(_ items: Any..., message: String, file: StaticString, function: StaticString, line: UInt)
}
