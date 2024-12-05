//
//  Data+Injection.swift
//  Openfield
//
//  Created by Daniel Kochavi on 30/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import CodableFirebase
import Fakery
import Firebase
import Resolver
import SwiftyUserDefaults
import LaunchDarkly
import FirebaseRemoteConfig

extension Resolver {
    static func registerData() {
        if ConfigEnvironment.boolValueFor(key: .useMock) {
            let faker = Faker()
            let arges = [faker.number.randomInt(min: 50, max: 100),
                         faker.number.randomInt(min: 50, max: 100),
                         faker.number.randomInt(min: 50, max: 100)]
            register { MockDataRepository(mockData: resolve(args: arges), faker: faker) as DataRepository }.scope(application)

            register { _, arg -> MockData in
                if let args = arg as? [Any], args.count == 3 {
                    let insightCount = args[0] as? Int ?? 10
                    let imageryCount = args[1] as? Int ?? 10
                    return MockData(insightCount: insightCount, imageryCount: imageryCount, fieldFaker: resolve(), imageryFaker: resolve(), userFaker: resolve(), insightFaker: resolve(), farmFaker: resolve(), contractsFaker: resolve())
                }
                return MockData(insightCount: 10, imageryCount: 10, fieldFaker: resolve(), imageryFaker: resolve(), userFaker: resolve(), insightFaker: resolve(), farmFaker: resolve(), contractsFaker: resolve())

            }.scope(application)
        } 

        register { FirestoreDecoder() }.scope(application)
        register { FieldsFaker(faker: Faker()) }.scope(application)
        register { InsightFaker(faker: Faker(), fieldFaker: resolve()) }.scope(application)
        register { ImageryFaker(faker: Faker()) }.scope(application)
        register { ContractsFaker(faker: Faker()) }.scope(application)
        register { UserFaker(faker: Faker()) }.scope(application)
        register { FarmFaker(faker: Faker()) }.scope(application)
        register { FeatureFlagsRepository(ldClient: Resolver.optional()) }
        register {
            UserRepository(userID: Defaults.userId, db: main.resolve(), decoder: main.resolve())
        }
        register {
            FieldsRepository(userID: Defaults.userId, db: main.resolve(), decoder: main.resolve())
        }
        register {
            FieldRepository(userID: Defaults.userId, db: main.resolve(), decoder: main.resolve())
        }
        register {
            InsightsRepository(userID: Defaults.userId, db: main.resolve(), decoder: main.resolve())
        }
        register {
            VirtualScoutingRepository(userID: Defaults.userId, db: main.resolve(), decoder: main.resolve())
        }
        register {
            let fieldsRepo: FieldsRepository = resolve()
            return FieldsUsecase(fieldsRepo: fieldsRepo, fieldMapper: resolve())
        }
        register {
            let fieldsRepo: FieldRepository = resolve()
            return FieldUseCase(fieldRepo: fieldsRepo, fieldMapper: resolve())
        }
        register {
            let fieldsRepo: FieldsRepository = resolve()
            return FieldLastReadUsecase(fieldsRepo: fieldsRepo, fieldLastReadMapper: resolve())
        }
        register {
            let userRepo: UserRepository = resolve()
            return UserStreamUsecase(userRepository: userRepo, userMapper: resolve())
        }
        
        register {
            let fieldRepo: FieldRepository = resolve()
            return IsUserFieldOwnerUsecase(fieldRepo: fieldRepo)
        }
        register {
            let userStreamUsecase: UserStreamUsecase = resolve()
            let insightMapper: InsightModelMapper = resolve()
            let getSupportedInsightUseCase : GetSupportedInsightUseCase = resolve()
            let getUnitByCountryUseCase : GetUnitByCountryUseCase = resolve()

            return InsightsUsecase(userStreamUsecase: userStreamUsecase, insightMapper: insightMapper, getSupportedInsightUseCase: getSupportedInsightUseCase, getUnitByCountryUseCase: getUnitByCountryUseCase)
        }
        register {
            let insightsRepo: InsightsRepository = resolve()
            return LocationsFromInsightUsecase(jsonDecoder: resolve(), insightsRepo: insightsRepo, locationsMapper: resolve())
        }
        register {
            let insightsRepo: InsightsRepository = resolve()
            let insightsUsecase: InsightsUsecase = resolve()
            return GetSingleInsightUsecase(insightsRepo: insightsRepo, insightsUsecase: insightsUsecase) 
        }
        register {
            let insightsRepo: InsightsRepository = resolve()
            let insightsUsecase: InsightsUsecase = resolve()
            return InsightsFromDateUsecase(insightsRepo: insightsRepo, insightsUsecase: insightsUsecase)
        }
        register {
            let insightsRepo: InsightsRepository = resolve()
            let insightsUsecase: InsightsUsecase = resolve()
            return InsightsForFieldUsecase(insightsRepo: insightsRepo, insightsUsecase: insightsUsecase)
        }
        register {
            let insightUsecase: InsightsForFieldUsecase = resolve()
            return LatestInsightPerCategoryUsecase(insightForFieldUsecase: insightUsecase)
        }
        register {
            let locationsFromInsightUsecase: LocationsFromInsightUsecase = resolve()
            let insightsPerCategoryUsecase: LatestInsightPerCategoryUsecase = resolve()
            return GetCategoriesUsecase(locationsFromInsightUsecase: locationsFromInsightUsecase, insightsPerCategoryUsecase: insightsPerCategoryUsecase)
        }

        register {
            let fieldUseCase : FieldUseCase = resolve()
            let fieldRepo: FieldRepository = resolve()
            return GetFieldImageryUsecase(fieldRepo: fieldRepo, fieldMapper: resolve(), fieldUseCase: fieldUseCase)
        }
        
        register {
            let insightsForFieldUsecase : InsightsForFieldUsecase = resolve()
            let fieldIrrigationLimitUseCase : GetFieldIrrigationLimitUseCase = resolve()
            return GetFieldIrrigationUsecase(InsightsForFieldUsecase: insightsForFieldUsecase, getFieldIrrigationLimitUseCase: fieldIrrigationLimitUseCase)
        }
        
        register {
            let insightsRepository : InsightsRepository = resolve()
            let insightsUseCase : InsightsUsecase = resolve()
            return InsightsFromFieldAndCategoryUsecase(insightsRepo: insightsRepository, insightsUsecase: insightsUseCase)
        }
        register {
            let insightsRepository : InsightsRepository = resolve()
            let insightsUseCase : InsightsUsecase = resolve()
            return WelcomInsightsUsecase(insightsRepo: insightsRepository, insightsUsecase: insightsUseCase)
        }
        register {
            let languageService: LanguageService = resolve()
            let featureFlagRepository: FeatureFlagsRepository = resolve()
            let requestReportFeatureFlag: RequestReportFeatureFlag = resolve()
            let getRequestReportUrlUseCase : GetRequestReportUrlUseCase = resolve()
            let getRequestReportStartYearUseCase : GetRequestReportStartYearUseCase = resolve()
            return RequestReportLinkUsecase(languageService: languageService, featureFlagRepository: featureFlagRepository,requestReportFeatureFlag: requestReportFeatureFlag, getRequestReportUrlUseCase: getRequestReportUrlUseCase, getRequestReportStartYearUseCase: getRequestReportStartYearUseCase)
        }
        register {
            let featureFlagRepository: FeatureFlagsRepository = resolve()
            let virtualScoutingFeatureFlag: VirtualScoutingFeatureFlag = resolve()
            let virtualScoutingDatesUseCase: VirtualScoutingDatesUseCase = resolve()
            let getVirtualScoutingStartYearUseCase: GetVirtualScoutingStartYearUseCase = resolve()
            return VirtualScoutingStateUsecase(featureFlagRepository: featureFlagRepository, virtualScoutingFeatureFlag: virtualScoutingFeatureFlag, virtualScoutingDatesUseCase: virtualScoutingDatesUseCase, getVirtualScoutingStartYearUseCase: getVirtualScoutingStartYearUseCase)
        }
        
        register {
            let virtualScoutingRepository: VirtualScoutingRepository = resolve()
            return VirtualScoutingGridUsecase(virtualScoutingRepository: virtualScoutingRepository, virtualScoutingModelsMapper: resolve())
        }
        
        register {
            let virtualScoutingRepository: VirtualScoutingRepository = resolve()
            return VirtualScoutingDatesUseCase(virtualScoutingRepository: virtualScoutingRepository, virtualScoutingModelsMapper: resolve())
        }
        
        register {
            let virtualScoutingRepository: VirtualScoutingRepository = resolve()
            return VirtualScoutingImagesUsecase(virtualScoutingRepository: virtualScoutingRepository)
        }
        register {
          let fieldsUsecase: FieldsUsecase = resolve()
          return GetAllFarmsUseCase(fieldsUseCase: fieldsUsecase)
        }
        register {
          let fieldsUsecase: FieldsUsecase = resolve()
          let getFeedMinDateUseCase : GetFeedMinDateUseCase = resolve()
          return GetImageryUsecase(fieldsUseCase: fieldsUsecase, getFeedMinDateUseCase: getFeedMinDateUseCase)
        }
        register {
          let firestore: Firestore = main.resolve()
          let userId: Int = Defaults.userId
          return UpdateUserParamsUsecase(userId: userId, firestore: firestore)
        }
        register { JSONDecoder() }
        register { LDClient.get() }
        register { RequestReportFeatureFlag() }
        register { VirtualScoutingFeatureFlag() }
        register { ImpersonationFeatureFlag() }
        register { NightImagesFeatureFlag() }
    }
}
