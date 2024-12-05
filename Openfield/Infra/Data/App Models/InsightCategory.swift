//
//  Category.swift
//  Openfield
//
//  Created by amir avisar on 12/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

enum FieldReportType {
    case category(category: InsightCategory)
    case fieldImage(fieldImage: FieldImage)
    case irrigation(irrigation: FieldIrrigation)
    case requestReport(link: URL)
}

struct FieldReportItem   {
    var type: FieldReportType
    var date: Date
}

struct InsightCategory {
    let date: Date
    let categoryId : String
    let insight: LocationInsight
    let locations: [Location]
}

struct FieldImage {
    let imageId: Int
    let image: AppImage
    let date: Date
}

struct FieldIrrigation {
    let categoryId : String
    let insights: [IrrigationInsight]
    let date: Date
}

struct Season {
    let name: String
    let order: Int
}

