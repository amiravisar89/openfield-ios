//
//  GetVirtualScoutingStartYearUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class GetVirtualScoutingStartYearUseCase: GetVirtualScoutingStartYearUseCaseProtocol {
    let remoteconfigRepository: RemoteConfigRepositoryProtocol
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol) {
        self.remoteconfigRepository = remoteconfigRepository
    }
    
    //2015 is a yaer which companey established
    func year() -> Int {
        let limit = remoteconfigRepository.int(forKey: .start_year_for_virtual_scouting)
        guard limit > 2005 && Date().year >= limit else {
            reportCrashlytics()
            return remoteconfigRepository.getDefaultValue(forKey: RemoteConfigParameterKey.start_year_for_virtual_scouting.rawValue) ?? 2024
        }
        return limit
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
