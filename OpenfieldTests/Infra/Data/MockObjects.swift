//
//  MockObjects.swift
//  OpenfieldTests
//
//  Created by Yoni Luz on 25/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import Firebase
import SwiftDate

@testable import Openfield

class MockObjects {
    
    public static let highlightSectionItem = SectionHighlightItem(startDate: Date(), endDate: Date(), items: [HighlightItem(type: .insight(insight: InsightTestModels.irrigationInsight, imageUrl: ""), identity: .zero, date: Date())], id: "id")
    
    public static let fakeFieldServerModelFilters = buildFakeFieldServerModelFitlers()
    public static let fakeFieldFilters = buildFakeFieldFitlers()
    
    // instances of FieldServerModel for testing
    public static let field1 = FieldServerModel(
        country: "USA",
        county: "County1",
        farm_id: 1,
        farm_name: "Farm A",
        id: 101,
        is_demo: false,
        name: "Field X",
        state: "California",
        time_zone: "PST",
        cover_image: nil,
        filters: fakeFieldServerModelFilters,
        subscription_types: []
    )
    
    public static let field2 = FieldServerModel(
        country: "Canada",
        county: "County2",
        farm_id: 2,
        farm_name: "Farm B",
        id: 102,
        is_demo: true,
        name: "Field Y",
        state: "Ontario",
        time_zone: "EST",
        cover_image: nil,
        filters: fakeFieldServerModelFilters,
        subscription_types: []
    )
    
    public static let field3 = FieldServerModel(
        country: "Australia",
        county: "County3",
        farm_id: 3,
        farm_name: "Farm C",
        id: 103,
        is_demo: false,
        name: "Field Z",
        state: "Victoria",
        time_zone: "AEDT",
        cover_image: nil,
        filters: fakeFieldServerModelFilters,
        subscription_types: []
        
    )
    
    // instances of FieldImageServerModel for testing
    public static let fieldImage1 = FieldImageServerModel(
        bounds: ImageBoundsServerModel(
            boundsLeft: 10.0,
            boundsBottom: 20.0,
            boundsRight: 30.0,
            boundsTop: 40.0
        ),
        date: Timestamp(date: Date(timeIntervalSinceNow: -(80*60*60))), //80 hours before
        id: 1,
        layers: ["rgb": LayerImageServerModel(
            issue: LayerIssueServerModel(
                comment: "Comment1",
                is_hidden: false,
                issue: "sharpness"
            ),
            previews: [
                PreviewImageServerModel(
                    url: "url1",
                    layer: "Layer1",
                    height: 100,
                    width: 200
                )
            ]
        )],
        source_type: "Type1",
        field_id: 101
    )
    
    public static let fieldImage2 = FieldImageServerModel(
        bounds: ImageBoundsServerModel(
            boundsLeft: 15.0,
            boundsBottom: 25.0,
            boundsRight: 35.0,
            boundsTop: 45.0
        ),
        date: Timestamp(date: Date(timeIntervalSinceNow: -(30*60*60))), //30 hours before
        id: 2,
        layers: ["rgb": LayerImageServerModel(
            issue: LayerIssueServerModel(
                comment: "Comment2",
                is_hidden: true,
                issue: "darkness"
            ),
            previews: [
                PreviewImageServerModel(
                    url: "url2",
                    layer: "Layer2",
                    height: 150,
                    width: 250
                )
            ]
        )],
        source_type: "Type2",
        field_id: 102
    )
    
    public static let fieldImage3 = FieldImageServerModel(
        bounds: ImageBoundsServerModel(
            boundsLeft: 12.0,
            boundsBottom: 22.0,
            boundsRight: 32.0,
            boundsTop: 42.0
        ),
        date: Timestamp(date: Date(timeIntervalSinceNow: -(40*60*60))), //40 hours before
        id: 3,
        layers: ["rgb": LayerImageServerModel(
            issue: LayerIssueServerModel(
                comment: nil,
                is_hidden: false,
                issue: "cropping"
            ),
            previews: [
                PreviewImageServerModel(
                    url: "url3",
                    layer: "Layer3",
                    height: 120,
                    width: 220
                )
            ]
        )],
        source_type: nil,
        field_id: 103
    )
    
    public static let fieldImage4 = FieldImageServerModel(
        bounds: ImageBoundsServerModel(
            boundsLeft: 18.0,
            boundsBottom: 28.0,
            boundsRight: 38.0,
            boundsTop: 48.0
        ),
        date: Timestamp(date: Date(timeIntervalSinceNow: -(10*60*60))), //10 hours before
        id: 4,
        layers: ["ndvi": LayerImageServerModel(
            issue: LayerIssueServerModel(
                comment: "Comment4",
                is_hidden: true,
                issue: "waves"
            ),
            previews: [
                PreviewImageServerModel(
                    url: "url4",
                    layer: "Layer4",
                    height: 180,
                    width: 280
                )
            ]
        )],
        source_type: "Type4",
        field_id: 103
    )
    
    public static let fieldImage5 = FieldImageServerModel(
        bounds: ImageBoundsServerModel(
            boundsLeft: 13.0,
            boundsBottom: 23.0,
            boundsRight: 33.0,
            boundsTop: 43.0
        ),
        date: Timestamp(date: Date()),
        id: 5,
        layers: ["rgb": LayerImageServerModel(
            issue: LayerIssueServerModel(
                comment: "Comment5",
                is_hidden: false,
                issue: "empty"
            ),
            previews: [
                PreviewImageServerModel(
                    url: "url5",
                    layer: "Layer5",
                    height: 130,
                    width: 230
                )
            ]
        )],
        source_type: "Type5",
        field_id: 104
    )
    
    
    private static let mockSpatialImage = SpatialImage(
        height: 200,
        width: 300,
        url: "https://example.com/image.jpg",
        bounds: ImageBounds(
            boundsLeft: 0.0,
            boundsBottom: 0.0,
            boundsRight: 100.0,
            boundsTop: 100.0
        )
    )
    
    public static var mockField: Field {
        Field(
            id: 1,
            country: "YourCountry",
            name: "Field A",
            farmName: "Farm XYZ",
            dateUpdated: Date(),
            imageGroups: [mockFieldImageGroip],
            coverImage: mockSpatialImage,
            region: Region.local,
            farmId: 123,
            filters: fakeFieldFilters,
            subscriptionTypes: []
        )
    }
  
  public static var mockField1: Field {
      Field(
          id: 1,
          country: "YourCountry",
          name: "Field A",
          farmName: "Farm XY",
          dateUpdated: Date(),
          imageGroups: [mockFieldImageGroip],
          coverImage: mockSpatialImage,
          region: Region.local,
          farmId: 123,
          filters: fakeFieldFilters,
          subscriptionTypes: []
      )
  }
    
    public static let mockFieldImageGroip = FieldImageGroup(fieldId: 1, fieldName: "field_name", imageryMainImage: "imageryMainImage", imageryMainType: .ndvi, date: Date(), bounds: ImageBounds(boundsLeft: 50.0, boundsBottom: 50.0, boundsRight: 50.0, boundsTop: 50.0), imagesByLayer: [.ndvi : [PreviewImage(url: "url", height: 50, width: 50, imageId: 1, issue: nil)]], region: Region.local, sourceType: .satellite)
    
    
    public static let mockInsightMetadata = InsightMetadataServerModel(
        aggregation_unit: "acre",
        crop: "potato",
        start_date: 123,
        end_date: 456,
        relative_to_last_report: 789,
        scanned_area_percent: 50,
        tagged_images_percent: 75,
        goal_stand_count: 100.0,
        cover_image: [ImageSpatialServerModel](),
        items: [LocationInsightItemServerModel](),
        enhanced_data: nil,
        avg_stand_count: 42,
        first_detection_data: FirstDetectionDataServerModel(image_date: 1, full_report_data: 1)
    )
    
    public static var mockInsightServerModel: InsightServerModel {
        InsightServerModel(
            id: 1,
            type: "singleLocationInsight",
            field_id: 1,
            field_name: "Field A",
            i18n_field_name: LocalizeString(token: "field_token", params: nil),
            farm_name: "Farm XYZ",
            farm_id: 0,
            subject: "Your Subject",
            i18n_subject: LocalizeString(token: "subject_token", params: nil),
            description: "Your Description",
            i18n_description: LocalizeString(token: "description_token", params: nil),
            tags_area: 50.0,
            ts_published: Timestamp(date: Date(timeIntervalSinceNow: -(60*60))), // 1 hour ago
            time_zone: "UTC",
            uid: "unique_id",
            images: [InsightImageServerModel](),
            tags: [InsightTagServerModel](),
            metadata: mockInsightMetadata,
            category: "irrigation", subcategory: "detection",
            highlight: nil,
            cycle_id: nil,
            publication_year: 2024, field_country: "US"
        )
    }
    
    public static var mockWelcomInsightServerModel: InsightServerModel {
        InsightServerModel(
            id: 1,
            type: "singleLocationInsight",
            field_id: 1,
            field_name: "Field A",
            i18n_field_name: LocalizeString(token: "field_token", params: nil),
            farm_name: "Farm XYZ",
            farm_id: 0,
            subject: "Your Subject",
            i18n_subject: LocalizeString(token: "subject_token", params: nil),
            description: "Your Description",
            i18n_description: LocalizeString(token: "description_token", params: nil),
            tags_area: 50.0,
            ts_published: Timestamp(date: Date(timeIntervalSinceNow: -(60*60))), // 1 hour ago
            time_zone: "UTC",
            uid: "WELCOME",
            images: [InsightImageServerModel](),
            tags: [InsightTagServerModel](),
            metadata: mockInsightMetadata,
            category: "irrigation",
            subcategory: "detection",
            field_country: "US"
        )
    }
    
    public static var mockLocationInsightItem1: LocationInsightItem {
        LocationInsightItem(id: 1, name: "name", description: "description", taggedImagesPercent: 10, displayedValue: nil, minRange: 1, maxRange: 2, enhanceData: nil)
    }
    
    public static var mockLocations1: Location {
        Location(id: 1, issuesIds: [1], latitude: 10.0, longitude: 10.0, images: [])
    }
    
    public static var mockMappedInsight1: Insight {
        Insight(
            id: 1,
            uid: "uid",
            type: "type",
            subject: "subject",
            fieldId: 101,
            fieldName: "field_name",
            farmName: "farm_name",
            farmId: 0,
            description: "description",
            publishDate: Date(),
            affectedArea: 50.0,
            affectedAreaUnit: "acres",
            isRead: false,
            tsFirstRead: nil,
            timeZone: "time_zone",
            thumbnail: "thumbnail_url",
            category: "irrigation",
            subCategory: "detection",
            displayName: "Irrigation",
            highlight: "",
            cycleId: nil,
            publicationYear: 2024
        )
    }
    
    public static var mockMappedInsight2: Insight {
        Insight(
            id: 2,
            uid: "uid",
            type: "type",
            subject: "subject",
            fieldId: 101,
            fieldName: "field_name",
            farmName: "farm_name",
            farmId: 0,
            description: "description",
            publishDate: Date(timeIntervalSinceNow: -60),
            affectedArea: 50.0,
            affectedAreaUnit: "acres",
            isRead: false,
            tsFirstRead: nil,
            timeZone: "time_zone",
            thumbnail: "thumbnail_url",
            category: "irrigation",
            subCategory: "detection",
            displayName: "Irrigation",
            highlight: "",
            cycleId: nil,
            publicationYear: 2023
        )
    }
    
    public static var mockMappedInsight3: Insight {
        Insight(
            id: 3,
            uid: "uid",
            type: "type",
            subject: "subject",
            fieldId: 101,
            fieldName: "field_name",
            farmName: "farm_name",
            farmId: 0,
            description: "description",
            publishDate: Date(timeIntervalSinceNow: -60),
            affectedArea: 50.0,
            affectedAreaUnit: "acres",
            isRead: false,
            tsFirstRead: nil,
            timeZone: "time_zone",
            thumbnail: "thumbnail_url",
            category: "canopy_cover",
            subCategory: "detection",
            displayName: "Irrigation",
            highlight: "",
            cycleId: nil,
            publicationYear: 2024
        )
    }
    
    public static var mockMappedLocationInsight1: EnhancedLocationInsight {
        EnhancedLocationInsight(id: 4,
                                uid: "uid",
                                type: "type",
                                subject: "subject",
                                fieldId: 101,
                                fieldName: "field_name",
                                farmName: "farm_name",
                                farmId: 0,
                                description: "description",
                                publishDate: Date(timeIntervalSinceNow: -60),
                                affectedArea: 50.0,
                                affectedAreaUnit: "acres",
                                isRead: false,
                                tsFirstRead: nil,
                                timeZone: "time_zone",
                                thumbnail: "thumbnail_url",
                                startDate: Date(timeIntervalSinceNow: -60),
                                endDate:
                                    Date(),
                                scannedAreaPercent: 10,
                                taggedImagesPercent: 10,
                                relativeToLastReport: nil,
                                coverImage: [],
                                items: [mockLocationInsightItem1],
                                aggregationUnit: nil,
                                region: Region.local,
                                enhanceData: LocationInsightEnhanceData(title: "title", subtitle: "subtitle", locationsAggValue: nil, locationsAggName: "agg_name", isSeverity: false, ranges: LocationInsightRange(title: "title", midtitle: "midttle", subtitle: "subtitle", levels: [])),
                                category: "canopy_cover",
                                subCategory: "enhanced_detection",
                                displayName: "Canopy Cover", 
                                summery: "summery",
                                highlight: "",
                                cycleId: 2,
                                publicationYear: 2024)

    }
    
    private static func buildFakeFieldServerModelFitlers() -> [FieldFilterServerModel] {
        let filter1 = FieldFilterServerModel(
            order: 0,
            i18n_name: LocalizeString(token: "wheat_cycle_filter_display_name", params: ["season":"2024"]), name: "default_text",
            criteria: [
                FieldFilterCriterionServerModel(
                    collection: "insights",
                    filter_by: [
                        FieldFilterByServerModel(property: "cycle_id", value: .int(1234))
                    ]
                ),
                FieldFilterCriterionServerModel(
                    collection: "images",
                    filter_by: [
                        FieldFilterByServerModel(property: "season", value: .int(2024)),
                    ]
                )
            ]
        )
        
        let filter2 = FieldFilterServerModel(
            order: 1,
            i18n_name: LocalizeString(token: "corn_cycle_filter_display_name", params: ["season":"2023"]), name: "default_text",
            criteria: [
                FieldFilterCriterionServerModel(
                    collection: "insights",
                    filter_by: [
                        FieldFilterByServerModel(property: "cycle_id", value: .int(5678))
                    ]
                ),
                FieldFilterCriterionServerModel(
                    collection: "insights",
                    filter_by: [
                        FieldFilterByServerModel(property: "publication_year", value: .int(2023)),
                        FieldFilterByServerModel(property: "category", value: .string("irrigation"))
                    ]
                )
            ]
        )
        
        let filter3 = FieldFilterServerModel(
            order: 2,
            i18n_name: LocalizeString(token: "free_text", params: ["text":"2022"]), name: "default_text",
            criteria: [
                FieldFilterCriterionServerModel(
                    collection: "insights",
                    filter_by: [
                        FieldFilterByServerModel(property: "publication_year", value: .int(2022)),
                        FieldFilterByServerModel(property: "category", value: .string("irrigation"))
                    ]
                )
            ]
        )
        
        return [filter1, filter2, filter3]
    }
    
    private static func buildFakeFieldFitlers() -> [FieldFilter] {
        let filter1 = FieldFilter(
            order: 0,
            name: "Wheat 2024",
            criteria: [
                FilterCriterion(
                    collection: "insights",
                    filterBy: [FilterBy(property: "cycle_id", value: .int(1234))]
                ),
                FilterCriterion(
                    collection: "images",
                    filterBy: [FilterBy(property: "season", value: .int(2024))]
                )
            ]
        )
        
        let filter2 = FieldFilter(
            order: 1,
            name: "Corn 2023",
            criteria: [
                FilterCriterion(
                    collection: "insights",
                    filterBy: [FilterBy(property: "cycle_id", value: .int(5678))]
                ),
                FilterCriterion(
                    collection: "insights",
                    filterBy: [
                        FilterBy(property: "publication_year", value: .int(2023)),
                        FilterBy(property: "category", value: .string("irrigation"))
                    ]
                )
            ]
        )
        
        let filter3 = FieldFilter(
            order: 2,
            name: "2022",
            criteria: [
                FilterCriterion(
                    collection: "insights",
                    filterBy: [
                        FilterBy(property: "publication_year", value: .int(2022)),
                        FilterBy(property: "category", value: .string("irrigation"))
                    ]
                )
            ]
        )
        
        return [filter1, filter2, filter3]
    }
    
}
