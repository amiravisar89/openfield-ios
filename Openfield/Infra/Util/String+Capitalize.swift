//
//  String+Capitalize.swift
//  Openfield
//
//  Created by amir avisar on 01/12/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

extension String {
    func capitalize(prefixCount: Int = 1) -> String {
        return prefix(prefixCount).capitalized + dropFirst()
    }
}
