//
//  LoginError.swift
//  Openfield
//
//  Created by Itay Kaplan on 15/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

struct LoginError: Hashable, Decodable, Error {
    var statusCode: Int?
    var detail: String?

    enum CodingKeys: String, CodingKey {
        case detail
    }
}
