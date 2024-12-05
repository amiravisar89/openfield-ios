//
//  LokaliseTranslationProvider.swift
//  Openfield
//
//  Created by amir avisar on 26/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import Lokalise
import RxSwift
import SwiftyUserDefaults
import UIKit

let localizableFileName = "Localizable"

class LokaliseTranslationProvider: TranslationProvider {
    func localizedString(localizedString: LocalizeString?, defaultValue: String) -> String {
        guard let localizedString = localizedString else { return defaultValue }
        guard let token = localizedString.token else { return defaultValue }
        var lokalisedString = Lokalise.shared.localizedString(forKey: token, value: defaultValue, table: localizableFileName)
        guard let params = localizedString.params else { return lokalisedString }

        params.keys.forEach { key in
            if let value = params[key] {
                lokalisedString = lokalisedString.replacingOccurrences(of: "{{\(key)}}", with: String(describing: value))
            } else {
                lokalisedString = lokalisedString.replacingOccurrences(of: "{{\(key)}}", with: "")
            }
        }
        return lokalisedString
    }
}
