//
//  LocationInsight.swift
//  Openfield
//
//  Created by Itay Kaplan on 23/12/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import SwiftDate

class LocationInsight: Insight {
    let aggregationUnit: String?
    let startDate: Date
    let endDate: Date

    let scannedAreaPercent: Int
    let taggedImagesPercent: Int
    let relativeToLastReport: Int?

    let coverImage: [SpatialImage]
    let dateRegion: Region
    var items: [LocationInsightItem]
    let summery: String?

    init(id: Int, uid: String, type: String, subject: String, fieldId: Int, fieldName: String, farmName: String, farmId: Int?, description: String, publishDate: Date, affectedArea: Double, affectedAreaUnit: String, isRead: Bool, tsFirstRead: Date?, timeZone: String?, thumbnail: String?, startDate: Date, endDate: Date, scannedAreaPercent: Int, taggedImagesPercent: Int, relativeToLastReport: Int?, coverImage: [SpatialImage], items: [LocationInsightItem], aggregationUnit: String?, region: Region, category: String, subCategory: String, displayName: String, summery: String?, highlight: String?, cycleId: Int?, publicationYear: Int?) {
        self.aggregationUnit = aggregationUnit
        self.startDate = startDate
        self.endDate = endDate

        self.scannedAreaPercent = scannedAreaPercent
        self.taggedImagesPercent = taggedImagesPercent
        self.relativeToLastReport = relativeToLastReport

        self.coverImage = coverImage
        self.items = items
        self.summery = summery
        dateRegion = region

        super.init(id: id, uid: uid, type: type, subject: subject, fieldId: fieldId, fieldName: fieldName, farmName: farmName, farmId: farmId, description: description, publishDate: publishDate, affectedArea: affectedArea, affectedAreaUnit: affectedAreaUnit, isRead: isRead, tsFirstRead: tsFirstRead, timeZone: timeZone, thumbnail: thumbnail, category: category, subCategory: subCategory, displayName: displayName, highlight: highlight, cycleId: cycleId, publicationYear: publicationYear)
    }
}

struct LocationInsightItem {
    let id: Int
    let name: String
    let description: String?
    let taggedImagesPercent: Int
    let displayedValue: String?
    var minRange: Int?
    var maxRange: Int?
    let enhanceData: LocationInsightEnhanceData?

    init(id: Int, name: String, description: String?, taggedImagesPercent: Int, displayedValue: String?, minRange: Int? = nil, maxRange: Int? = nil, enhanceData: LocationInsightEnhanceData? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.taggedImagesPercent = taggedImagesPercent
        self.displayedValue = displayedValue
        self.minRange = minRange
        self.maxRange = maxRange
        self.enhanceData = enhanceData
    }
}
