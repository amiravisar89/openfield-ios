//
//  InsightTestModels.swift
//  OpenfieldTests
//
//  Created by amir avisar on 22/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Firebase
import Foundation
import SwiftDate
import GEOSwift

@testable import Openfield

enum FarmTestModel {
    static let allFarmsSelected = [FilteredFarm(isSelected: true, name: "farm name", fieldIds: [], type: .allFarms, id: 0)]
}

enum InsightTestModels {
    static let irrigationInsight = IrrigationInsight(id: 0, uid: "12", type: "irrigation", subject: "subject", fieldId: 1_447_612, fieldName: "field name", farmName: "farm name", farmId: 0, description: "description", publishDate: Date(), affectedArea: 0, affectedAreaUnit: "", isRead: true, tsFirstRead: nil, timeZone: nil, imageDate: Date(), thumbnail: "", images: [], mainImage: InsightImage(date: Date(), id: 0, bounds: ImageBounds(boundsLeft: 0, boundsBottom: 0, boundsRight: 0, boundsTop: 0), type: .rgb, issue: nil, previews: [PreviewImage(url: "", height: 50, width: 50, imageId: 1, issue: nil)], sourceType: .plane), review: nil, feedback: Feedback(insightId: 0, rating: nil, reason: nil, otherReasonText: nil), isSelected: false, tag: InsightTag(id: 0, tag: .geometry(Geometry.point(Point(x: 0, y: 0)))), dateRegion: Region.local, category: "irrigation", subCategory: "detection",displayName: "Irrigation", highlight: "irrigation", cycleId: nil, publicationYear: 2024)
    
    static let singleLocationInsight = SingleLocationInsight(id: 0, uid: "12", type: "canopy_cover", subject: "subject", fieldId: 1_447_612, fieldName: "field name", farmName: "farm name", farmId: 0, description: "description", publishDate: Date(), affectedArea: 0, affectedAreaUnit: "", isRead: true, tsFirstRead: nil, timeZone: nil, thumbnail: "",startDate: Date(), endDate: Date(), scannedAreaPercent: 80, taggedImagesPercent: 50, relativeToLastReport: 10, coverImage: [SpatialImage](), items: [LocationInsightItem](), aggregationUnit: "dc", region: Region.local, firstDetectionData: FirstDetectionData(title: "fd", imageDate: Date(), fullReportDate: Date()), category: "canopy_cover", subCategory: "detection",displayName: "issueLocationInsight", summery: "summery", highlight: nil, cycleId: 1, publicationYear: 2024)
    
 static let irrigationInsightServerModel = InsightServerModel(id: 932_380,
                                                      type: "irrigation",
                                                      field_id: 1_447_612,
                                                      field_name: "field 2",
                                                      i18n_field_name: nil,
                                                      farm_name: "Demo",
                                                      farm_id: 0,
                                                      subject: "Under watering end gun",
                                                      i18n_subject: nil,
                                                      description: "Irregular irrigation pattern in the endgun, resulting in underwatering",
                                                      i18n_description: nil,
                                                      tags_area: 5.55521009094521,
                                                      ts_published: Timestamp(),
                                                      time_zone: "America/Boise",
                                                      uid: "q1YBRXYG",
                                                      images: [],
                                                      tags: [InsightTagServerModel(id: 3_182_148, geojson: InsightTestModels.fakeGeojson)],
                                                              metadata: nil, category: "detection", subcategory: "irrigation", highlight: HighlightServerModel(content: "irrigation", i18n_content: nil), field_country: "US")

    static let locationInsight = InsightServerModel(id: 1_114_367,
                                                    type: "e_weeds",
                                                    field_id: 51448,
                                                    field_name: "WP20",
                                                    i18n_field_name: nil,
                                                    farm_name: "Lambweston NW Territory",
                                                    farm_id: 0,
                                                    subject: "Weed report",
                                                    i18n_subject: nil,
                                                    description: "_",
                                                    i18n_description: nil,
                                                    tags_area: 0,
                                                    ts_published: Timestamp(),
                                                    time_zone: "America/Los_Angeles",
                                                    uid: "biPZPLZX",
                                                    images: [],
                                                    tags: [],
                                                    metadata: InsightMetadataServerModel(aggregation_unit: "acre",
                                                                                         crop: "potato",
                                                                                         start_date: 1_625_097_621,
                                                                                         end_date: 1_625_183_180,
                                                                                         relative_to_last_report: 0,
                                                                                         scanned_area_percent: 0,
                                                                                         tagged_images_percent: 0,
                                                                                         goal_stand_count: nil,
                                                                                         cover_image: [ImageSpatialServerModel(height: 304, width: 303, url: "https://thumbs-us.o.prospera.ag/51448/52ae42c5e7074398a3854d1e696c3ee6_rgb_303.webp", bounds: ImageBoundsServerModel(boundsLeft: -119.60339836917176,
                                                                                                                                                                                                                                                                                   boundsBottom: 45.98404093359024,
                                                                                                                                                                                                                                                                                   boundsRight: -119.59165074459517,
                                                                                                                                                                                                                                                                                   boundsTop: 45.99222982546748)),
                                                                                                       ImageSpatialServerModel(height: 602, width: 600, url: "https://thumbs-us.o.prospera.ag/51448/52ae42c5e7074398a3854d1e696c3ee6_rgb_600.webp", bounds: ImageBoundsServerModel(boundsLeft: -119.60339836917176,
                                                                                                                                                                                                                                                                                   boundsBottom: 45.98404093359024,
                                                                                                                                                                                                                                                                                   boundsRight: -119.59165074459517,
                                                                                                                                                                                                                                                                                   boundsTop: 45.99222982546748))],
                                                                                         items: [LocationInsightItemServerModel(description: nil,
                                                                                                                                i18n_description: nil,
                                                                                                                                id: 51149,
                                                                                                                                name: "",
                                                                                                                                i18n_name: nil,
                                                                                                                                tagged_images_percent: 0,
                                                                                                                                displayed_value: nil,
                                                                                                                                i18n_displayed_value: nil,
                                                                                                                                min_range: nil,
                                                                                                                                max_range: nil,
                                                                                                                                enhanced_data: LocationInsightEnhanceDataServerModel(title: "Plants chlorosis",
                                                                                                                                                                                     i18n_title: LocalizeString(token: "locations_with_findings",
                                                                                                                                                                                                                params: [:]),
                                                                                                                                                                                     subtitle: "",
                                                                                                                                                                                     i18n_subtitle: LocalizeString(token: "empty_text",
                                                                                                                                                                                                                   params: [:]),
                                                                                                                                                                                     locations_agg_name: "Locations with findings",
                                                                                                                                                                                     i18n_locations_agg_name: LocalizeString(token: "locations_with_findings",
                                                                                                                                                                                                                             params: [:]),
                                                                                                                                                                                     locations_agg_value: "~1%",
                                                                                                                                                                                     is_severity: false,
                                                                                                                                                                                     ranges: LocationInsightRangeServerModel(title: "Severity",
                                                                                                                                                                                                                             midtitle: "- % of scan",
                                                                                                                                                                                                                             subtitle: "Change from last report",
                                                                                                                                                                                                                             i18n_title: LocalizeString(token: "report.range.title.severity",
                                                                                                                                                                                                                                                        params: [:]),
                                                                                                                                                                                                                             i18n_midtitle: LocalizeString(token: "report.percent_of_scan",
                                                                                                                                                                                                                                                           params: [:]),
                                                                                                                                                                                                                             i18n_subtitle: LocalizeString(token: "report.relative_to_last_report",
                                                                                                                                                                                                                                                           params: [:]),
                                                                                                                                                                                                                             levels: [LocationInsightLevelsServerModel(order: 0,
                                                                                                                                                                                                                                                                       color: "#1BC62C",
                                                                                                                                                                                                                                                                       value: 99,
                                                                                                                                                                                                                                                                       name: "No findings",
                                                                                                                                                                                                                                                                       i18n_name: LocalizeString(token: "no_findings",
                                                                                                                                                                                                                                                                                                 params: [:]),
                                                                                                                                                                                                                                                                       relative_to_last_report: nil,
                                                                                                                                                                                                                                                                       location_ids: [1, 2, 3, 4, 5, 6, 7, 8],
                                                                                                                                                                                                                                                                       id: 14169)])))],
                                                                                         enhanced_data: LocationInsightEnhanceDataServerModel(title: "Plants chlorosis",
                                                                                                                                              i18n_title: LocalizeString(token: "locations_with_findings",
                                                                                                                                                                         params: [:]),
                                                                                                                                              subtitle: "",
                                                                                                                                              i18n_subtitle: LocalizeString(token: "empty_text",
                                                                                                                                                                            params: [:]),
                                                                                                                                              locations_agg_name: "Locations with findings",
                                                                                                                                              i18n_locations_agg_name: LocalizeString(token: "locations_with_findings",
                                                                                                                                                                                      params: [:]),
                                                                                                                                              locations_agg_value: "~1%",
                                                                                                                                              is_severity: false,
                                                                                                                                              ranges: LocationInsightRangeServerModel(title: "Severity",
                                                                                                                                                                                      midtitle: "- % of scan",
                                                                                                                                                                                      subtitle: "Change from last report",
                                                                                                                                                                                      i18n_title: LocalizeString(token: "report.range.title.severity",
                                                                                                                                                                                                                 params: [:]),
                                                                                                                                                                                      i18n_midtitle: LocalizeString(token: "report.percent_of_scan",
                                                                                                                                                                                                                    params: [:]),
                                                                                                                                                                                      i18n_subtitle: LocalizeString(token: "report.relative_to_last_report",
                                                                                                                                                                                                                    params: [:]),
                                                                                                                                                                                      levels: [LocationInsightLevelsServerModel(order: 0,
                                                                                                                                                                                                                                color: "#1BC62C",
                                                                                                                                                                                                                                value: 99,
                                                                                                                                                                                                                                name: "No findings",
                                                                                                                                                                                                                                i18n_name: LocalizeString(token: "no_findings",
                                                                                                                                                                                                                                                          params: [:]),
                                                                                                                                                                                                                                relative_to_last_report: nil,
                                                                                                                                                                                                                                location_ids: [1, 2, 3, 4, 5, 6, 7, 8],
                                                                                                                                                                                                                                id: 14169)])),
                                                                                         avg_stand_count: nil, first_detection_data: nil), category: "detection", subcategory: "weeds", highlight: nil, field_country: "US")

    static let fakeGeojson = """
    {"type": "Feature", "geometry": {"type": "Polygon", "coordinates": [[[-112.52896376506409, 43.26649694982303], [-112.52897287313546, 43.26656428822779], [-112.52899984733155, 43.266629038785176], [-112.5290436510491, 43.26668871317963], [-112.52910260093579, 43.266741018175736], [-112.52917443158059, 43.26678394374311], [-112.52925638257206, 43.26681584029759], [-112.52934530457955, 43.266835482090535], [-112.52943778038022, 43.26684211431094], [-112.52953025618089, 43.266835482090535], [-112.52961917818838, 43.26681584029759], [-112.52970112917987, 43.26678394374311], [-112.52977295982465, 43.266741018175736], [-112.52983190971135, 43.26668871317963], [-112.5298757134289, 43.266629038785176], [-112.52990268762498, 43.26656428822779], [-112.52991179569636, 43.26649694982303], [-112.52990268762498, 43.26642961134377], [-112.5298757134289, 43.26636486057425], [-112.52983190971135, 43.266305185862315], [-112.52977295982465, 43.26625288049172], [-112.52970112917987, 43.26620995454985], [-112.52961917818838, 43.266178057677884], [-112.52953025618089, 43.2661584156728], [-112.52943778038022, 43.2661517833779], [-112.52934530457955, 43.2661584156728], [-112.52925638257206, 43.266178057677884], [-112.52917443158059, 43.26620995454985], [-112.52910260093579, 43.26625288049172], [-112.5290436510491, 43.266305185862315], [-112.52899984733155, 43.26636486057425], [-112.52897287313546, 43.26642961134377], [-112.52896376506409, 43.26649694982303]], [[-112.52920429576092, 43.26649694982303], [-112.52920878210242, 43.2665301185534], [-112.52922206871928, 43.26656201261102], [-112.52924364501432, 43.266591406328075], [-112.5292726818226, 43.26661717012488], [-112.52930806327586, 43.26663831391834], [-112.52934842968469, 43.26665402516951], [-112.52939222979064, 43.26666370010819], [-112.52943778038022, 43.26666696693484], [-112.5294833309698, 43.26666370010819], [-112.52952713107575, 43.26665402516951], [-112.52956749748458, 43.26663831391834], [-112.52960287893784, 43.26661717012488], [-112.52963191574612, 43.266591406328075], [-112.52965349204116, 43.26656201261102], [-112.52966677865804, 43.2665301185534], [-112.52967126499954, 43.26649694982303], [-112.52966677865804, 43.26646378107458], [-112.52965349204116, 43.266431886965485], [-112.52963191574612, 43.266402493171405], [-112.52960287893784, 43.266376729283735], [-112.52956749748458, 43.26635558539942], [-112.52952713107575, 43.26633987407122], [-112.5294833309698, 43.266330199081075], [-112.52943778038022, 43.266326932236346], [-112.52939222979064, 43.266330199081075], [-112.52934842968469, 43.26633987407122], [-112.52930806327586, 43.26635558539942], [-112.5292726818226, 43.266376729283735], [-112.52924364501432, 43.266402493171405], [-112.52922206871928, 43.266431886965485], [-112.52920878210242, 43.26646378107458], [-112.52920429576092, 43.26649694982303]]]}, "properties": {"srid": 3857, "type": "Ring", "center": [-112.52943778038022, 43.26649694982303], "firstRadius": 52.7671436201781, "secondRadius": 25.991388930007815}}
    """
}
