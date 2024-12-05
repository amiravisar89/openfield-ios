//
//  InsightModelMapper.swift
//  Openfield
//
//  Created by Itay Kaplan on 24/12/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

enum ShareStrategy: String {
    case share = "share"
    case shapeFile = "shape_file"
}

enum CategoryImageStrategy: String {
    case map = "map"
    case infestationMap = "infestation_map"
    case coverImage = "cover_image"
    case none = "none"
}

enum InsightType: String {
    case singleLocationInsight
    case enhancedLocationInsight
    case issueLocationInsight
    case rangedLocationInsight
    case emptyLocationInsight
    case irrigationInsight
    case welccome = "default"
}

enum InsightModelMapperError: Error {
    case unsupportedInsightType(description: String)
}

class InsightModelMapper: InsightModelMapperProtocol {
    let translationService: TranslationService
    let singleLocationInsightMapper: SingleLocationInsightModelMapper
    let enhancedLocationInsightMapper: EnhancedLocationInsightModelMapper
    let issueLocationInsightMapper: IssueLocationInsightModelMapper
    let rangedLocationInsightMapper: RangedLocationInsightModelMapper
    let emptyLocationInsightMapper: EmptyLocationInsightModelMapper
    let irrigationInsightModelMapper: IrrigationInsightModelMapper

    init(translationService: TranslationService,
         singleLocationInsightMapper: SingleLocationInsightModelMapper,
         enhancedLocationInsightMapper: EnhancedLocationInsightModelMapper,
         issueLocationInsightMapper: IssueLocationInsightModelMapper,
         rangedLocationInsightMapper: RangedLocationInsightModelMapper,
         emptyLocationInsightMapper: EmptyLocationInsightModelMapper,
         irrigationInsightModelMapper: IrrigationInsightModelMapper)
    {
        self.translationService = translationService
        self.singleLocationInsightMapper = singleLocationInsightMapper
        self.enhancedLocationInsightMapper = enhancedLocationInsightMapper
        self.emptyLocationInsightMapper = emptyLocationInsightMapper
        self.issueLocationInsightMapper = issueLocationInsightMapper
        self.rangedLocationInsightMapper = rangedLocationInsightMapper
        self.irrigationInsightModelMapper = irrigationInsightModelMapper
    }

    func map(insightConfiguration: InsightConfiguration, insightServerModel: InsightServerModel, userInsight: UserInsight?, unitByCountry: UnitsByCountry) throws -> Insight? {
        
        guard let appTypeConfig = insightConfiguration.appTypes[insightServerModel.subcategory] else {
            throw InsightModelMapperError.unsupportedInsightType(description: "Unsupported Insight Sub Category: \(insightServerModel.subcategory). For insight - \(insightServerModel.uid)")
        }

        switch appTypeConfig.appType {
        case .singleLocationInsight:
            return try singleLocationInsightMapper.map(insightServerModel: insightServerModel, insightConfiguration: insightConfiguration, userInsight: userInsight, translationService: translationService, unitsByCountry: unitByCountry)

        case .enhancedLocationInsight:
            return try enhancedLocationInsightMapper.map(insightServerModel: insightServerModel, insightConfiguration: insightConfiguration, userInsight: userInsight, translationService: translationService, unitsByCountry: unitByCountry)

        case .issueLocationInsight:
            return try issueLocationInsightMapper.map(insightServerModel: insightServerModel, insightConfiguration: insightConfiguration, userInsight: userInsight, translationService: translationService, unitsByCountry: unitByCountry)

        case .rangedLocationInsight:
            return try rangedLocationInsightMapper.map(insightServerModel: insightServerModel, insightConfiguration: insightConfiguration, userInsight: userInsight, translationService: translationService, unitsByCountry: unitByCountry)

        case .emptyLocationInsight:
            return try emptyLocationInsightMapper.map(insightServerModel: insightServerModel, insightConfiguration: insightConfiguration, userInsight: userInsight, translationService: translationService, unitsByCountry: unitByCountry)

        case .irrigationInsight, .welccome:
            return try irrigationInsightModelMapper.map(insightServerModel: insightServerModel, userInsight: userInsight, translationService: translationService, unitsByCountry: unitByCountry, insightConfiguration: insightConfiguration)
        }
    }
}
