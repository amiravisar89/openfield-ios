//
//  RemoteConfigParameterKey.swift
//  Openfield
//
//  Created by Daniel Kochavi on 16/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

// Important: Do not forget to add defaults in RemoteConfigDefaults.plist

enum RemoteConfigParameterKey: String, CaseIterable {
    case user_roles
    case iosMinForceVersion
    case iosMinSoftVersion
    case optionalPopUpDaysTimeInterval
    case subscribePopUpMainButtonTitleUnclick
    case subscribePopUpMainButtonTitleClick
    case subscribePopUpSecondaryButtonTitle
    case subscribePopUpImageUrl
    case subscribePopUpSubtitle
    case subscribePopupTitle
    case subscribePopupMinDate
    case subscribePopupMaxDate
    case mobile_supported_insights_categories
    case mobile_support_url
    case mobile_help_center_url
    case units_by_country
    case feed_min_date_v2
    case contracts
    case insight_interval_since_now
    case images_interval_since_now
    case highlight_days
    case highlight_items
    case field_irrigation_limit
    case shapefile_en_url
    case shapefile_pt_url
    case request_report_en_url
    case request_report_pt_url
    case start_year_for_request_report
    case start_year_for_virtual_scouting
    case image_size_for_gallery
}
