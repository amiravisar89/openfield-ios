//
//  GetHelpCenterUrlUseCase.swift
//  Openfield
//
//  Created by Amitai Efrati on 12/11/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

import Foundation
import FirebaseCrashlytics

class GetHelpCenterUrlUseCase: GetHelpCenterUrlUseCaseProtocol {
    let remoteconfigRepository: RemoteConfigRepositoryProtocol
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol) {
        self.remoteconfigRepository = remoteconfigRepository
    }
    
    func getUrl() -> URL {
        let defaultUrl = "https://prospera.ag/contact"
        let urlString = remoteconfigRepository.string(forKey: .mobile_help_center_url)
        guard let url = URL(string: urlString) else {
            reportCrashlytics()
            return URL(string: remoteconfigRepository.getDefaultValue(forKey: RemoteConfigParameterKey.mobile_help_center_url.rawValue) ?? defaultUrl)!
        }
        return url
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
