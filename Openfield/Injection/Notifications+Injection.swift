//
//  Notifications+Injection.swift
//  Openfield
//
//  Created by amir avisar on 05/11/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//
import Foundation
import Resolver

extension Resolver {
  static func registerNotifications() {
    register { NotificationProcessor() }
    register { NotificationsAppDelegateService(notificationProcessor: resolve()) }.scope(application)
  }
}
