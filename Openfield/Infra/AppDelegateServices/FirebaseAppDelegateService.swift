//
//  FirebaseAppDelegateService.swift
//  Openfield
//
//  Created by Daniel Kochavi on 12/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Firebase
import FirebaseCrashlytics
import FirebaseInAppMessaging
import FirebaseMessaging
import Resolver
import RxSwift
import UIKit
import UserNotifications

class FirebaseAppDelegateService: NSObject, AppDelegateService {
  
    let updateUserParamsUsecase: UpdateUserParamsUsecase!
    let disposeBag = DisposeBag()
  
    init(updateUserParamsUsecase: UpdateUserParamsUsecase) {
      self.updateUserParamsUsecase = updateUserParamsUsecase
    }

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        Messaging.messaging().delegate = self
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(!ConfigEnvironment.isDebugMode)
        return true
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        log.info("Successfully registered for remote notifications. FCM Token: \(String(describing: Messaging.messaging().fcmToken)), APNs Token: \(String(describing: Messaging.messaging().apnsToken))")
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let nsError = error as NSError
        if nsError.code == 3010 {
          log
            .verbose("Push notifications are not supported in the iOS Simulator. \(nsError.localizedDescription)")
        } else {
            log.error(error, "Failed to register for remote notifications. Error code: \(nsError.code), Description: \(nsError.localizedDescription)")
        }
    }
}

extension FirebaseAppDelegateService: MessagingDelegate {
    func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        log.verbose("didReceiveRegistrationToken, FCM Token: \(fcmToken)")
        updateUserParamsUsecase.updateUserDevice(refreshToken: true, clearToken: false, isLogin: false)
            .subscribe()
            .disposed(by: disposeBag)
    }
}
