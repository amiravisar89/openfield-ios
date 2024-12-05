//
//  URL+Query.swift
//  Openfield
//
//  Created by amir avisar on 06/09/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value
        }
    }

    static func queryURL(domain: String, params: [(key: String, value: String)]) -> URL? {
        let queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        guard let urlComps = URLComponents(string: "http://\(domain)/") else { return nil }
        var mutatedUrlComps = urlComps
        mutatedUrlComps.queryItems = queryItems
        return mutatedUrlComps.url
    }
}
