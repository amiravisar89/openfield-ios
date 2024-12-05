//
//  GetCategoriesCellUsecase.swift
//  Openfield
//
//  Created by amir avisar on 04/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class CategoriesUiMapper {
    
    private var dateProvider: DateProvider
    private var locationInsightCoardinateProvider : LocationInsightCoordinatesProvider
    private let getSupportedInsightUseCase : GetSupportedInsightUseCaseProtocol


    init(dateProvider: DateProvider, locationInsightCoardinateProvider : LocationInsightCoordinatesProvider,
        getSupportedInsightUseCase : GetSupportedInsightUseCaseProtocol) {
        self.dateProvider = dateProvider
        self.locationInsightCoardinateProvider = locationInsightCoardinateProvider
        self.getSupportedInsightUseCase = getSupportedInsightUseCase
    }
    
    func cell(insightCategory: InsightCategory) -> FieldCategoryCellUiElement? {
        let insight = insightCategory.insight
        let imageStrategy = getSupportedInsightUseCase.supportedInsights()[insightCategory.categoryId]?.categoryImageStrategy ?? .none
        let imageMetaData = self.getImageMetadata(insightCategory: insightCategory)
        let coordinateLocations = locationInsightCoardinateProvider.provide(locationInsight: insight, locations: insightCategory.locations, index: .zero)
        return FieldCategoryCellUiElement(insightUid: insight.uid ,read: insight.isRead, title: insight.displayName, date: dateProvider.daysTimeAgoSince(insightCategory.date), content: getInsigntsText(insight: insight), highlighted: insight.highlight != nil, highlightedText: insight.highlight, images: imageMetaData?.previews ?? [], tags: imageMetaData?.tags ?? [] ,tagColor: R.color.enhancedLocationColor()!, locations: coordinateLocations, coverImage: insight.coverImage, imageStrategy: imageStrategy, trend: insight.relativeToLastReport, summery: insight.summery)
    }
    
    private func getImageMetadata(insightCategory: InsightCategory) -> LocationImageMeatadata? {
        guard let firstLocation = insightCategory.locations.filter({!$0.images.isEmpty}).first else {return nil}
        return firstLocation.images.first
    }
    
    private func getInsigntsText(insight: Insight) -> String? {
        switch(insight) {
        case is EnhancedLocationInsight:
            let names = (insight as! EnhancedLocationInsight).items.map { $0.enhanceData?.title ?? "" }.filter { !$0.isEmpty }
            return names.joined(separator: ", ")
        default:
            return nil
        }
    }
}

