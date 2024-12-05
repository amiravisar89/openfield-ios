//
//  Mappers+Injection.swift
//  Openfield
//
//  Created by amir avisar on 07/10/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import Resolver

extension Resolver {
    static func registerMappers() {
        register { ChipConfigModelMapper(translationService: resolve()) }.scope(application)
        register { SingleLocationInsightModelMapper(locationInsightModelMapper: resolve()) }.scope(application)
        register { UserRoleConfigurationModellMapper() }.scope(application)
        register { ContracsMapper() }
        register { UnitByCountryModelMapper(translationService: resolve()) }.scope(application)
        register { InsightConfigurationModellMapper(translationService: resolve(), chipConfigModelMapper: resolve()) }.scope(application)
        register { UserModelMapper() }.scope(application)
        register { FieldModelMapper(translationService: resolve()) }.scope(application)
        register { FieldLastReadMapper() }
        register { LocationInsightModelMapper() }.scope(application)
        register { EmptyLocationInsightModelMapper(locationInsightModelMapper: resolve()) }.scope(application)
        register { EnhancedLocationInsightModelMapper(locationInsightModelMapper: resolve()) }.scope(application)
        register { RangedLocationInsightModelMapper(locationInsightModelMapper: resolve()) }.scope(application)
        register { IssueLocationInsightModelMapper(locationInsightModelMapper: resolve()) }.scope(application)
        register { IrrigationInsightModelMapper() }.scope(application)
        register { ExtUserModelMapper() }.scope(application)
        register { InsightModelMapper(translationService: resolve(), singleLocationInsightMapper: resolve(), enhancedLocationInsightMapper: resolve(), issueLocationInsightMapper: resolve(), rangedLocationInsightMapper: resolve(), emptyLocationInsightMapper: resolve(), irrigationInsightModelMapper: resolve()) }.scope(application)
        register {
            let featureFlagRepository: FeatureFlagsRepository = resolve()
            let nightImagesFeatureFlag: NightImagesFeatureFlag = resolve()
            return LocationModelMapper(featureFlagRepository: featureFlagRepository, nightImagesFeatureFlag: nightImagesFeatureFlag)
        }
        register {
            let dateProvider: DateProvider = resolve()
            let getSupportedInsightUseCase : GetSupportedInsightUseCase = resolve()
            return CategoriesUiMapper(dateProvider: dateProvider, locationInsightCoardinateProvider: resolve(), getSupportedInsightUseCase: getSupportedInsightUseCase)
        }
        
        register {
            let dateProvider: DateProvider = resolve()
            return FieldImageryUiMapper(dateProvider: dateProvider)
        }
        
        register {
            let fieldIrrigationLimitUseCase : GetFieldIrrigationLimitUseCase = resolve()
            return FieldIrrigationUiMapper(dateProvider: resolve(), getFieldIrrigationLimitUseCase: fieldIrrigationLimitUseCase)
        }
        
        register {
            return AppGalleyUiMapper()
        }
        
        register {
            return AppCalendarUiMapper(dateProvider: resolve())
        }
        register {
            return FieldSeasonsListUiMapper()
        }
        register {
            return VirtualScoutingModelsMapper(dateProvider: resolve())
        }
    }
}
