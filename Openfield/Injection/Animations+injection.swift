//
//  Animations+injection.swift
//  Openfield
//
//  Created by amir avisar on 15/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import Resolver

extension Resolver {
    static func registerAnimations() {
        register { AnimationProvider() }.scope(application)
    }
}
