//
//  CaseIterable+Addition.swift
//  Openfield
//
//  Created by Daniel Kochavi on 26/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

extension CaseIterable where Self: Equatable {
    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}
