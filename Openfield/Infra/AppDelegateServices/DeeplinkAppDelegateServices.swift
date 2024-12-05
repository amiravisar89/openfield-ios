//
//  DeeplinkAppDelegateServices.swift
//  Openfield
//
//  Created by amir avisar on 05/11/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit
import Resolver

class DeeplinkAppDelegateServices: NSObject, AppDelegateService {
  
  var notificationProcessor : NotificationProcessor!
  
  
  init(notificationProcessor : NotificationProcessor) {
    self.notificationProcessor = notificationProcessor
  }
  
  func application(_ application: UIApplication,
                   open url: URL,
                   options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool
  {
    let deepLinkFacade: DeeplinkingFacade = Resolver.resolve()
    deepLinkFacade.handleDeeplink(url, origin: .link)
    return true
  }
  
  func application(_ application: UIApplication,
                   continue userActivity: NSUserActivity,
                   restorationHandler handler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
  {
    let deepLinkFacade: DeeplinkingFacade = Resolver.resolve()
    switch userActivity.activityType {
    case NSUserActivityTypeBrowsingWeb:
      if let webpageURL = userActivity.webpageURL {
        deepLinkFacade.handleDeeplink(webpageURL, origin: .link)
        return true
      } else {
        return false
      }
    default:
      return false
    }
  }
  
}
