//
//  FieldListSorting.swift
//  Openfield
//
//  Created by Amitai Efrati on 01/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

class FieldListSorting {
    let sortingName: String
    let type: FieldListSortingType

    init(sortingName: String, type: FieldListSortingType) {
        self.sortingName = sortingName
        self.type = type
    }
}
