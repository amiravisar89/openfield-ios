//
//  LocalNotificationManager.swift
//  Openfield
//
//  Created by amir avisar on 13/05/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

class LocalNotificationManager: NSObject {
    static func postNotificationWith(name: CustomeNotificationsName, options: NSKeyValueObservingOptions?) {
        NotificationCenter.default.post(name: Notification.Name(name.rawValue), object: options)
    }

    static func registerToNotification(gestureHandler: AnyObject, selector: Selector, notificationName: CustomeNotificationsName) {
        NotificationCenter.default.addObserver(gestureHandler, selector: selector, name: Notification.Name(notificationName.rawValue), object: nil)
    }

    static func postNotificationWith(name: Notification.Name, options: NSKeyValueObservingOptions?) {
        NotificationCenter.default.post(name: name, object: options)
    }

    static func registerToNotification(gestureHandler: AnyObject, selector: Selector, notificationName: Notification.Name) {
        NotificationCenter.default.addObserver(gestureHandler, selector: selector, name: notificationName, object: nil)
    }

    static func removeObserver(object: NSObject) {
        NotificationCenter.default.removeObserver(object)
    }
}

enum CustomeNotificationsName: String {
    case showFieldToolTip = "show_field_tooltip"
    case anlysisCompareFinishScrolling = "anlysis_compare_finish_scrolling"
}
