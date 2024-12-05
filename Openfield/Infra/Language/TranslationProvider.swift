//
//  TranslationProvider.swift
//  Openfield
//
//  Created by amir avisar on 26/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation

protocol TranslationProvider {
    func localizedString(localizedString: LocalizeString?, defaultValue: String) -> String
}
