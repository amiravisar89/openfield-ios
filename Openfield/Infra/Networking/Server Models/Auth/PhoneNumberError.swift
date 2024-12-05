//
//  PhoneNumberError.swift
//  Openfield
//
//  Created by amir avisar on 20/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation

struct PhoneNumberError: Hashable, Decodable, Error {
    var statusCode: Int?
    var detail: String?

    enum CodingKeys: String, CodingKey {
        case detail
    }
}
