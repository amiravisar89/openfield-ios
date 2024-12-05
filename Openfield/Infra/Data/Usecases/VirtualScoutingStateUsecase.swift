//
//  VirtualScoutingStateUsecase.swift
//  Openfield
//
//  Created by Yoni Luz on 11/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class VirtualScoutingStateUsecase: VirtualScoutingStateUsecaseProtocol {
    
    private let featureFlagRepository: FeatureFlagsRepositoryProtocol
    private let virtualScoutingFeatureFlag: FeatureFlagProtocol
    private let virtualScoutingDatesUseCase: VirtualScoutingDatesUseCaseProtocol
    private let getVirtualScoutingStartYearUseCase: GetVirtualScoutingStartYearUseCaseProtocol

    init(featureFlagRepository: FeatureFlagsRepositoryProtocol, virtualScoutingFeatureFlag: FeatureFlagProtocol, virtualScoutingDatesUseCase: VirtualScoutingDatesUseCaseProtocol, getVirtualScoutingStartYearUseCase: GetVirtualScoutingStartYearUseCaseProtocol) {
        self.featureFlagRepository = featureFlagRepository
        self.virtualScoutingFeatureFlag = virtualScoutingFeatureFlag
        self.virtualScoutingDatesUseCase = virtualScoutingDatesUseCase
        self.getVirtualScoutingStartYearUseCase = getVirtualScoutingStartYearUseCase
    }
    
    func getVirtualScoutingState(field: Field, selectedSeasonOrder: Int) -> Observable<VirtualScoutingState> {
        guard featureFlagRepository.isFeatureFlagEnabled(featureFlag: virtualScoutingFeatureFlag) else {
            return Observable.just(VirtualScoutingState.hidden)
        }
        guard let subscriptionTypes = field.subscriptionTypes, subscriptionTypes.contains(SubscriptionType.ValleyInsightsPanda.rawValue) else {
            return Observable.just(VirtualScoutingState.hidden)
        }
        guard let cycleId = field.getCycleId(forSelectedOrder: selectedSeasonOrder) else {
            return Observable.just(VirtualScoutingState.hidden)
        }
        let hasDataObservable = virtualScoutingDatesUseCase.getDates(fieldId: field.id, cycleId: cycleId, limit: 7).map { !$0.isEmpty }
        return hasDataObservable.map { [weak self] hasData in
            guard hasData, let self = self else {
                return VirtualScoutingState.hidden
            }
            let startYearForVirtualScouting = getVirtualScoutingStartYearUseCase.year()
            if let publicationYear = field.getPublicationYear(forSelectedOrder: selectedSeasonOrder), publicationYear >=  startYearForVirtualScouting {
                return VirtualScoutingState.enabled
            } else {
                return VirtualScoutingState.disabled
            }
        }
    }
}
