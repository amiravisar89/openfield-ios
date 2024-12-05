//
//  AnalyticsMeasure.swift
//  Openfield
//
//  Created by Daniel Kochavi on 31/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

class AnalyticsMeasure {
    var measurements: [String: DispatchTime]

    static let sharedInstance = AnalyticsMeasure()
    private init() {
        measurements = [:]
    }

    func start(label: String) {
        measurements[label] = DispatchTime.now()
        log.verbose("Start measure time for: \(label)")
    }

    func clear(label: String) {
        measurements.removeValue(forKey: label)
    }

    /**
      Returns the elapsed time (in ms) since calling start(label)
     */
    func elapsedTime(label: String) -> UInt64? {
        guard let start = measurements[label] else { return nil }
        let end = DispatchTime.now()
        let elapsedTime = (end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000 // in ms
        log.verbose("Finish measure time for: \(label) with elapsed time: \(elapsedTime)")
        measurements.removeValue(forKey: label)
        return elapsedTime
    }
}
