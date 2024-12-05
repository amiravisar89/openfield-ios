//
//  GetShapeFileUrlUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class GetShapeFileUrlUseCase: GetShapeFileUrlUseCaseProtocol {
    
    let remoteconfigRepository: RemoteConfigRepositoryProtocol
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol) {
        self.remoteconfigRepository = remoteconfigRepository
    }
    
    func url(locale: Locale) -> URL {
        if locale.identifier == LanguageService.defaultLanguage.locale.identifier {
            return shapeFileEnUrl()
        } else {
            return shapeFilePtUrl()
        }
    }
    
    private func shapeFilePtUrl() -> URL {
        let defaultUrl = "https://forms.office.com/pages/responsepage.aspx?id=8PtGg8X7q0SzUWMhBfYmb8AQdknhsatGiKXAZMbZmapUNkZJVE9MSlRaSVYwMDFVOVo5OFk1Wlg2Ni4u"
        let urlString = remoteconfigRepository.string(forKey: .shapefile_pt_url)
        guard let url = URL(string: urlString) else {
            reportCrashlytics()
            return URL(string: remoteconfigRepository.getDefaultValue(forKey: RemoteConfigParameterKey.shapefile_pt_url.rawValue) ?? defaultUrl)!
        }
        return url
    }
    
    private func shapeFileEnUrl() -> URL {
        let defaultUrl = "https://forms.office.com/pages/responsepage.aspx?id=8PtGg8X7q0SzUWMhBfYmb8AQdknhsatGiKXAZMbZmapUQlk4UUJSQUJYVVhVUlBVUDBXVDBXVzBOMy4u"
        let urlString = remoteconfigRepository.string(forKey: .shapefile_en_url)
        guard let url = URL(string: urlString) else {
            reportCrashlytics()
            return URL(string: remoteconfigRepository.getDefaultValue(forKey: RemoteConfigParameterKey.shapefile_en_url.rawValue) ?? defaultUrl)!
        }
        return url
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
