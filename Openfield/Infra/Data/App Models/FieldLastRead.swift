//
//  FieldLastRead.swift
//  Openfield
//
//  Created by Yoni Luz on 25/12/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation

struct FieldLastRead: Hashable, Equatable {
    let tsRead: Date?
    let tsFirstRead: Date?
}
