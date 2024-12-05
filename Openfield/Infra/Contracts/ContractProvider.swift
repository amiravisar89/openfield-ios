//
//  ContractProvider.swift
//  Openfield
//
//  Created by amir avisar on 11/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol ContractProviderProtocol {
    func getContract(by type: ContractType) -> Contract?
    var remoteContracts: Contracts? { get }
}

class ContractProvider: ContractProviderProtocol {
    let jsonDecoder: JSONDecoder
    let remoteContracts: Contracts?
    let getContractsUseCase : GetContractsUseCaseProtocol

    init(jsonDecoder: JSONDecoder, getContractsUseCase : GetContractsUseCaseProtocol) {
        self.jsonDecoder = jsonDecoder
        self.remoteContracts = getContractsUseCase.contracts()
        self.getContractsUseCase = getContractsUseCase
    }

    func getContract(by type: ContractType) -> Contract? {
        return getContractsUseCase.contracts()?.contracts.filter { $0.type == type }.first
    }
}
