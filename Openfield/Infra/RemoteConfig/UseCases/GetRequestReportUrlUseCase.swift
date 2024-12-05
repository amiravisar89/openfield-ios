//
//  GetRequestReportUrlUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class GetRequestReportUrlUseCase: GetRequestReportUrlUseCaseProtocol {
    
    let remoteconfigRepository: RemoteConfigRepositoryProtocol
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol) {
        self.remoteconfigRepository = remoteconfigRepository
    }
    
    func url(locale: Locale) -> URL {
        if locale.identifier == LanguageService.defaultLanguage.locale.identifier {
            return requestReportEnUrl()
        } else {
            return requestReportPtUrl()
        }
    }
    
    private func requestReportPtUrl() -> URL {
        let defaultUrl = "https://forms.office.com/r/Xr5RtFmhTD?origin=lprLink"
        let urlString = remoteconfigRepository.string(forKey: .request_report_pt_url)
        guard let url = URL(string: urlString) else {
            reportCrashlytics()
            return URL(string: remoteconfigRepository.getDefaultValue(forKey: RemoteConfigParameterKey.request_report_pt_url.rawValue) ?? defaultUrl)!
        }
        return url
    }
    
    private func requestReportEnUrl() -> URL {
        let defaultUrl = "https://forms.office.com/r/Xr5RtFmhTD?origin=lprLink"
        let urlString = remoteconfigRepository.string(forKey: .request_report_en_url)
        guard let url = URL(string: urlString) else {
            reportCrashlytics()
            return URL(string: remoteconfigRepository.getDefaultValue(forKey: RemoteConfigParameterKey.request_report_en_url.rawValue) ?? defaultUrl)!
        }
        return url
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
