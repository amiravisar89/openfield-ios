//
//  HighlightInsightCardProvider.swift
//  Openfield
//
//  Created by amir avisar on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

class HighlightInsightCardProvider: HighlightsCardsProvider {
    
    let dateProvider: DateProvider
    
    init(dateProvider: DateProvider) {
        self.dateProvider = dateProvider
    }
    
    func cards(highlights: [HighlightItem]) -> [HighlightUiElement] {
        return highlights.compactMap { card(highlight: $0) }
    }

    func card(highlight: HighlightItem) -> HighlightUiElement? {
        switch highlight.type {
        case .insight(let insight, let imageUrl):
            guard let date = dateProvider.daysTimeAgoSince(insight.publishDate) else {return nil}
            var insightTypeString = insight.subject
            if insight is IrrigationInsight {
                insightTypeString = R.string.localizable.fieldIrrigationInsights()
            } else if let locationInsight = insight as? LocationInsight {
                if insight is SingleLocationInsight {
                    insightTypeString = R.string.localizable.insightFirstDetectionLowerCase()
                } else {
                    insightTypeString = insight.subject + " (\(dateProvider.format(date: locationInsight.startDate, format: .short)) - \(dateProvider.format(date: locationInsight.endDate, format: .short)))"
                }
            }
            return HighlightUiElement(type: .cardData(data: HighlightCardData(insightUID: insight.uid, field: insight.fieldName, date: date, insight: insight.highlight ?? insight.subject, imageUrl: imageUrl, insightType: insightTypeString)), id: insight.uid, date: insight.publishDate)
        case .empty:
            return HighlightUiElement(type: .empty(emptyData: HighlightEmptyCardData(title: R.string.localizable.highlightsNoRescentHighlights(), subtitle: R.string.localizable.highlightsClickOnShowAll())), id: String(Int.zero), date: Date())
        }

    }
    
}
