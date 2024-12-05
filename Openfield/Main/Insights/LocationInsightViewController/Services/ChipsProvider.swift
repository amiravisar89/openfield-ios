//
//  ChipsProvider.swift
//  Openfield
//
//  Created by amir avisar on 06/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Resolver

struct ChipsProvider {
    private let remoteConfigRepository: RemoteConfigRepository
    private let getSupportedInsightUseCase : GetSupportedInsightUseCaseProtocol

    init(remoteConfigRepository: RemoteConfigRepository,
         getSupportedInsightUseCase : GetSupportedInsightUseCaseProtocol) {
        self.remoteConfigRepository = remoteConfigRepository
        self.getSupportedInsightUseCase = getSupportedInsightUseCase
    }

    func provideChips(for insight: Insight) -> InsightChipConfig? {
        let selectedInsight = getSupportedInsightUseCase.supportedInsights()[insight.category]?.appTypes[insight.subCategory]
        return selectedInsight?.chipsConfig
    }
}
