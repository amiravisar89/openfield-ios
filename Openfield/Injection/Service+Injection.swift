//
//  Service+Injection.swift
//  Openfield
//
//  Created by Itay Kaplan on 07/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Resolver

extension Resolver {
    static func registerServices() {
        register { DispatchGroup() }
        register { ToolTipManager() }
        LocationInsightServices()
        insightServices()
    }

    private static func insightServices() {
        register { 
            let getSupportedInsightUseCase : GetSupportedInsightUseCase = resolve()
            return ChipsProvider(remoteConfigRepository: resolve(), getSupportedInsightUseCase: getSupportedInsightUseCase) }
    }

    private static func LocationInsightServices() {
        register { WelcomeLocationTooltipScheduler() }
        register { SingleLocationCardsProvider(locationColorsProvider: resolve(), chipsProvider: resolve()) }.scope(application)
        register { EnhancedLocationCardsProvider(locationColorsProvider: resolve()) }.scope(application)
        register { IssueLocationCardsProvider(locationColorsProvider: resolve()) }.scope(application)
        register { RangedLocationCardsProvider(locationColorsProvider: resolve()) }.scope(application)
        register { EmptyLocationCardsProvider(locationColorsProvider: resolve()) }.scope(application)
        register { () -> LocationInsightCardProvider in
            let a: IssueLocationCardsProvider = resolve()
            let b: RangedLocationCardsProvider = resolve()
            let c: EmptyLocationCardsProvider = resolve()
            let d: EnhancedLocationCardsProvider = resolve()
            let e: SingleLocationCardsProvider = resolve()
            return LocationInsightCardProvider(locationInsightCardsProviders: [a, b, c, d, e], locationInsightPresentedItemsProvider: resolve())
        }.scope(application)
        register { SingleLocationInsightColorProvider() }.scope(application)
        register { EnhancedLocationInsightColorProvider() }.scope(application)
        register { IssueLocationInsightColorProvider() }.scope(application)
        register { RangedLocationInsightColorProvider(rangedLocationPresentedItemProvider: resolve()) }.scope(application)
        register { EmptyLocationInsightColorProvider() }.scope(application)
        register { () -> LocationInsightCoordinatesProvider in
            let a: IssueLocationInsightColorProvider = resolve()
            let b: RangedLocationInsightColorProvider = resolve()
            let c: EmptyLocationInsightColorProvider = resolve()
            let d: EnhancedLocationInsightColorProvider = resolve()
            let e: SingleLocationInsightColorProvider = resolve()
            return LocationInsightCoordinatesProvider(locationColorsProviders: [a, b, c, d, e])
        }.scope(application)

        register { SingleLocationInsightSingleIssueCardProvider() }.scope(application)
        register { EnhancedLocationInsightSingleIssueCardProvider() }.scope(application)
        register { IssueLocationInsightSingleIssueCardProvider() }.scope(application)
        register { RangedLocationInsightSingleIssueCardProvider(rangedLocationPresentedItemProvider: resolve()) }.scope(application)
        register { EmptyLocationInsightSingleIssueCardProvider() }.scope(application)
        register { () -> LocationInsightSingleIssueCardProvider in
            let a: IssueLocationInsightSingleIssueCardProvider = resolve()
            let b: RangedLocationInsightSingleIssueCardProvider = resolve()
            let c: EmptyLocationInsightSingleIssueCardProvider = resolve()
            let d: EnhancedLocationInsightSingleIssueCardProvider = resolve()
            let e: SingleLocationInsightSingleIssueCardProvider = resolve()

            return LocationInsightSingleIssueCardProvider(singeIssueProviders: [a, b, c, d, e], locationInsightPresentedItemsProvider: resolve())
        }.scope(application)
        register { SingleLocationPresentedItemProvider() }.scope(application)
        register { EnhancedLocationPresentedItemProvider() }.scope(application)
        register { IssueLocationPresentedItemProvider() }.scope(application)
        register { RangedLocationPresentedItemProvider() }.scope(application)
        register { EmptyLocationPresentedItemProvider() }.scope(application)
        register { () -> LocationInsightPresentedItemsProvider in
            let a: IssueLocationPresentedItemProvider = resolve()
            let b: RangedLocationPresentedItemProvider = resolve()
            let c: EmptyLocationPresentedItemProvider = resolve()
            let d: EnhancedLocationPresentedItemProvider = resolve()
            let e: SingleLocationPresentedItemProvider = resolve()
            return LocationInsightPresentedItemsProvider(presentedItemsProviders: [a, b, c, d, e])
        }.scope(application)
    }
}
