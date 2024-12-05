//
//  TermsOfUseProvider.swift
//  Openfield
//
//  Created by amir avisar on 17/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class TermsOfUseProvider: TermsOfUseProviderProtocol {
    var remoteContracts:
        Contracts?
    let updateUseParamsUsecase: UpdateUserParamsUsecaseProtocol
    let contractProvider: ContractProviderProtocol
    let userUseCase: UserStreamUsecaseProtocol

    init(contractProvider: ContractProviderProtocol, userUseCase: UserStreamUsecaseProtocol, updateUseParamsUsecase: UpdateUserParamsUsecaseProtocol) {
        self.contractProvider = contractProvider
        self.userUseCase = userUseCase
        self.updateUseParamsUsecase = updateUseParamsUsecase
        remoteContracts = contractProvider.remoteContracts
    }

    func shouldSign() -> Observable<Bool> {
      return userUseCase.userStream().map { [weak self] user in
            guard let self = self,
                  let remoteContracts = self.remoteContracts,
                  let signedContractVersion = user.tracking.signedContractVersion else { return true }
            return Int(signedContractVersion) < Int(remoteContracts.version)
        }
    }

    func getContract(by type: ContractType) -> Contract? {
        return contractProvider.getContract(by: type)
    }

    func updateContractSeen(tsSeenContract: Date) -> Observable<UserTracking> {
        return userUseCase.userStream().map { $0.tracking }.compactMap { $0 }.take(1).concatMap { [weak self] userTracking -> Observable<UserTracking> in
            guard let self = self,
                  let remoteContracts = self.remoteContracts else { return Observable.empty() }
            var tracking = userTracking
            tracking.tsSeenContract = tsSeenContract
            tracking.seenContractVersion = remoteContracts.version
            return self.updateUseParamsUsecase.updateTracking(tracking: tracking).catchError{ _ in
                    .empty()
            }
        }
    }

    func sign() -> Observable<UserTracking> {
        guard let remoteContracts = remoteContracts else { return Observable.empty() }
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.contract, .contractSign, [EventParamKey.contractVersion: String(remoteContracts.version)]))
        return userUseCase.userStream().map { $0.tracking }.compactMap { $0 }.take(1).concatMap { [weak self] userTracking -> Observable<UserTracking> in
            guard let self = self else { return Observable.empty() }
            var tracking = userTracking
            tracking.signedContractVersion = remoteContracts.version
            return self.updateUseParamsUsecase.updateTracking(tracking: tracking)
        }
    }
}
