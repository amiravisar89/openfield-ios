//
//  Contract+injection.swift
//  Openfield
//
//  Created by amir avisar on 17/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import Resolver

extension Resolver {
    static func registerContracts() {
      register {
        let userUseCase : UserStreamUsecase = resolve()
        let updateUseParamsUsecase: UpdateUserParamsUsecase = resolve()
        return TermsOfUseProvider(contractProvider: resolve(), userUseCase: userUseCase, updateUseParamsUsecase: updateUseParamsUsecase) as TermsOfUseProviderProtocol
      }
        register {
            let getContractsUseCase : GetContractsUseCase = resolve()
            return ContractProvider(jsonDecoder: main.resolve(), getContractsUseCase: getContractsUseCase) as ContractProviderProtocol
        }
    }
}
