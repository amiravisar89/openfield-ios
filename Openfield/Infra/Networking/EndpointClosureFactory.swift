//
//  EndpointClosureFactory.swift
//  Openfield
//
//  Created by Daniel Kochavi on 01/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Moya

enum EndpointClosureFactory {
    private static let appName = "valley-insights:ios"
    private static let appVersion = ConfigEnvironment.appVersion

    static func endpointClosure<T: TargetType>() -> ((_ target: T) -> Endpoint) {
        return {
            (target: T) -> Endpoint in

            let endpoint: Endpoint = MoyaProvider<T>.defaultEndpointMapping(for: target)
                .adding(newHTTPHeaderFields: [
                    "PRS-APP-NAME": appName,
                    "PRS-APP-VERSION": appVersion,
                ])
            return endpoint
        }
    }
}
