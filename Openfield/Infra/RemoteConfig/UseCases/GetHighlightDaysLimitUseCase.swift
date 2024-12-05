//
//  GetHighlightDaysLimitUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class GetHighlightDaysLimitUseCase: GetHighlightDaysLimitUseCaseProtocol {
    let remoteconfigRepository: RemoteConfigRepositoryProtocol
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol) {
        self.remoteconfigRepository = remoteconfigRepository
    }
    
    func highlightDaysLimit() -> Int {
        let limit = remoteconfigRepository.int(forKey: .highlight_days)
        guard limit > 0 else {
            reportCrashlytics()
            return remoteconfigRepository.getDefaultValue(forKey: RemoteConfigParameterKey.highlight_days.rawValue) ?? 14
        }
        return limit
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
