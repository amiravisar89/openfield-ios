//
//  MockContractProvider.swift
//  OpenfieldTests
//
//  Created by amir avisar on 21/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation

@testable import Openfield

class MockContractProvider: ContractProviderProtocol {
    func getContract(by type: Openfield.ContractType) -> Openfield.Contract? {
        return remoteContracts?.contracts.filter { $0.type == type }.first
    }

    var remoteContracts: Openfield.Contracts? {
        return ContractTestModel.uiContracts
    }
}
