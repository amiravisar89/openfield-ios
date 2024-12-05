//
//  SingleLocationInsight.swift
//  Openfield
//
//  Created by amir avisar on 01/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation
import SwiftDate
import UIKit

class SingleLocationInsight: LocationInsight {
    let firstDetectionData: FirstDetectionData

    init(id: Int, uid: String, type: String, subject: String, fieldId: Int, fieldName: String, farmName: String, farmId: Int?, description: String, publishDate: Date, affectedArea: Double, affectedAreaUnit: String, isRead: Bool, tsFirstRead: Date?, timeZone: String?, thumbnail: String?, startDate: Date, endDate: Date, scannedAreaPercent: Int, taggedImagesPercent: Int, relativeToLastReport: Int?, coverImage: [SpatialImage], items: [LocationInsightItem], aggregationUnit: String?, region: Region, firstDetectionData: FirstDetectionData, category: String, subCategory: String, displayName: String, summery: String?, highlight: String?, cycleId: Int?, publicationYear: Int?) {
        self.firstDetectionData = firstDetectionData

        super.init(id: id, uid: uid, type: type, subject: subject, fieldId: fieldId, fieldName: fieldName, farmName: farmName, farmId: farmId, description: description, publishDate: publishDate, affectedArea: affectedArea, affectedAreaUnit: affectedAreaUnit, isRead: isRead, tsFirstRead: tsFirstRead, timeZone: timeZone, thumbnail: thumbnail, startDate: startDate, endDate: endDate, scannedAreaPercent: scannedAreaPercent, taggedImagesPercent: taggedImagesPercent, relativeToLastReport: relativeToLastReport, coverImage: coverImage, items: items, aggregationUnit: aggregationUnit, region: region, category: category, subCategory: subCategory, displayName: displayName, summery: summery, highlight: highlight, cycleId: cycleId, publicationYear: publicationYear)
    }
}

struct FirstDetectionData {
    let title: String
    let imageDate: Date
    let fullReportDate: Date
}
