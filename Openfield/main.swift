//
//  main.swift
//  Openfield
//
//  Created by Daniel Kochavi on 01/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

private func delegateClassName() -> String? {
    return NSClassFromString("XCTestCase") == nil ?
        NSStringFromClass(AppDelegate.self) :
        NSStringFromClass(UnitTestsAppDelegate.self)
}

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    delegateClassName()
)
