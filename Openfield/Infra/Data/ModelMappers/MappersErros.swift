//
//  MappersErros.swift
//  Openfield
//
//  Created by Itay Kaplan on 29/12/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

struct ParsingError: Error {
    let description: String

    init(description: String) {
        self.description = description
    }
}
