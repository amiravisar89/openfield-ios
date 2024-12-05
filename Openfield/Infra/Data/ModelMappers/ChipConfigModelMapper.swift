//
//  ChipConfigMapper.swift
//  Openfield
//
//  Created by amir avisar on 06/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//
import Foundation
import UIKit

struct ChipConfigModelMapper {
    let translationService: TranslationService

    init(translationService: TranslationService) {
        self.translationService = translationService
    }

    func map(serverModel: InsightChipsConfigServerModel?) -> InsightChipConfig? {
        guard let config = serverModel else { return nil }
        let chips = config.chips.map { chip -> InsightChip in

            let title = translationService.localizedString(localizedString: chip.i18n_title, defaultValue: chip.title)

            return InsightChip(text: title)
        }

        let chipColor = UIColor.hexStringToUIColor(hex: config.main_color)
        let secondaryColor = UIColor.hexStringToUIColor(hex: config.secondary_color)

        return InsightChipConfig(mainColor: chipColor, secondaryColor: secondaryColor, chips: chips)
    }
}
