//
//  Highlight.swift
//  Openfield
//
//  Created by amir avisar on 14/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import Resolver
import SwiftDate

enum HighlightItemType {
    case insight(insight: Insight, imageUrl: String)
    case empty
}

extension HighlightItemType {
    static func getHighlightItemType(for highlight: Highlight) -> HighlightItemType {
        let insight = highlight.insight
        return .insight(insight: highlight.insight, imageUrl: highlight.imageUrl)
    }
}

struct Highlight {
    let insight: Insight
    let imageUrl: String
}

struct SectionHighlightItem {
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
    
    static func == (lhs: SectionHighlightItem, rhs: SectionHighlightItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}

extension SectionHighlightItem : AnimatedSectionModelType {
    typealias Item = HighlightItem
    
    var identity: String {
        return id
    }
    
    init(original: SectionHighlightItem, items: [Item]) {
        self = original
        self.items = items
    }
}

struct HighlightItem : AnimatableModel {
  var type: HighlightItemType
  var identity: Int
  var date: Date
  typealias identity = Int
  
  static func == (lhs: HighlightItem, rhs: HighlightItem) -> Bool {
    switch (lhs.type, rhs.type) {
    case (.insight(let insightA, let locationImageUrlA), .insight(let insightB, let locationImageUrlB)):
      return insightA.id == insightB.id && lhs.date == rhs.date && lhs.identity == rhs.identity
    default: return false
    }
  }
}
