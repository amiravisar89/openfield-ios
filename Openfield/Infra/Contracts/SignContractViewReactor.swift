//
//  SignContractViewReactor.swift
//  Openfield
//
//  Created by amir avisar on 17/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import ReactorKit
import Resolver
import RxCocoa
import RxSwift
import Then
import SwiftyUserDefaults

class SignContractViewReactor: Reactor {
    var initialState: State
    let disposeBag = DisposeBag()
    let contractsProvider: TermsOfUseProviderProtocol
    let getSupportUrlUseCase : GetSupportUrlUseCaseProtocol
    let updateUseParamsUsecase : UpdateUserParamsUsecaseProtocol

    init(contractsProvider: TermsOfUseProviderProtocol, getSupportUrlUseCase : GetSupportUrlUseCaseProtocol, updateUseParamsUsecase : UpdateUserParamsUsecaseProtocol) {
        self.updateUseParamsUsecase = updateUseParamsUsecase
        self.contractsProvider = contractsProvider
        self.getSupportUrlUseCase = getSupportUrlUseCase
        initialState = State()
        Observable.just(Action.viewContract).bind(to: action).disposed(by: disposeBag)
    }

    enum Action {
        case signContract
        case viewContract
        case goToContract(type: ContractType, navigation: (Double, Contract) -> Void)
        case goToSupport(navigation: (URL) -> Void)
    }

    enum Mutation {
        case unChange
    }

    struct State: Then {}

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .goToContract(type: type, navigation: navigation):
            guard let contract = contractsProvider.getContract(by: type),
                  let remoteContract = contractsProvider.remoteContracts else { return Observable.empty() }
            navigation(remoteContract.version, contract)
            return Observable.empty()

        case .viewContract:
            let updateContractTrackingObs = contractsProvider.updateContractSeen(tsSeenContract: Date()).map { _ in Mutation.unChange }
            return updateContractTrackingObs

        case .signContract:
            guard Defaults.impersonatorId == nil else { return Observable.empty() }
            let signContracObs = contractsProvider.sign().map { _ in Mutation.unChange }
            return signContracObs

        case let .goToSupport(navigation: navigation):
            let supportURL = getSupportUrlUseCase.url()
            navigation(supportURL)
            return Observable.empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .unChange:
            return state
        }
    }
}
