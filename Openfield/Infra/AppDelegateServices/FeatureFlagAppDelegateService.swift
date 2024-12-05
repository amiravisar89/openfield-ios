//
//  FeatureFlagAppDelegateService.swift
//  Openfield
//
//  Created by Amitai Efrati on 18/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit
import LaunchDarkly
import Resolver

class FeatureFlagAppDelegateSerivce: NSObject, AppDelegateService {
    
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        initSdk()
        let featureFlagManager: FeatureFlagManager = Resolver.resolve()
        return true
    }
    
    func applicationWillTerminate(_: UIApplication) {
        LDClient.get()?.close()
    }
    
    private func initSdk() {
        guard let mobileSdkKey: String = ConfigEnvironment.valueFor(key: .featureFlagMobileSdkKey) else {
            log.error("Failed to get Feature Flag Mobile SDK Key")
            return
        }
        
        let config = LDConfig(mobileKey: mobileSdkKey, autoEnvAttributes: .enabled)
        var contextBuilder = LDContextBuilder()
        contextBuilder.kind(LDKeys.kindAnonymous)
        let contextResult = contextBuilder.build()
        
        switch contextResult {
        case .success(let context):
            LDClient.start(config: config, context: context, startWaitSeconds: 5) { timedOut in
                if timedOut {
                    // Client may not have the most recent flags for the configured context
                } else {
                    // Client has received flags for the configured context
                }
            }
        case .failure(let error):
            log.error("Failed to build LDContext: \(error)")
        }
    }
}
