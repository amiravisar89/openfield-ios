//
//  GetImagesIntervalSinceNowUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class GetImagesIntervalSinceNowUseCase: GetImagesIntervalSinceNowUseCaseProtocol {
    let remoteconfigRepository: RemoteConfigRepositoryProtocol
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol) {
        self.remoteconfigRepository = remoteconfigRepository
    }
    
    func imagesIntervalSinceNow() -> Date {
        let interval = remoteconfigRepository.double(forKey: .images_interval_since_now)
        let calculatedDate = Date(timeIntervalSinceNow: -interval).startOfDay

        if calculatedDate >= Date() {
            reportCrashlytics()
            let defaultInterval = remoteconfigRepository.getDefaultValue(forKey: RemoteConfigParameterKey.images_interval_since_now.rawValue) ?? 172800.0
            return Date(timeIntervalSinceNow: -defaultInterval).startOfDay
        }
        return calculatedDate
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
