//
//  GetSupportUrlUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class GetSupportUrlUseCase: GetSupportUrlUseCaseProtocol {
    let remoteconfigRepository: RemoteConfigRepositoryProtocol
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol) {
        self.remoteconfigRepository = remoteconfigRepository
    }
    
    func url() -> URL {
        let defaultUrl = "https://prospera.ag/contact"
        let urlString = remoteconfigRepository.string(forKey: .mobile_support_url)
        guard let url = URL(string: urlString) else {
            reportCrashlytics()
          return URL(
            string: remoteconfigRepository.getDefaultValue(forKey: RemoteConfigParameterKey.mobile_support_url.rawValue) ?? defaultUrl)!
        }
        return url
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
