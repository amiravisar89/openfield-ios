//
//  DeppLink+Injection.swift
//  Openfield
//
//  Created by amir avisar on 05/11/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import Resolver

extension Resolver {
  static func registerDeppLink() {
    register { DeeplinkAppDelegateServices(notificationProcessor: resolve()) }.scope(application)
    register { DeeplinkingFacade(intentTransitioner: resolve(), rootFlowController: resolve()) }
    register { IntentTransitioner(rootFlowController: resolve()) }
  }
}
