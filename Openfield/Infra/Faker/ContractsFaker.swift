//
//  ContractsFaker.swift
//  Openfield
//
//  Created by amir avisar on 21/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation

import Dollar
import Fakery
import Foundation

struct ContractsFaker: FakerProvider {
    let faker: Faker

    init(faker: Faker) {
        self.faker = faker
    }

    func creactContracts() -> Contracts {
        let contracts = Contracts(version: 2.0, date: Date(), contracts: [Contract(title: "", type: .terms, url: ""),
                                                                          Contract(title: "", type: .privacy, url: ""),
                                                                          Contract(title: "", type: .changes, url: "")])
        return contracts
    }
}
