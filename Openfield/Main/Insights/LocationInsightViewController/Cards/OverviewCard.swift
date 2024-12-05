//
//  OverviewCard.swift
//  Openfield
//
//  Created by amir avisar on 16/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import UIKit

class OverviewCard: LocationInsightCard {
    var cycleCompletionPrecentage: Int = 0
    let title: String

    var subtitle: String {
        return R.string.localizable.insightCycleCompletion_IOS("\(cycleCompletionPrecentage)%")
    }

    init(cycleCompletionPrecentage: Int, title: String) {
        self.cycleCompletionPrecentage = cycleCompletionPrecentage
        self.title = title
    }

    func getCellIdentifier() -> String {
        return R.reuseIdentifier.overviewCell.identifier
    }
}

// MARK: - Issue Card

class SingleLocationOverviewCard: OverviewCard {
    let items: [SingleLocationOverviewItem]
    let chipsConfig: InsightChipConfig

    init(items: [SingleLocationOverviewItem], chipsConfig: InsightChipConfig, title: String) {
        self.items = items
        self.chipsConfig = chipsConfig
        super.init(cycleCompletionPrecentage: 0, title: title)
    }

    override func getCellIdentifier() -> String {
        return R.reuseIdentifier.singleLocationOverviewCell.identifier
    }
}

// MARK: - Issue Card

class IssueLocationOverviewCard: OverviewCard {
    var issues: [(issueName: String, severity: String)]

    init(cycleCompletionPrecentage: Int, issues: [(issueName: String, severity: String)], title: String) {
        self.issues = issues
        super.init(cycleCompletionPrecentage: cycleCompletionPrecentage, title: title)
    }

    override func getCellIdentifier() -> String {
        return R.reuseIdentifier.issueLocationOverviewCell.identifier
    }
}

// MARK: - Empty Card

class EmptyLocationOverviewCard: OverviewCard {
    var summery: String

    init(cycleCompletionPrecentage: Int, summery: String, title: String) {
        self.summery = summery
        super.init(cycleCompletionPrecentage: cycleCompletionPrecentage, title: title)
    }

    override func getCellIdentifier() -> String {
        return R.reuseIdentifier.emptyLocationOverviewCell.identifier
    }
}

// MARK: - Range Card

protocol RangedLocationOverviewCardItem {}

class RangedLocationOverviewCard: OverviewCard {
    var avgCount: String
    var categories: [RangedLocationOverviewCardItem] = []
    var avgCountTitle: String

    init(cycleCompletionPrecentage: Int, avgCountTitle: String, avgCount: String, categories: [RangedLocationOverviewCardItem], title: String) {
        self.avgCountTitle = avgCountTitle
        self.avgCount = avgCount
        self.categories = categories

        super.init(cycleCompletionPrecentage: cycleCompletionPrecentage, title: title)
    }

    override func getCellIdentifier() -> String {
        return R.reuseIdentifier.rangedLocationOverviewCell.identifier
    }
}

class RangedLocationOverviewCardCategory: RangedLocationOverviewCardItem {
    let color: UIColor
    let range: String
    let percentage: Int

    init(color: UIColor, range: String, percentage: Int) {
        self.color = color
        self.range = range
        self.percentage = percentage
    }
}

class RangedLocationOverviewCardGoal: RangedLocationOverviewCardItem {
    let subtitle: String

    init(subtitle: String) {
        self.subtitle = subtitle
    }
}
