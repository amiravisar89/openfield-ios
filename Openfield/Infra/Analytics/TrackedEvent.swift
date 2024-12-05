//
//  TrackedEvent.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

protocol TrackedEvent {
    func getEventName() -> String
    func getType() -> EventType
    func getParameters() -> [String: String]
    func setParameter(key: String, value: String)
    func addParameters(parameters: [String: String])
}
