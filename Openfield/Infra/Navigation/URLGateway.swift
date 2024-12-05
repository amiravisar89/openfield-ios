//
//  URLGateway.swift
//  Openfield
//
//  Created by Daniel Kochavi on 01/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

class URLGateway {
    public func handleQueryItems(params: [String: String], pathComponenet: String, origin: NavigationOrigin) -> Intent? {
        switch pathComponenet {
        case "i":
            guard let insightUID = params["uid"] else {
                return nil
            }
            return .insight(insightUID: insightUID, origin: origin)
        default:
            return nil
        }
    }

    public func handleDeeplink(_ url: URL, analyticsOrigin: NavigationOrigin) -> Intent? {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let pathComponents = components.url?.pathComponents,
            let scheme = components.scheme,
            let host = components.host,
            DeepLinkingSettings.hosts.contains(host) else { return nil }

        switch pathComponents.count {
        case 5:
            switch (pathComponents[1], pathComponents[2], pathComponents[3], pathComponents[4]) {
            case let ("u", _, "i", insightUID): // /u/*/i/{UID}
                let trimmedInsightUID = insightUID.trimmingCharacters(in: ["-"])
                return .insight(insightUID: trimmedInsightUID, origin: analyticsOrigin)
            default:
                return nil
            }
        case 4:
            switch (pathComponents[1], pathComponents[2], pathComponents[3]) {
            case let (_, "i", insightUID): // /*/i/{UID}
                let trimmedInsightUID = insightUID.trimmingCharacters(in: ["-"])
                return .insight(insightUID: trimmedInsightUID, origin: analyticsOrigin)
            default:
                return nil
            }
        case 3:
            switch (pathComponents[1], pathComponents[2]) {
            case let ("i", insightUID): // /i/{UID}
                return .insight(insightUID: insightUID, origin: analyticsOrigin)
            case let ("insight", insightUID): // /insight/{UID}
                return .insight(insightUID: insightUID, origin: analyticsOrigin)
            case let ("imagery", dateString): // /imagery/{DATE}
                if let date: Date = dateString.toDate()?.date {
                    return .imagery(date: date, origin: analyticsOrigin)
                } else {
                    log.warning("Error parsing date: \(dateString)")
                    return nil
                }

            default:
                return nil
            }

        case 2:
            switch (pathComponents[0], pathComponents[1]) {
            case ("/", "r"): // /r/?id={UID}
                guard let params = url.queryParameters else {
                    return nil
                }
                return handleQueryItems(params: params, pathComponenet: "r", origin: analyticsOrigin)
            case ("/", "i"): // /i
                guard let params = url.queryParameters else {
                    return nil
                }
                return handleQueryItems(params: params, pathComponenet: "i", origin: analyticsOrigin)
            default:
                return nil
            }
        case 0:
            return .home
        default:
            return nil
        }
    }
}
