//
//  DeeplinkSettings.swift
//  Openfield
//
//  Created by Daniel Kochavi on 01/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

enum DeepLinkingSettings {
    private static let shareUniversalLinkHost: String = ConfigEnvironment.valueFor(key: .shareHostLink)

    private static let universalLinkScheme: String = ConfigEnvironment.valueFor(key: .universalLinkScheme)
    private static let universalLinkHosts: [String] = ConfigEnvironment.listValueFor(key: .universalLinkHosts)

    private static let internalDeepLinkScheme = "valleyinsights"
    private static let internalDeepLinkHost = "prospera.ag"

    static let schemes = [universalLinkScheme, internalDeepLinkScheme]
    static let hosts = universalLinkHosts + [internalDeepLinkHost]

    static var deeplinkBaseUrlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = internalDeepLinkScheme
        components.host = internalDeepLinkHost
        return components
    }

    static var universalLinkShareBaseUrlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = universalLinkScheme
        components.host = shareUniversalLinkHost
        return components
    }
}
