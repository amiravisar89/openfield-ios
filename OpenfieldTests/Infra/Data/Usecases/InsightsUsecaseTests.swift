//
//  InsightsUsecaseTests.swift
//  OpenfieldTests
//
//  Created by Yoni Luz on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//
import XCTest
import Cuckoo
import RxSwift
import Resolver
import Firebase
import SwiftDate

@testable import Openfield

final class InsightsUsecaseTests: XCTestCase {
    
    private var mockUserStreamUsecase: MockUserStreamUsecaseProtocol!
    private var mockGetSupportedInsights: MockGetSupportedInsightUseCaseProtocol!
    private var mockGetUnitsByCountry : MockGetUnitByCountryUseCaseProtocol!
    private var mockInsightMapper: InsightModelMapper = Resolver.resolve()
    
    private var insightsUsecase: InsightsUsecase!
    
    override func setUpWithError() throws {
        mockUserStreamUsecase = MockUserStreamUsecaseProtocol()
        mockGetSupportedInsights = MockGetSupportedInsightUseCaseProtocol()
        mockGetUnitsByCountry = MockGetUnitByCountryUseCaseProtocol()
        insightsUsecase = InsightsUsecase(
            userStreamUsecase: mockUserStreamUsecase,
            insightMapper: mockInsightMapper,
            getSupportedInsightUseCase : mockGetSupportedInsights,
            getUnitByCountryUseCase :mockGetUnitsByCountry
        )
    }
    
    override func tearDownWithError() throws {
        mockUserStreamUsecase = nil
        insightsUsecase = nil
    }
    
    func testGetInsightsOutputIsCorrect() throws {
        // Set up mock data and expectations
        let mockUser = UserStreamUsecaseTests.expectedUser
        let mockFields = [MockObjects.mockField]
        let mockInsightsSMList = [MockObjects.mockInsightServerModel]
        let mockWelcomeInsightsSMList = [MockObjects.mockWelcomInsightServerModel]
        
        // Stub the necessary methods of mocks
        stub(mockUserStreamUsecase) { mock in
            when(mock.userStream()).thenReturn(Observable.just(mockUser))
        }
        
        stub(mockGetSupportedInsights) { mock in
            when(mock.supportedInsights()).thenReturn(mockInsightConfiguration)
        }
        
        stub(mockGetUnitsByCountry) { mock in
            when(mock.unitByCountry()).thenReturn(mockUnitsByCountry)
        }
        
        // Act
        var receivedInsights: [Insight]?
        let disposeBag = DisposeBag()
        _ = insightsUsecase.generateInsights(insightsStream: Observable.just(mockInsightsSMList)).subscribe(onNext: { insights in
            receivedInsights = insights
        })
        .disposed(by: disposeBag)
        
        // Assert
        XCTAssertNotNil(receivedInsights)
        XCTAssertEqual(receivedInsights!.count, 1) //There is only one insight since the user is not in panda so we removed the WELCOME insight
        XCTAssertTrue(receivedInsights![0] is SingleLocationInsight)
    }
    
    let mockSpatialImage = SpatialImage(
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
    
    var mockField: Field {
        Field(
            id: 1,
            country: "YourCountry",
            name: "Field A",
            farmName: "Farm XYZ",
            dateUpdated: Date(),
            imageGroups: [FieldImageGroup](),
            coverImage: mockSpatialImage,
            region: Region.local,
            farmId: 123,
            filters: MockObjects.fakeFieldFilters,
            subscriptionTypes: []
        )
    }
    
    let mockInsightMetadata = InsightMetadataServerModel(
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
    
    var mockInsightServerModel: InsightServerModel {
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
            category: "irrigation",
            subcategory: "detection",
            field_country: "US"
        )
    }
    
    var mockWelcomInsightServerModel: InsightServerModel {
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
            category: "irrigation", subcategory: "detection", field_country: "US"
        )
    }
    
    let mockDisplayName = DisplayName(
        title: "Title"
    )
    
    let mockInsightExplanationText = InsightExplenationText(
        title: "Title",
        subTitle: "SubTitle"
    )
    
    var mockInsightConfiguration: [String: InsightConfiguration] {
        ["irrigation" : InsightConfiguration(
            appTypes: ["detection": AppTypeConfig(appType: .singleLocationInsight, chipsConfig: nil, shareStrategies: [])],
            thumbnailUrl: "https://vi-apps.prospera.ag/assets/plant-insights/canopy_cover_feed_item.png",
            insightExplanation: [mockInsightExplanationText],
            insightDisplayName: mockDisplayName, categoryImageStrategy: .infestationMap
        )]
    }
    
    let mockAreaUnits = AreaUnits(
        unit: "acre",
        acreRelativeMultiplyFactor: 1.5
    )
    
    // Using mockAreaUnits in the test
    var mockUnitsByCountry: UnitsByCountry {
        UnitsByCountry(
            areaUnits: ["YourCountry": mockAreaUnits]
        )
    }
    
    var mockMappedInsight: Insight {
        Insight(
            id: 1,
            uid: "uid",
            type: "type",
            subject: "subject",
            fieldId: 1,
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
            highlight: nil,
            cycleId: 1,
            publicationYear: 2024
        )
    }
    
}
