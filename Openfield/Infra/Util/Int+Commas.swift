//
//  Int+Commas.swift
//  Openfield
//
//  Created by dave bitton on 08/03/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
