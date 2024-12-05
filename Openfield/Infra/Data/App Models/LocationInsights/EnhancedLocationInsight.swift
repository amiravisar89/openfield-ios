//
//  EnhancedLocationInsight.swift
//  Openfield
//
//  Created by amir avisar on 02/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import SwiftDate
import UIKit

class EnhancedLocationInsight: LocationInsight {
    let enhanceData: LocationInsightEnhanceData

    init(id: Int, uid: String, type: String, subject: String, fieldId: Int, fieldName: String, farmName: String, farmId: Int?, description: String, publishDate: Date, affectedArea: Double, affectedAreaUnit: String, isRead: Bool, tsFirstRead: Date?, timeZone: String?, thumbnail: String?, startDate: Date, endDate: Date, scannedAreaPercent: Int, taggedImagesPercent: Int, relativeToLastReport: Int?, coverImage: [SpatialImage], items: [LocationInsightItem], aggregationUnit: String?, region: Region, enhanceData: LocationInsightEnhanceData, category: String, subCategory: String, displayName: String, summery: String?, highlight: String?, cycleId: Int?, publicationYear: Int?) {
        self.enhanceData = enhanceData

        super.init(id: id, uid: uid, type: type, subject: subject, fieldId: fieldId, fieldName: fieldName, farmName: farmName, farmId: farmId, description: description, publishDate: publishDate, affectedArea: affectedArea, affectedAreaUnit: affectedAreaUnit, isRead: isRead, tsFirstRead: tsFirstRead, timeZone: timeZone, thumbnail: thumbnail, startDate: startDate, endDate: endDate, scannedAreaPercent: scannedAreaPercent, taggedImagesPercent: taggedImagesPercent, relativeToLastReport: relativeToLastReport, coverImage: coverImage, items: items, aggregationUnit: aggregationUnit, region: region, category: category, subCategory: subCategory, displayName: displayName, summery: summery, highlight: highlight, cycleId: cycleId, publicationYear: publicationYear)
    }
}

struct LocationInsightEnhanceData {
    let title: String
    let subtitle: String
    let locationsAggValue: String?
    let locationsAggName: String
    let isSeverity: Bool
    let ranges: LocationInsightRange
}

struct LocationInsightRange {
    let title: String
    let midtitle: String
    let subtitle: String
    let levels: [LocationInsightLevel]
}

struct LocationInsightLevel {
    let order: Int
    let color: UIColor
    let value: Int
    let name: String
    let relativeToLastReport: Int?
    let locationIds: [Int]
    let id: Int?
}
