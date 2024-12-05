//
//  LanguageService.swift
//  Openfield
//
//  Created by amir avisar on 03/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyUserDefaults
import UIKit

class LanguageData {
    let name: String
    let locale: Locale

    init(name: String, locale: Locale) {
        self.name = name
        self.locale = locale
    }
}

class LanguageService {
    // MARK: - Statics

    public static let defaultLanguage = LanguageData(name: "English", locale: Locale(identifier: "en_US"))

    // MARK: - Members

    var languageProvider: LanguageProvider
    var languageSupported: [LanguageData]
    let disposeBag = DisposeBag()

    // MARK: - Observables

    var currentLanguage: BehaviorSubject<LanguageData> = BehaviorSubject(value: defaultLanguage)

    // MARK: - init

    init(languageProvider: LanguageProvider) {
        self.languageProvider = languageProvider
        languageSupported = self.languageProvider.availableLanguage().compactMap { locale in
            if let name = locale.localizedString(forIdentifier: locale.identifier) {
                return LanguageData(name: name, locale: locale)
            } else { return nil }
        }

        setLanguage(languageCode: self.languageProvider.localizationLocale().identifier)
      
      currentLanguage
          .distinctUntilChanged { a, b in a.locale.identifier == b.locale.identifier }
          .bind { [weak self] in
              FirebaseEventTrackingAnalyticsService.setUserProperty(propertyName: .language, value: $0.locale.identifier)
              FirebaseEventTrackingAnalyticsService.setUserProperty(propertyName: .deviceLanguage, value: NSLocale.current.languageCode ?? "none")
          }.disposed(by: disposeBag)
    }

    // MARK: - private func

    private func setAppLanguage(language: LanguageData) {
        languageProvider.setAppLanguage(language: language)
        currentLanguage.onNext(language)
    }

    // MARK: - public func

    public func setLanguage(languageCode: String) {
        guard let selectedLanguage = language(for: languageCode) else {
            setAppLanguage(language: LanguageService.defaultLanguage)
            log.warning("languages code: \(languageCode) does not supported")
            return
        }
        setAppLanguage(language: selectedLanguage)
    }

    public func language(for code: String) -> LanguageData? {
        return languageSupported.first(where: { $0.locale.identifier == code })
    }
}
