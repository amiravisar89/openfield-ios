//
//  GetSupportedInsightUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class GetSupportedInsightUseCase: GetSupportedInsightUseCaseProtocol {
    
    private let remoteconfigRepository: RemoteConfigRepositoryProtocol
    private let insightConfigurationlMapper: InsightConfigurationModellMapper
    private let jsonDecoder: JSONDecoder
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol, jsonDecoder: JSONDecoder, insightConfigurationlMapper: InsightConfigurationModellMapper) {
        self.remoteconfigRepository = remoteconfigRepository
        self.jsonDecoder = jsonDecoder
        self.insightConfigurationlMapper = insightConfigurationlMapper
    }
    
    func supportedInsights() -> [String: InsightConfiguration] {
        let supportedInsightTypesServerModel = remoteconfigRepository.data(forKey: .mobile_supported_insights_categories)
        do {
            let configServerModel = try jsonDecoder.decode([String: InsightConfigurationServerModel].self, from: supportedInsightTypesServerModel)
            return try insightConfigurationlMapper.map(configurationServerModel: configServerModel)
        } catch {
            reportCrashlytics()
            log.error("Could not retreive insight configuration from Firebase Remote Config, Error: \(error)")
            return [String: InsightConfiguration]()
        }
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
