//
//  AppDelegate.swift
//  Openfield
//
//  Created by Daniel Kochavi on 12/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Firebase
import Resolver
import RxSwift
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  fileprivate var services: [AppDelegateService] = []
  fileprivate lazy var servicesProvider: AppDelegateServicesProvider = Resolver.resolve()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    FirebaseApp.configure()
    services = servicesProvider.provide()
    services.forEach { _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions) }
    
    AnalyticsMeasure.sharedInstance.start(label: Events.openToFeed.rawValue)
    PerformanceManager.shared.startTrace(for: NavigationOrigin.app_launch.rawValue)
    EventTrackingManager.sharedInstance.configure(config: EventTrackingManagerConfig(analyticsServices: [
      FirebaseEventTrackingAnalyticsService(),
      CrashlyticsEventTrackingService(),
    ], enrichments: []))
    
    window = Resolver.resolve() as RootWindow
    let rootFlowController: RootFlowController = Resolver.resolve()
    rootFlowController.setup()
    rootFlowController.start()
    
    window?.makeKeyAndVisible()
    return true
  }
  
  func application(_ application: UIApplication,
                   open url: URL,
                   options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool
  {
    services.forEach { _ = $0.application?(application, open: url, options: options) }
    return true
  }
  
  func application(_ application: UIApplication,
                   continue userActivity: NSUserActivity,
                   restorationHandler handler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
  {
    var result = false
    services.forEach {result = $0.application?(application, continue: userActivity, restorationHandler: handler) ?? false}
    return result
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    services.forEach { $0.applicationDidBecomeActive?(application) }
  }
  
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
    services.forEach { $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) }
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    services.forEach { $0.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)}
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    services.forEach { $0.applicationWillTerminate?(application) }
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Swift.Error) {
    services.forEach { $0.application?(application, didFailToRegisterForRemoteNotificationsWithError: error) }
  }
  
}

