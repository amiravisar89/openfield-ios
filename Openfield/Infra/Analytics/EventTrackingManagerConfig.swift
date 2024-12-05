//
//  EventTrackingManagerConfig.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

struct EventTrackingManagerConfig {
    let analyticsServices: [EventTrackingAnalyticsService]
    let enrichments: [EventTrackingEnrichment]

    init(analyticsServices: [EventTrackingAnalyticsService], enrichments: [EventTrackingEnrichment]) {
        self.analyticsServices = analyticsServices
        self.enrichments = enrichments
    }

    init(analyticsServices: [EventTrackingAnalyticsService]) {
        self.analyticsServices = analyticsServices
        enrichments = []
    }

    init(enrichments: [EventTrackingEnrichment]) {
        analyticsServices = []
        self.enrichments = enrichments
    }
}
