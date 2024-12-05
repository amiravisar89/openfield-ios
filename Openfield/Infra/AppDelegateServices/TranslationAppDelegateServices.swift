//
//  TranslationAppDelegateServices.swift
//  Openfield
//
//  Created by amir avisar on 12/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import Lokalise
import UIKit

class TranslationAppDelegateServices: NSObject, AppDelegateService {
    var token: String {
        return ConfigEnvironment.valueFor(key: .lokaliseToken)
    }

    var projectId: String {
        return ConfigEnvironment.valueFor(key: .lokaliseProjectId)
    }

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        Lokalise.shared.setProjectID(projectId, token: token)
        Lokalise.shared.swizzleMainBundle()
        Lokalise.shared.localizationType = ConfigEnvironment.scheme() == .Release ? .release : .prerelease
        return true
    }

    func applicationDidBecomeActive(_: UIApplication) {
        Lokalise.shared.checkForUpdates { updated, errorOrNil in
            log.info("Lokalise SDK updated: \(updated)\n with Error: \(String(describing: errorOrNil))")
        }
    }
}
