//
//  Insight.swift
//  Openfield
//
//  Created by Itay Kaplan on 24/12/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

class Insight {
    let id: Int
    let uid: String
    let type: String
    let subject: String
    let fieldId: Int
    let fieldName: String
    let farmName: String
    let farmId: Int?
    let description: String
    var publishDate: Date
    let affectedArea: Double
    let affectedAreaUnit: String
    var isRead: Bool
    let tsFirstRead: Date?
    let timeZone: String?
    let thumbnail: String?
    let category: String
    let subCategory: String
    let displayName : String
    let highlight: String?
    let cycleId: Int?
    let publicationYear: Int?

    init(id: Int, uid: String, type: String, subject: String, fieldId: Int, fieldName: String, farmName: String, farmId: Int?, description: String, publishDate: Date, affectedArea: Double, affectedAreaUnit: String, isRead: Bool, tsFirstRead: Date?, timeZone: String?, thumbnail: String?, category: String, subCategory: String, displayName: String, highlight: String?, cycleId: Int?, publicationYear: Int?) {
        self.id = id
        self.uid = uid
        self.type = type
        self.subject = subject
        self.fieldId = fieldId
        self.fieldName = fieldName
        self.farmName = farmName
        self.farmId = farmId
        self.description = description
        self.publishDate = publishDate
        self.affectedArea = affectedArea
        self.isRead = isRead
        self.tsFirstRead = tsFirstRead
        self.timeZone = timeZone
        self.thumbnail = thumbnail
        self.affectedAreaUnit = affectedAreaUnit
        self.category = category
        self.subCategory = subCategory
        self.displayName = displayName
        self.highlight = highlight
        self.cycleId = cycleId
        self.publicationYear = publicationYear
    }
}

extension Insight: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Insight, rhs: Insight) -> Bool {
        return lhs.id == rhs.id
    }
}
