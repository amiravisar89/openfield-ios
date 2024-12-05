//
//  InsightServerModel.swift
//  Openfield
//
//  Created by Daniel Kochavi on 27/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Firebase
import Foundation

struct InsightServerModel: Decodable {
    let id: Int
    let type: String
    let field_id: Int
    let field_name: String
    let i18n_field_name: LocalizeString?
    let farm_name: String?
    let farm_id: Int?
    let subject: String
    let i18n_subject: LocalizeString?
    let description: String
    let i18n_description: LocalizeString?
    let tags_area: Double
    var ts_published: Timestamp?
    let time_zone: String?
    let uid: String
    let images: [InsightImageServerModel]
    let tags: [InsightTagServerModel]
    var metadata: InsightMetadataServerModel?
    var category: String
    var subcategory: String
    var highlight: HighlightServerModel?
    var cycle_id: Int?
    var publication_year: Int?
    let field_country: String?
}


struct InsightImageServerModel: Decodable {
    let type: String
    let image_id: Int
    let type_desc: String
    let is_main_image: Bool
    let date: Timestamp
    let bounds: ImageBoundsServerModel
    let issue: LayerIssueServerModel?
    let preview: [PreviewImageServerModel]
    let source_type: String?
}

struct InsightTagServerModel: Decodable {
    let id: Int
    let geojson: String
}

struct InsightMetadataServerModel: Decodable {
    let aggregation_unit: String?
    let crop: String?
    let start_date: Int?
    let end_date: Int?
    let relative_to_last_report: Int?
    let scanned_area_percent: Int?
    let tagged_images_percent: Int?
    let goal_stand_count: Double?
    let cover_image: [ImageSpatialServerModel]?
    let items: [LocationInsightItemServerModel]?
    let enhanced_data: LocationInsightEnhanceDataServerModel?
    let avg_stand_count: Int?
    let first_detection_data: FirstDetectionDataServerModel?
    var i18n_report_summary: LocalizeString?
    var report_summary: String?
}



struct FirstDetectionDataServerModel: Decodable {
    let image_date: Int
    let full_report_data: Int
}

struct LocationInsightEnhanceDataServerModel: Decodable {
    let title: String
    let i18n_title: LocalizeString
    let subtitle: String
    let i18n_subtitle: LocalizeString
    let locations_agg_name: String
    let i18n_locations_agg_name: LocalizeString
    let locations_agg_value: String?
    let is_severity: Bool
    let ranges: LocationInsightRangeServerModel
}

struct LocationInsightRangeServerModel: Decodable {
    let title: String
    let midtitle: String
    let subtitle: String
    let i18n_title: LocalizeString
    let i18n_midtitle: LocalizeString
    let i18n_subtitle: LocalizeString
    let levels: [LocationInsightLevelsServerModel]
}

struct LocationInsightLevelsServerModel: Decodable {
    let order: Int
    let color: String
    let value: Int
    let name: String
    let i18n_name: LocalizeString?
    let relative_to_last_report: Int?
    let location_ids: [Int]
    let id: Int?
}

struct LocationInsightItemServerModel: Decodable {
    let description: String?
    let i18n_description: LocalizeString?
    let id: Int
    let name: String
    let i18n_name: LocalizeString?
    let tagged_images_percent: Int
    let displayed_value: String?
    let i18n_displayed_value: LocalizeString?
    let min_range: Int?
    let max_range: Int?
    let enhanced_data: LocationInsightEnhanceDataServerModel?
}

struct InsightAttachmentServerModel: Decodable {
    let insight_uid: String
    let items: [InsightAttachmentItemServerModel]
}

struct InsightAttachmentItemServerModel: Decodable {
    let data: String
    let type: String
}

struct LocationDetailServerModel: Decodable {
    let id: Int
    let latitude: Double
    let longitude: Double
    let item_ids: [Int]
    let images: [LocationImageMetaDataServerModel]
}

struct LocationImageMetaDataServerModel: Decodable {
    let id: Int
    let date: Int
    let item_id: Int
    let is_cover: Bool
    let is_selected: Bool
    let previews: [PreviewImageMetadataServerModel]
    let tags: [LocationTagServerModel]
    let lat: Double?
    let long: Double?
    let level_id: Int?
    let is_night_image: Bool?
}

struct LocationTagServerModel: Decodable {
    let type: String
    let points: [[Double]?]
}

struct TagPointServerModel: Decodable {
    let x: Double
    let y: Double
}

struct HighlightServerModel: Decodable {
    var content: String?
    var i18n_content: LocalizeString?
}
