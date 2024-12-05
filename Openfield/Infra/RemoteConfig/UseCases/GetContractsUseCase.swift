//
//  GetContractsUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class GetContractsUseCase: GetContractsUseCaseProtocol {
    
    private let remoteconfigRepository: RemoteConfigRepositoryProtocol
    private let contractsMapper: ContracsMapper
    private let jsonDecoder: JSONDecoder
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol, jsonDecoder: JSONDecoder,
         contractsMapper: ContracsMapper) {
        self.remoteconfigRepository = remoteconfigRepository
        self.jsonDecoder = jsonDecoder
        self.contractsMapper = contractsMapper
    }
    
    func contracts() -> Contracts? {
        let contractsServerModel = remoteconfigRepository.data(forKey: .contracts)
        do {
            let contractsServerModel = try jsonDecoder.decode(ContractsSeverModel.self, from: contractsServerModel)
            return try contractsMapper.map(contractsServerModel: contractsServerModel)
        } catch {
            reportCrashlytics()
            log.error("Could not retreive contracts from Firebase Remote Config, Error: \(error)")
            return nil
        }
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
    
}
