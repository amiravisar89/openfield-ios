//
//  DateFromatter+Injection.swift
//  Openfield
//
//  Created by Daniel Kochavi on 21/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Resolver

extension Resolver {
    static func registerDateFormatters() {
        register { DateProvider(languageService: resolve()) }.scope(application)
    }
}
