//
//  RangedLocationInsight.swift
//  Openfield
//
//  Created by dave bitton on 27/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import SwiftDate
import UIKit

class RangedLocationInsight: LocationInsight {
    let avgStandCount: Int
    let goalStandCount: Double?

    init(id: Int, uid: String, type: String, subject: String, fieldId: Int, fieldName: String, farmName: String, farmId: Int?, description: String, publishDate: Date, affectedArea: Double, affectedAreaUnit: String, isRead: Bool, tsFirstRead: Date?, timeZone: String?, thumbnail: String?, startDate: Date, endDate: Date, goalStandCount: Double?, scannedAreaPercent: Int, taggedImagesPercent: Int, relativeToLastReport: Int?, coverImage: [SpatialImage], items: [LocationInsightItem], aggregationUnit: String?, avgStandCount: Int, region: Region, category: String, subCategory: String, displayName: String, summery: String?, highlight: String?, cycleId: Int?, publicationYear: Int?) {
        self.avgStandCount = avgStandCount
        self.goalStandCount = goalStandCount

        super.init(id: id, uid: uid, type: type, subject: subject, fieldId: fieldId, fieldName: fieldName, farmName: farmName, farmId: farmId, description: description, publishDate: publishDate, affectedArea: affectedArea, affectedAreaUnit: affectedAreaUnit, isRead: isRead, tsFirstRead: tsFirstRead, timeZone: timeZone, thumbnail: thumbnail, startDate: startDate, endDate: endDate, scannedAreaPercent: scannedAreaPercent, taggedImagesPercent: taggedImagesPercent, relativeToLastReport: relativeToLastReport, coverImage: coverImage, items: items, aggregationUnit: aggregationUnit, region: region, category: category, subCategory: subCategory, displayName: displayName, summery: summery, highlight: highlight, cycleId: cycleId, publicationYear: publicationYear)
    }
}
