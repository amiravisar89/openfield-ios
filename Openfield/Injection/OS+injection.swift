//
//  OS+injection.swift
//  Openfield
//
//  Created by amir avisar on 23/02/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation

import Foundation
import Resolver
import UIKit

extension Resolver {
    static func registerOS() {
        register { OSappDelegateService() }
        register {AppDelegateServicesProvider()}
    }
}
