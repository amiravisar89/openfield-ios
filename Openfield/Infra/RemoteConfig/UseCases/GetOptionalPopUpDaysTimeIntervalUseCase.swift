//
//  GetOptionalPopUpDaysTimeIntervalUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class GetOptionalPopUpDaysTimeIntervalUseCase: GetOptionalPopUpDaysTimeIntervalUseCaseProtocol {
    let remoteconfigRepository: RemoteConfigRepositoryProtocol
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol) {
        self.remoteconfigRepository = remoteconfigRepository
    }
    
    func interval() -> Int {
        let limit = remoteconfigRepository.int(forKey: .optionalPopUpDaysTimeInterval)
        guard limit > 0 else {
            reportCrashlytics()
            return remoteconfigRepository.getDefaultValue(forKey: RemoteConfigParameterKey.optionalPopUpDaysTimeInterval.rawValue) ?? 14
        }
        return limit
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
