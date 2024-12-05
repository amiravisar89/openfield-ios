//
//  GetUnitByCountryUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class GetUnitByCountryUseCase: GetUnitByCountryUseCaseProtocol {
    
    private let remoteconfigRepository: RemoteConfigRepositoryProtocol
    private let unitByCountryMapper: UnitByCountryModelMapper
    private let jsonDecoder: JSONDecoder
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol, jsonDecoder: JSONDecoder,
         unitByCountryMapper: UnitByCountryModelMapper) {
        self.remoteconfigRepository = remoteconfigRepository
        self.jsonDecoder = jsonDecoder
        self.unitByCountryMapper = unitByCountryMapper
    }
    
    func unitByCountry() -> UnitsByCountry {
        let unitByCountryServerModel = remoteconfigRepository.data(forKey: .units_by_country)
        do {
            let unitByCountrySM = try jsonDecoder.decode(UnitsByCountryServerModel.self, from: unitByCountryServerModel)
            return try unitByCountryMapper.map(unitByCountryServerModel: unitByCountrySM)
        } catch {
            reportCrashlytics()
            log.error("Could not retreive unit by country from Firebase Remote Config, Error: \(error)")
            return UnitsByCountry(areaUnits: [:])
        }
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
    
}
