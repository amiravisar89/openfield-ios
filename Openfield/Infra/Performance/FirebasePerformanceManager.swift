//
//  FirebasePerformanceManager.swift
//  Openfield
//
//  Created by Amitai Efrati on 04/03/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebasePerformance

class PerformanceManager {
    static let shared = PerformanceManager()
    private var traces = [String: Trace]()
    private let queue = DispatchQueue(label: "performanceManager")
    
    private init() {}
    
    func startTrace(origin: NavigationOrigin, target: NavigationOrigin)  {
        queue.async { [weak self] in
            guard let self = self else { return }
            let mapKey = getMapKey(target: target)
            let traceName = "\(origin.rawValue)_to_\(target.rawValue)"
            let trace = Performance.startTrace(name: traceName)
            traces[mapKey] = trace
        }
    }
    
    func startTrace(for traceName: String) {
        queue.async { [weak self] in
            guard let self = self else { return }
            let trace = Performance.startTrace(name: traceName)
            traces[traceName] = trace
        }
    }
    
    func stopTrace(for target: NavigationOrigin) {
        let traceName = getMapKey(target: target)
        stopTrace(for: traceName)
    }
    
    func stopTrace(for traceName: String) {
        queue.async { [weak self] in
            guard let self = self else { return }
            if let trace = traces[traceName] {
                trace.stop()
                traces.removeValue(forKey: traceName)
            }
        }
    }
    
    private func getMapKey(target: NavigationOrigin) -> String {
        let mapKey: String
        switch target {
        case .irrigation_insight, .location_insight:
            mapKey = NavigationOrigin.insight.rawValue
        default:
            mapKey = target.rawValue
        }
        return mapKey
    }
}
