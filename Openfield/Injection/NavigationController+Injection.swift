//
//  NavigationController+Injection.swift
//  LottoMatic
//
//  Created by amir avisar on 14/01/2022.
//

import Foundation
import Resolver

extension Resolver {
    static func registerNavigation() {
        register { BaseNavigationViewController() }.scope(application)
      register {
        let getVersionLimitUseCase: GetVersionsLimitUseCase = resolve()
        let remoteConfigRepo : RemoteConfigRepository = resolve()
        return RootFlowController(navigationController: Resolver.resolve(), userStateProvider: Resolver.resolve(), languageService: resolve(), getVersionsLimitUseCase: getVersionLimitUseCase, remoteConfigRepo: remoteConfigRepo) }.scope(application)
    }
}
