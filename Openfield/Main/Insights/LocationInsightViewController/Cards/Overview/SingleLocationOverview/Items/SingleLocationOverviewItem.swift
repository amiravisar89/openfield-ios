//
//  SingleLocationOverviewItem.swift
//  Openfield
//
//  Created by amir avisar on 04/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation
import SwiftDate

protocol SingleLocationOverviewItem {
    func getCellIdentifier() -> String
}

struct SingleLocationDateItem: SingleLocationOverviewItem {
    let imageDate: Date
    let fullReportDate: Date
    let region: Region

    init(imageDate: Date, fullReportDate: Date, region: Region) {
        self.imageDate = imageDate
        self.fullReportDate = fullReportDate
        self.region = region
    }

    func getCellIdentifier() -> String {
        return R.reuseIdentifier.singleLocationDateCell.identifier
    }
}

struct SingleLocationImagesItem: SingleLocationOverviewItem {
    let images: [EnhanceImagesData]

    init(images: [EnhanceImagesData]) {
        self.images = images
    }

    func getCellIdentifier() -> String {
        return R.reuseIdentifier.enhanceImagesTableCell.identifier
    }
}

struct SingleLocationTagImageItem: SingleLocationOverviewItem {
    let data: TagsData

    init(data: TagsData) {
        self.data = data
    }

    func getCellIdentifier() -> String {
        return R.reuseIdentifier.singleLocationImageCell.identifier
    }
}
