//
//  Generic.swift
//  Openfield
//
//  Created by amir avisar on 02/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation

func createList<T>(count: Int, creator: () -> T) -> [T] {
    var result: [T] = []
    for _ in 1 ... count {
        result.append(creator())
    }
    return result
}

func randomElement<T>(list: [T]) -> T {
    return list.randomElement()!
}
