//
//  SmartLookProvider.swift
//  Openfield
//
//  Created by amir avisar on 07/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//
import Foundation
import UIKit

class SmartLookProviderAppDelegateSerivces: NSObject, AppDelegateService {
    let smartLookProvider: SmartLookProvider

    init(smartlookProvider: SmartLookProvider) {
        smartLookProvider = smartlookProvider
    }

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        smartLookProvider.setupSmartlook()
        smartLookProvider.startRecording()
        return true
    }

    func applicationWillTerminate(_: UIApplication) {
        smartLookProvider.stopRecording()
    }
}
