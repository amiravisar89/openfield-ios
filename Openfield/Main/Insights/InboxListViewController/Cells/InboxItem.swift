//
//  InboxItem.swift
//  Openfield
//
//  Created by Daniel Kochavi on 06/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation
import Resolver
import SwiftDate

enum InboxItemType {
    case insight(insight: IrrigationInsight)
    case imagery(imagery: Imagery)
    case locationInsight(insight: LocationInsight)
}

extension InboxItemType {
    static func getInboxItemType(for insight: Insight) -> InboxItemType {
        if insight is IrrigationInsight { return .insight(insight: insight as! IrrigationInsight) }
        if insight is LocationInsight { return .locationInsight(insight: insight as! LocationInsight) }
        return .insight(insight: insight as! IrrigationInsight)
    }
}

struct SectionInboxItem: SectionModel {
    var startDate: Date
    var endDate: Date
    var items: [Item]
    var id: String

    var sectionTitle: String {
        let dateProvier: DateProvider = Resolver.resolve()
        let now = Date()
        if startDate.isTheSameWeek(as: now) {
            return R.string.localizable.feedThisWeek()
        } else {
            return String(format: "%@ - %@", dateProvier.format(date: startDate, region: Region.local, format: .short), dateProvier.format(date: endDate, region: Region.local, format: .short))
        }
    }

    static func == (lhs: SectionInboxItem, rhs: SectionInboxItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}

extension SectionInboxItem {
    typealias Item = InboxItem

    var identity: String {
        return id
    }

    init(original: SectionInboxItem, items: [Item]) {
        self = original
        self.items = items
    }
}

struct InboxItem {
    var type: InboxItemType
    var identity: Int
    var isRead: Bool
    var date: Date
    typealias identity = Int

    static func == (lhs: InboxItem, rhs: InboxItem) -> Bool {
        switch (lhs.type, rhs.type) {
        case let (.insight(insight: insightA), .insight(insight: insightB)):
            return insightA.id == insightB.id && insightA.isRead == insightB.isRead
        case let (.imagery(imagery: imageryA), .imagery(imagery: imageryB)):
            return imageryA.identity == imageryB.identity && imageryA.isRead == imageryB.isRead
        default:
            return false
        }
    }
}
