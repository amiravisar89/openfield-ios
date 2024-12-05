//
//  Reactor+Injection.swift
//  Openfield
//
//  Created by Daniel Kochavi on 19/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Resolver

extension Resolver {
    static func registerReactors() {
        register { AppWalkthroughViewReactor(contractsProvider: resolve()) }
        register {
            let getSupportUrlUseCase : GetSupportUrlUseCase = resolve()
            let updateUseParamsUsecase : UpdateUserParamsUsecase = resolve()
            return SignContractViewReactor(contractsProvider: resolve(), getSupportUrlUseCase: getSupportUrlUseCase, updateUseParamsUsecase: updateUseParamsUsecase)
        }
        register {
            let getSupportUrlUseCase : GetSupportUrlUseCase = resolve()
            return WelcomeViewReactor(languageService: resolve(), getSupportUrlUseCase: getSupportUrlUseCase)
        }
        register {
          let featureFlagRepository: FeatureFlagsRepository = resolve()
          let impersonationFeatureFlag: ImpersonationFeatureFlag = resolve()
          let updateUserParamsUsecase : UpdateUserParamsUsecase = resolve()
          return LoginViewReactor(smartLookProvider: resolve(), authAdapter: resolve(), authInteractor: resolve(), featureFlagManager: resolve(),   featureFlagRepository: featureFlagRepository, impersonationFeatureFlag: impersonationFeatureFlag, updateUserParamsUsecase: updateUserParamsUsecase)
        }
        register {
            let getHelpCenterUrlUseCase : GetHelpCenterUrlUseCase = resolve()
            let userStream : UserStreamUsecase = resolve()
            let updateUserParamsUsecase : UpdateUserParamsUsecase = resolve()
          return AccountViewReactor(authInteractor: resolve(), languageService: resolve(), userUseCase: userStream, updateUserParamsUsecase: updateUserParamsUsecase, getHelpCenterUrlUseCase: getHelpCenterUrlUseCase)
        }
        register { _, arg -> AnalysisReactor in
            guard let args = arg as? AnalysisParams else { fatalError("Unable to start \(AnalysisReactor.self)") }
            let insightsByField: InsightsForFieldUsecase = resolve()
            let fieldUseCase : FieldUseCase = resolve()
            return AnalysisReactor(params: args, insightsByField: insightsByField, fieldUseCase: fieldUseCase)
        }
        
        register { _, arg -> InsightViewReactor in
            guard let args = arg as? [Any] else { fatalError("Missing arguments for \(InsightViewReactor.self)") }
            guard let insightUid = args[0] as? String else { fatalError("Missing insightUid for \(InsightViewReactor.self)") }
            guard let origin = args[1] as? String else { fatalError("Missing origin for \(InsightViewReactor.self)") }
            let getSingleInsightUsease : GetSingleInsightUsecase = resolve()
            let insightsForFieldUsecase : InsightsForFieldUsecase = resolve()
            let fieldUseCase : FieldUseCase = resolve()
            let userUseCase: UserStreamUsecase = resolve()
            let dateProvider: DateProvider = resolve()
            let updateUserParamsUsecase : UpdateUserParamsUsecase = resolve()
            let isFieldOwnerUseCase : IsUserFieldOwnerUsecase = resolve()
          return InsightViewReactor(insightUid: insightUid, origin: origin, getSingleInsightUsecase: getSingleInsightUsease, insightsForFieldUsecase: insightsForFieldUsecase, fieldUseCase: fieldUseCase, userUseCase: userUseCase, updateUserParamsUsecase: updateUserParamsUsecase, dateProvider: dateProvider, isFieldOwnerUseCase: isFieldOwnerUseCase)
        }
        register { _, arg -> FieldViewReactor in
            guard let args = arg as? [Any] else { fatalError("Missing arguments for \(FieldViewReactor.self)") }
            guard let fieldId = args[0] as? Int else { fatalError("Missing fieldId for \(FieldViewReactor.self)") }
            let fieldWithImagesUsecase: FieldUseCase = resolve()
            let getCategoriesUsecase : GetCategoriesUsecase = resolve()
            let getFieldImageryUsecase : GetFieldImageryUsecase = resolve()
            let getFieldIrrigationUsecase : GetFieldIrrigationUsecase = resolve()
            let requestReportLinkUsecase: RequestReportLinkUsecase = resolve()
            let virtualScoutingStateUsecase: VirtualScoutingStateUsecase = resolve()
            return FieldViewReactor(fieldId: fieldId, fieldWithImagesUsecase: fieldWithImagesUsecase, getCategoriesUsecase: getCategoriesUsecase, getFieldImageryUsecase: getFieldImageryUsecase, getFieldIrrigationUsecase: getFieldIrrigationUsecase, getRequestReportLinkUsecase: requestReportLinkUsecase, getVirtualScoutingStateUsecase: virtualScoutingStateUsecase)
        }
        register { _, arg -> VirtualScoutingReactor in
            guard let args = arg as? [Any] else { fatalError("Missing arguments for \(VirtualScoutingReactor.self)") }
            guard let field = args[0] as? Field else { fatalError("Missing field for \(VirtualScoutingReactor.self)") }
            guard let cycleId = args[1] as? Int else { fatalError("Missing cycleId for \(VirtualScoutingReactor.self)") }
            let virtualScoutingDatesUseCase: VirtualScoutingDatesUseCase = resolve()
            let virtualScoutingGridUsecase: VirtualScoutingGridUsecase = resolve()
            let virtualScoutingImagesUsecase: VirtualScoutingImagesUsecase = resolve()
            let getImagesGalleryImageSizeUseCase : GetImagesGalleryImageSizeUseCase = resolve()
            return VirtualScoutingReactor(field: field, cycleId: cycleId, virtualScoutingDatesUseCase: virtualScoutingDatesUseCase, virtualScoutingGridUsecase: virtualScoutingGridUsecase, virtualScoutingImagesUsecase: virtualScoutingImagesUsecase, getImagesGalleryImageSizeUseCase: getImagesGalleryImageSizeUseCase)
        }
        register {
            let farmFilter : FarmFilter = resolve()
            let userStreamUsecase: UserStreamUsecase = resolve()
            let allFarmsUseCase: GetAllFarmsUseCase = resolve()
            let updateUserParamsUsecase: UpdateUserParamsUsecase = resolve()
            return ContainerViewReactor(farmFilter: farmFilter, userStreamUseCase: userStreamUsecase, allFarmsUseCase: allFarmsUseCase, updateUserParamsUsecase: updateUserParamsUsecase)
        }
        register {
            let insightsUseCase : InsightsFromDateUsecase = resolve()
            let getFeedMinDateUseCase : GetFeedMinDateUseCase = resolve()
            let userUseCase: UserStreamUsecase = resolve()
            let getImageryUsecase: GetImageryUsecase = resolve()
            let updateUseParamsUsecase: UpdateUserParamsUsecase = resolve()
            return InboxListReactor(dateProvider: resolve(), insightsUseCase: insightsUseCase, getFeedMinDateUseCase: getFeedMinDateUseCase, userUseCase: userUseCase, getImageryUsecase: getImageryUsecase, updateUseParamsUsecase: updateUseParamsUsecase)
        }
        register {
            let fieldUseCase : FieldsUsecase = resolve()
            let insightsFromDateUsecase : InsightsFromDateUsecase = resolve()
            let farmFilter : FarmFilter = resolve()
            let getImagesIntervalSinceNowUseCase : GetImagesIntervalSinceNowUseCase = resolve()
            let getInsightIntervalSinceNowUse : GetInsightIntervalSinceNowUseCase = resolve()
            let getHighlightItemsLimitUseCase : GetHighlightItemsLimitUseCase = resolve()
            let getHighlightDaysLimitUseCase : GetHighlightDaysLimitUseCase = resolve()
            let latestHighlightsByFarmsUseCase : LatestHighlightsByFarmsUseCase = resolve()
            let getHighlightsForFieldsUseCas : GetHighlightsForFieldsUsecase = resolve()
            
            return FieldsListReactor(fieldsUsecase: fieldUseCase, insightsFromDateUsecase: insightsFromDateUsecase, fieldLastReadUsecase: resolve(), getHighlightsForFieldsUseCase: getHighlightsForFieldsUseCas, farmFilter: farmFilter, getImagesIntervalSinceNowUseCase: getImagesIntervalSinceNowUseCase, getInsightIntervalSinceNowUseCase: getInsightIntervalSinceNowUse, getHighlightItemsLimitUseCase: getHighlightItemsLimitUseCase, getHighlightDaysLimitUseCase: getHighlightDaysLimitUseCase, latestHighlightsByFarmsUseCase: latestHighlightsByFarmsUseCase)
        }
        register { _, arg -> LocationInsightReactor in
            guard let args = arg as? [Any] else { fatalError("Missing arguments in order to view location insight page") }
            guard let insight = args[0] as? LocationInsight else { fatalError("Missing Location insight in order to view location insight page") }
            guard let originScreen = args[1] as? String else { fatalError("Missing origin screen for in order to view location insight page") }
            let locationsFromInsightUsecase : LocationsFromInsightUsecase = resolve()
            
            let a: IssueLocationInsightColorProvider = resolve()
            let b: RangedLocationInsightColorProvider = resolve()
            let c: EmptyLocationInsightColorProvider = resolve()
            let d: EnhancedLocationInsightColorProvider = resolve()
            let e: SingleLocationInsightColorProvider = resolve()
            let getSupportedInsightUseCase : GetSupportedInsightUseCase = resolve()
            let updateUserParamsUsecase: UpdateUserParamsUsecase = resolve()
            let isFieldOwnerUseCase : IsUserFieldOwnerUsecase = resolve()

          return LocationInsightReactor(locationInsight: insight, locationColorProviders: [a, b, c, d, e], locationInsightSingleIssueCardProvider: resolve(), dateProvider: resolve(), originScreen: originScreen, locationsFromInsightUsecase: locationsFromInsightUsecase, remoteConfigRepository: resolve(), getSupportedInsightUseCase: getSupportedInsightUseCase, updateUserParamsUsecase: updateUserParamsUsecase, isUserFieldOwnerUsecase: isFieldOwnerUseCase)
        }
        
        register { _, arg -> LocationInsightsPagerReactor in
            guard let args = arg as? [Any] else { fatalError("Missing arguments in order to view location insight page") }
            guard let insightUid = args[0] as? String else { fatalError("Missing insightUid in order to view location insight page") }
            guard let category = args[1] as? String else { fatalError("Missing category in order to view location insights pager") }
            guard let subCategory = args[2] as? String else { fatalError("Missing subCategory in order to view location insights pager") }
            guard let fieldId = args[3] as? Int? else { fatalError("Missing fieldId in order to view location insights pager for field") }
            guard let cycleId = args[4] as? Int? else { fatalError("Missing cycleId in order to view location insights pager for field") }
            guard let publicationYear = args[5] as? Int? else { fatalError("Missing publicationYear in order to view location insights pager for field") }
            let insightsFromFieldAndCategoryUsecase: InsightsFromFieldAndCategoryUsecase = resolve()
            let getSingleInsightUsecase : GetSingleInsightUsecase = resolve()
            let welcomInsightsUsecase: WelcomInsightsUsecase = resolve()
            let languageService: LanguageService = resolve()
            let isUserFieldUseCase: IsUserFieldOwnerUsecase = resolve()
            let getShapeFileUrlUseCase : GetShapeFileUrlUseCase = resolve()
            let getSupportedInsightUseCase : GetSupportedInsightUseCase = resolve()
            return LocationInsightsPagerReactor(insightUid: insightUid, category: category, subcateogy: subCategory, fieldId: fieldId, cycleId: cycleId, publicationYear: publicationYear, insightsFromFieldAndCategoryUsecase: insightsFromFieldAndCategoryUsecase, getSingleInsightUsecase: getSingleInsightUsecase, welcomInsightsUsecase: welcomInsightsUsecase, dateProvider: resolve(), getShapeFileUrlUseCase: getShapeFileUrlUseCase, languageService: languageService, isUserFieldOwnerUsecase: isUserFieldUseCase, getSupportedInsightUseCase: getSupportedInsightUseCase)
        }
    }
}
