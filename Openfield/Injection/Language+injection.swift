//
//  Language+injection.swift
//  Openfield
//
//  Created by amir avisar on 03/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import Resolver

extension Resolver {
    static func registerLanguage() {
        register { TranslationAppDelegateServices() }.scope(application)
        register { LanguageService(languageProvider: resolve()) }.scope(application)
        register { TranslationService(translateProvider: resolve()) }.scope(application)
        register { LokaliseTranslationProvider() as TranslationProvider }.scope(application)
        register { LokaliseLanguageProvider() as LanguageProvider }.scope(application)
    }
}
