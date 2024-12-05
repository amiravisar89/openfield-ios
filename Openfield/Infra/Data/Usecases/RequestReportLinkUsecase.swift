//
//  RequestReportLinkUsecase.swift
//  Openfield
//
//  Created by Yoni Luz on 29/05/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class RequestReportLinkUsecase: RequestReportLinkUsecaseProtocol {

    private var languageService: LanguageService
    private var featureFlagRepository: FeatureFlagsRepositoryProtocol
    private let requestReportFeatureFlag: FeatureFlagProtocol
    private let getRequestReportUrlUseCase : GetRequestReportUrlUseCaseProtocol
    private let getRequestReportStartYearUseCase : GetRequestReportStartYearUseCaseProtocol

    init(languageService: LanguageService, featureFlagRepository: FeatureFlagsRepositoryProtocol, requestReportFeatureFlag: FeatureFlagProtocol, getRequestReportUrlUseCase : GetRequestReportUrlUseCaseProtocol, getRequestReportStartYearUseCase : GetRequestReportStartYearUseCaseProtocol) {
        self.requestReportFeatureFlag = requestReportFeatureFlag
        self.languageService = languageService
        self.featureFlagRepository = featureFlagRepository
        self.getRequestReportUrlUseCase = getRequestReportUrlUseCase
        self.getRequestReportStartYearUseCase = getRequestReportStartYearUseCase
    }

    func getRequestReportLink(field: Field, selectedSeasonOrder: Int) -> Observable<URL?> {
        guard featureFlagRepository.isFeatureFlagEnabled(featureFlag: requestReportFeatureFlag) else {
            return Observable.just(nil)
        }
        let filter = field.filters.first(where: { $0.order == selectedSeasonOrder })
        let startYearForRequestReport = getRequestReportStartYearUseCase.year()
        if filter?.criteria.contains(where: { $0.filterBy.contains(where: { $0.property == "publication_year" && ($0.value.valueAsAny is Int) && ($0.value.valueAsAny as! Int) >= startYearForRequestReport })}) == true {
            return languageService.currentLanguage.map { userLanguage in
                return self.getRequestReportUrlUseCase.url(locale: userLanguage.locale)
            }
        } else {
            return Observable.just(nil)
        }
  
    }
}
