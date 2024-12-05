//
//  LanguageProvider.swift
//  Openfield
//
//  Created by amir avisar on 26/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

protocol LanguageProvider {
    func setAppLanguage(language: LanguageData)
    func availableLanguage() -> [Locale]
    func localizationLocale() -> Locale
}
