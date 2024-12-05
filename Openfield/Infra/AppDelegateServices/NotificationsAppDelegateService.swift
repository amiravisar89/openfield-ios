//
//  NotificationsAppDelegateService.swift
//  Openfield
//
//  Created by amir avisar on 05/11/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit
import Resolver

class NotificationsAppDelegateService: NSObject, AppDelegateService, UNUserNotificationCenterDelegate {
  
  var notificationProcessor : NotificationProcessor!
  
  init(notificationProcessor : NotificationProcessor) {
    self.notificationProcessor = notificationProcessor
  }
  
  func application(_: UIApplication,
                   didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
  {
      UNUserNotificationCenter.current().delegate = self
      UIApplication.shared.registerForRemoteNotifications()
      return true
  }
  
  func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let deepLinkFacade: DeeplinkingFacade = Resolver.resolve()
    let userInfo = response.notification.request.content.userInfo
    if let url = notificationProcessor.processNotification(userInfo: userInfo).url {
      deepLinkFacade.handleDeeplink(url, origin: .notification)
    }
    completionHandler()
    
  }
  
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
  {
    let deviceTokenString = deviceToken.reduce("") { $0 + String(format: "%02X", $1) }
    log.info("Device Token \(deviceTokenString)")
  }
  
  func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler _: @escaping (UIBackgroundFetchResult) -> Void) {
    guard let notificationType = notificationProcessor.processNotification(userInfo: userInfo).payload else {
      return
    }
    switch notificationType {
    case let payload as UserReportNotificationPayload:
      guard let reportId = payload.report_id else { return }
      EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.notifications, .notification_recieve, [EventParamKey.userReportUid: String(reportId)]))
    case let payload as InsightNotificationPayload:
      guard let insightUid = payload.insights.first?.uid else { return }
      EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.notifications, .notification_recieve, [EventParamKey.insightUid: insightUid]))
    case let payload as ImageryNotificationPayload:
      EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.notifications, .notification_recieve, [EventParamKey.imagery_date: payload.date.description]))
    default:
      break
    }
  }
  
  func userNotificationCenter(_ center : UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.list, .banner, .badge, .sound])
  }
  
}
