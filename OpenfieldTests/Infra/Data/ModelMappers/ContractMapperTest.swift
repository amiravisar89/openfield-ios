//
//  ContractMapperTest.swift
//  OpenfieldTests
//
//  Created by amir avisar on 21/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Fakery
import Firebase
import Foundation
import Nimble
import Quick
import Resolver
import SwiftDate

@testable import Openfield

class ContractMapperTest: QuickSpec {
    override class func spec() {
        let contractsMapper = ContracsMapper()

        describe("Contract Mapper") {
            it("map_Contract_when_contract_has_links_then_contract_exist") {
                let contractSM = ContractTestModel.contracts
                let contract = try? contractsMapper.map(contractsServerModel: contractSM)

                expect(contract?.contracts.count).to(equal(contractSM.contracts.count))
            }

            it("map_Contract_when_contract_has_no_links_then_contract_not_exist") {
                let contractSM = ContractTestModel.contractsWithNoLinks
                let contract = try? contractsMapper.map(contractsServerModel: contractSM)

                expect(contract).to(beNil())
            }

            it("map_Contract_when_contract_has_no_types_then_contract_not_exist") {
                let contractSM = ContractTestModel.contractsWithNoTypes
                let contract = try? contractsMapper.map(contractsServerModel: contractSM)

                expect(contract).to(beNil())
            }
        }
    }
}
