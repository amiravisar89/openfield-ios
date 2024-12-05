//
//  FieldLastReadServerModel.swift
//  Openfield
//
//  Created by Yoni Luz on 25/12/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation
import Firebase

struct FieldLastReadServerModel: Decodable {
    let ts_read: Timestamp?
    let ts_first_read: Timestamp?
    var fieldId: String? = nil
}
