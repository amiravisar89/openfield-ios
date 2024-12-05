//
//  ConfigEnvironment.swift
//  Openfield
//
//  Created by Daniel Kochavi on 18/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation

public enum ConfigEnvironment {
    // MARK: - Keys

    enum Keys {
        enum Plist: String {
            case useMock = "USE_MOCK"
            case baseUrl = "BASE_URL"
            case smartLookAPIKey = "SMARTLOOK_API_KEY"
            case lokaliseProjectId = "LOKALISE_PROJECT_ID"
            case lokaliseToken = "LOKALISE_TOKEN"
            case universalLinkScheme = "SCHEME"
            case universalLinkHosts = "HOSTS"
            case shareHostLink = "SHARE_HOST"
            case subscriptionURL = "SUBSCRIPTION_URL"
            case accountURL = "ACCOUNT_URL"
            case useAccesability = "USE_ACCSESSABILITY"
            case dataDogClientToken = "DATA_DOG_CLIENT_TOKEN"
            case dataDogService = "DATADOG_SERVICE"
            case appDomain = "APP_DOMAIN"
            case featureFlagMobileSdkKey = "FEATURE_FLAG_MOBILE_SDK_KEY"
        }
    }

    // MARK: - Plist

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    static func valueFor<T>(key: Keys.Plist) -> T {
        guard let value = ConfigEnvironment.infoDictionary[key.rawValue] as? T else {
            fatalError("\(key) not set in plist for this environment")
        }
        return value
    }

    static func boolValueFor(key: Keys.Plist) -> Bool {
        let value: String = valueFor(key: key)
        return value == "YES"
    }

    static func listValueFor(key: Keys.Plist) -> [String] {
        let value: String = valueFor(key: key)
        return value.components(separatedBy: ",")
    }

    // MARK: - Dynamic

    static func scheme() -> Schemes {
        let schemeString = Bundle.main.infoDictionary!["CURRENT_SCHEME_NAME"] as! String
        guard let scheme = Schemes(rawValue: schemeString) else {return .none}
        return scheme
    }

    static let appName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String

    static var appVersion: String {
        let bundleVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "0"
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "0.0"
        return "\(appVersion).\(bundleVersion)"
    }

    static var appBundleVersion: Int {
        let bundleVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "0"
        return Int(bundleVersion) ?? 0
    }

    static var isDebugMode: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
    
    enum Schemes : String {
        case QA
        case Release
        case Staging
        case AnalyticsDebug = "Analytics-debug"
        case Mock
        case none
    }
}
