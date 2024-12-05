//
//  MockTranslationService.swift
//  OpenfieldTests
//
//  Created by amir avisar on 16/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation

@testable import Openfield

class MockTranslationPrivder: TranslationProvider {
    func localizedString(localizedString _: LocalizeString?, defaultValue defaultValue: String) -> String {
        return defaultValue
    }
}
