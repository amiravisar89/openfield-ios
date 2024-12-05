//
//  AppDelegateServicesProvider.swift
//  Openfield
//
//  Created by amir avisar on 05/11/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Resolver

class AppDelegateServicesProvider {
  
  func provide() -> [AppDelegateService] {
    let firebaseService: FirebaseAppDelegateService = Resolver.resolve()
    let lokaliseService: TranslationAppDelegateServices = Resolver.resolve()
    let smartLookService: SmartLookProviderAppDelegateSerivces = Resolver.resolve()
    let osService: OSappDelegateService = Resolver.resolve()
    let featureFlagService: FeatureFlagAppDelegateSerivce = Resolver.resolve()
    let deepLinkService: DeeplinkAppDelegateServices = Resolver.resolve()
    let notificationsService: NotificationsAppDelegateService = Resolver.resolve()
    return [firebaseService, lokaliseService, smartLookService, osService, featureFlagService, deepLinkService, notificationsService]
  }
  
}
