//
//  TranslationService.swift
//  Openfield
//
//  Created by amir avisar on 18/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import Lokalise
import RxSwift
import SwiftyUserDefaults
import UIKit

class TranslationService {
    let translationProvider: TranslationProvider

    init(translateProvider: TranslationProvider) {
        translationProvider = translateProvider
    }

    // MARK: - public func

    public func localizedString(localizedString: LocalizeString?, defaultValue: String) -> String {
        return translationProvider.localizedString(localizedString: localizedString, defaultValue: defaultValue)
    }
}
