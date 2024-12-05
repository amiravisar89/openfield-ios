//
//  EnhanceDataMapper.swift
//  Openfield
//
//  Created by amir avisar on 30/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import UIKit

enum EnhanceDataMapper {
    static func map(enhanceDataServer: LocationInsightEnhanceDataServerModel?, translationService: TranslationService) -> LocationInsightEnhanceData? {
        guard let enhanceData = enhanceDataServer else { return nil }

        let rangesTitle = translationService.localizedString(localizedString: enhanceData.ranges.i18n_title, defaultValue: enhanceData.ranges.title)
        let rangesSubtitle = translationService.localizedString(localizedString: enhanceData.ranges.i18n_subtitle, defaultValue: enhanceData.ranges.subtitle)
        let rangesMidtitle = translationService.localizedString(localizedString: enhanceData.ranges.i18n_midtitle, defaultValue: enhanceData.ranges.midtitle)

        let levels = enhanceData.ranges.levels.map { level -> LocationInsightLevel in
            let name = translationService.localizedString(localizedString: level.i18n_name, defaultValue: level.name)
            return LocationInsightLevel(order: level.order, color: UIColor.hexStringToUIColor(hex: level.color), value: level.value, name: name, relativeToLastReport: level.relative_to_last_report, locationIds: level.location_ids, id: level.id)
        }

        let ranges = LocationInsightRange(title: rangesTitle, midtitle: rangesMidtitle, subtitle: rangesSubtitle, levels: levels)

        let title = translationService.localizedString(localizedString: enhanceData.i18n_title, defaultValue: enhanceData.title)
        let subtitle = translationService.localizedString(localizedString: enhanceData.i18n_subtitle, defaultValue: enhanceData.subtitle)
        let locationAggName = translationService.localizedString(localizedString: enhanceData.i18n_locations_agg_name, defaultValue: enhanceData.locations_agg_name)

        return LocationInsightEnhanceData(title: title, subtitle: subtitle, locationsAggValue: enhanceData.locations_agg_value, locationsAggName: locationAggName, isSeverity: enhanceData.is_severity, ranges: ranges)
    }
}
