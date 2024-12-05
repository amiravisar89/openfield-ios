//
//  LocalizeString.swift
//  Openfield
//
//  Created by amir avisar on 17/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

struct LocalizeString: Decodable {
    let token: String?
    let params: [String: Any]?

    private enum CodingKeys: String, CodingKey {
        case token, params
    }

    init(token: String?, params: [String: String]?) {
        self.token = token
        self.params = params
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            token = try container.decode(String.self, forKey: .token)
        } catch DecodingError.keyNotFound {
            token = nil
        }

        do {
            params = try container.decode([String: Int].self, forKey: .params)
        } catch DecodingError.typeMismatch {
            params = try container.decode([String: String].self, forKey: .params)
        } catch DecodingError.keyNotFound {
            params = nil
        }
    }
}
