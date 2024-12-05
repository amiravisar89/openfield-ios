//
//  Category.swift
//  Openfield
//
//  Created by amir avisar on 12/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

enum FieldCellType {
    case category(category: InsightCategory)
    case fieldImage(fieldImage: FieldImage)
}

struct FieldReportItem   {
    
    var type: FieldCellType
    var date: Date

}

struct InsightCategory {
    let categoryId : String
    let insight: Insight
    let locations: [Location]
}

struct FieldImage {
    let imageId: Int
    let image: AppImage
    let date: Date
}

