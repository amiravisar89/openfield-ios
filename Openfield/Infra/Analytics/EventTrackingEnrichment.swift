//
//  EventTrackingEnrichment.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

protocol EventTrackingEnrichment {
    func enrich(event: TrackedEvent) -> TrackedEvent
}
