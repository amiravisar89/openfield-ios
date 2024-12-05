//
//  UnitTestsAppDelegate.swift
//  OpenfieldTests
//
//  Created by Daniel Kochavi on 01/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

@objc(TestingAppDelegate)
class UnitTestsAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()

        return true
    }
}
