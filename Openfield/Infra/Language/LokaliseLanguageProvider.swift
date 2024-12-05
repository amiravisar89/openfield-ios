//
//  LokaliseLanguageProvider.swift
//  Openfield
//
//  Created by amir avisar on 26/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import Lokalise
import RxSwift
import SwiftyUserDefaults

class LokaliseLanguageProvider: LanguageProvider {
    func setAppLanguage(language: LanguageData) {
        Lokalise.shared.setLocalizationLocale(language.locale, makeDefault: true, completion: nil)
    }

    func availableLanguage() -> [Locale] {
        return Lokalise.shared.availableLocales()
    }

    func localizationLocale() -> Locale {
        return Lokalise.shared.localizationLocale
    }
}
