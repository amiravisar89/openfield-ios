//
//  ContractsMapper.swift
//  Openfield
//
//  Created by amir avisar on 14/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation

class ContracsMapper {
    func map(contractsServerModel: ContractsSeverModel) throws -> Contracts {
        let contracts = try contractsServerModel.contracts.map { contractServerModel -> Contract in
            guard let type = ContractType(rawValue: contractServerModel.type) else {
                throw ParsingError(description: "Contract ServerModel is not in the right format - \(contractServerModel.type)")
            }

            guard URL(string: contractServerModel.link) != nil else {
                throw ParsingError(description: "Contract link is not in the right format - \(contractServerModel.link)")
            }

            let title = getTitle(by: type)
            return Contract(title: title, type: type, url: contractServerModel.link)
        }
        return Contracts(version: contractsServerModel.version, date: Date(timeIntervalSince1970: TimeInterval(contractsServerModel.date)), contracts: contracts)
    }

    func getTitle(by type: ContractType) -> String {
        switch type {
        case .terms:
            return R.string.localizable.contractTouTitle()
        case .privacy:
            return R.string.localizable.contractPpTitle()
        case .changes:
            return R.string.localizable.contractChangesTitle()
        case .support:
            return R.string.localizable.contractSupportLinkablePart()
        }
    }
}
