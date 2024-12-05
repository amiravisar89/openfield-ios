//
//  InsightsUsecase.swift
//  Openfield
//
//  Created by Yoni Luz on 01/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyUserDefaults
import Firebase
import SwiftDate

class InsightsUsecase: InsightsUsecaseProtocol {
    
    private let userStreamUsecase: UserStreamUsecaseProtocol
    
    private let insightMapper: InsightModelMapperProtocol
    private let getSupportedInsightUseCase : GetSupportedInsightUseCaseProtocol
    private let getUnitByCountryUseCase : GetUnitByCountryUseCaseProtocol
    
    init(userStreamUsecase: UserStreamUsecaseProtocol,  insightMapper: InsightModelMapperProtocol, getSupportedInsightUseCase : GetSupportedInsightUseCaseProtocol, getUnitByCountryUseCase : GetUnitByCountryUseCaseProtocol) {
        self.userStreamUsecase = userStreamUsecase
        self.insightMapper = insightMapper
        self.getSupportedInsightUseCase = getSupportedInsightUseCase
        self.getUnitByCountryUseCase = getUnitByCountryUseCase
    }
    
    func generateInsight(insightStream: Observable<InsightServerModel?>) -> Observable<Insight?> {
        let userStream = userStreamUsecase.userStream()
        let insightAndUserStream = Observable.combineLatest(userStream, insightStream.compactMap{$0}) {(user: $0,insight: $1)}
        
        return insightAndUserStream.compactMap { (insightsAndUser) in
            let userInsight = insightsAndUser.user.insights[insightsAndUser.insight.id]
            guard let insight = self.getInsight(insightServerModel: insightsAndUser.insight, userInsight: userInsight) else {
                return nil
            }
            return insight
        }
    }
    
    func generateInsights(insightsStream: Observable<[InsightServerModel]>) -> Observable<[Insight]> {
        let userStream = userStreamUsecase.userStream()
        return Observable.combineLatest(userStream, insightsStream) {
            user, insightsSMList -> [Insight] in
            let insights: [Insight] = insightsSMList.compactMap { insightSM in
                let userInsight = user.insights[insightSM.id]
                guard let insight = self.getInsight(insightServerModel: insightSM, userInsight: userInsight) else {
                    return nil
                }
                return insight
            }
            return insights
        }
    }
    
    private func getInsight(insightServerModel: InsightServerModel, userInsight: UserInsight?) -> Insight? {
        var insightSM = insightServerModel
        if insightServerModel.ts_published == nil {
            // TODO: do not use firebase objects here
            insightSM.ts_published = Timestamp(date: Date(timeIntervalSince1970: 0))
        }
        
        let currentInsightConfiguration = getSupportedInsightUseCase.supportedInsights()[insightSM.category]
        guard let insightConfiguration = currentInsightConfiguration else {
            log.error("Insight category is not supported (from firebase config) - insight uid \(insightSM.uid) with type - \(insightServerModel.type)")
            return nil
        }
        do {
            return try insightMapper.map(insightConfiguration: insightConfiguration, insightServerModel: insightSM, userInsight: userInsight, unitByCountry: getUnitByCountryUseCase.unitByCountry())
        } catch {
            log.warning("Error while trying to map insight server model to insight, error \(error)")
            return nil
        }
    }
    
}
