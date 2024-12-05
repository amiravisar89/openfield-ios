//
//  RemoteConfigError.swift
//  Openfield
//
//  Created by amir avisar on 08/09/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

struct RemoteConfigError: Hashable, Decodable, Error {
    var statusCode: Int?
    var detail: String?

    enum CodingKeys: String, CodingKey {
        case detail
    }
}
