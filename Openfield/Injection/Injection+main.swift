//
//  Injection+main.swift
//  Openfield
//
//  Created by amir avisar on 11/11/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//
import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    registerLogging()
    registerWindow()
    registerNavigation()
    registerSmartLook()
    registerFirebase()
    registerReactors()
    registerFarmFilter()
    registerData()
    registerDateFormatters()
    registerNetwork()
    registerServices()
    registerLanguage()
    registerMappers()
    registerUserStateProvider()
    registerFeatureFlag()
    registerOS()
    registerAnimations()
    registerContracts()
    registerHighlights()
    registerRemoteConfig()
    registerDeppLink()
    registerNotifications()
  }
}
