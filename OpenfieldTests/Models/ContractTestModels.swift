//
//  ContractTestModels.swift
//  OpenfieldTests
//
//  Created by amir avisar on 21/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Firebase
import Foundation

@testable import Openfield

enum ContractTestModel {
    static let uiContracts = Contracts(version: 2.0, date: Date(), contracts: [Contract(title: "terms", type: .terms, url: "https://test"), Contract(title: "privacy", type: .privacy, url: "https://test"), Contract(title: "changes", type: .changes, url: "https://test")])

    static let contracts = ContractsSeverModel(version: 0.0, date: 123, contracts: [ContractServerModel(type: "privacy", link: "https://test"),
                                                                                    ContractServerModel(type: "terms", link: "https://test"),
                                                                                    ContractServerModel(type: "changes", link: "https://test")])

    static let contractsWithNoLinks = ContractsSeverModel(version: 0.0, date: 123, contracts: [ContractServerModel(type: "privacy", link: ""),
                                                                                               ContractServerModel(type: "terms", link: ""),
                                                                                               ContractServerModel(type: "changes", link: "")])

    static let contractsWithNoTypes = ContractsSeverModel(version: 0.0, date: 123, contracts: [ContractServerModel(type: "", link: "https://test"),
                                                                                               ContractServerModel(type: "", link: "https://test"),
                                                                                               ContractServerModel(type: "", link: "https://test")])
}
