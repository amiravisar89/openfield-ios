//
//  Window+Injection.swift
//  LottoMatic
//
//  Created by amir avisar on 14/01/2022.
//

import Foundation
import Resolver
import UIKit

extension Resolver {
    static func registerWindow() {
        register { RootWindow(rootVc: Resolver.resolve()) }.scope(application)
    }
}
