//
//  GetFeedMinDateUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class GetFeedMinDateUseCase: GetFeedMinDateUseCaseProtocol {
    let remoteconfigRepository: RemoteConfigRepositoryProtocol
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol) {
        self.remoteconfigRepository = remoteconfigRepository
    }
    
    func date() -> Date {
        let interval = remoteconfigRepository.double(forKey: .feed_min_date_v2)
        let calculatedDate = Date(timeIntervalSince1970: interval)
        let oneMonthAgo = Date().minus(component: .month, value: 1) ?? Date()

        if calculatedDate >= oneMonthAgo {
            reportCrashlytics()
            let defaultInterval = remoteconfigRepository.getDefaultValue(forKey: RemoteConfigParameterKey.feed_min_date_v2.rawValue) ?? 1609459200.0
            return Date(timeIntervalSince1970: defaultInterval)
        }
        
        return calculatedDate
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
