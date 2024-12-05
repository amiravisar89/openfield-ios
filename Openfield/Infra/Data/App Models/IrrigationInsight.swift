//
//  IrrigationInsight.swift
//  Openfield
//
//  Created by Daniel Kochavi on 27/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation
import GEOSwift
import RxDataSources
import SwiftDate
import Then

class IrrigationInsight: Insight, IdentifiableType, AnimatableModel, Then {
    typealias Identity = Int

    var identity: Int {
        return hashValue
    }

    var imageDate: Date
    var images: [InsightImage]? = nil
    let mainImage: InsightImage?
    var review: InsightReview? = nil
    var feedback: Feedback
    var isSelected: Bool = false
    let tag: InsightTag
    let dateRegion: Region

    init(id: Int, uid: String, type: String, subject: String, fieldId: Int, fieldName: String, farmName: String, farmId: Int?, description: String, publishDate: Date, affectedArea: Double, affectedAreaUnit: String, isRead: Bool, tsFirstRead: Date?, timeZone: String?, imageDate: Date, thumbnail: String, images: [InsightImage]?, mainImage: InsightImage?, review: InsightReview?, feedback: Feedback, isSelected: Bool, tag: InsightTag, dateRegion: Region, category: String, subCategory: String, displayName: String, highlight: String?, cycleId: Int?, publicationYear: Int?) {
        self.imageDate = imageDate
        self.images = images
        self.mainImage = mainImage
        self.review = review
        self.feedback = feedback
        self.isSelected = isSelected
        self.tag = tag
        self.dateRegion = dateRegion

        super.init(id: id, uid: uid, type: type, subject: subject, fieldId: fieldId, fieldName: fieldName, farmName: farmName, farmId: farmId, description: description, publishDate: publishDate, affectedArea: affectedArea, affectedAreaUnit: affectedAreaUnit, isRead: isRead, tsFirstRead: tsFirstRead, timeZone: timeZone, thumbnail: thumbnail, category: category, subCategory: subCategory, displayName: displayName, highlight: highlight, cycleId: cycleId, publicationYear: publicationYear)
    }
}

struct InsightReview: Hashable {
    let rating: Int
    let selectedReason: Int
}

struct InsightImage: Hashable {
    let date: Date
    let id: Int
    let bounds: ImageBounds
    let type: AppImageType
    let issue: Issue?
    let previews: [PreviewImage]
    let sourceType: ImageSourceType
}

struct InsightTag: Hashable {
    let id: Int
    let tag: GeoJSON
}

struct Issue: Hashable {
    let comment: String?
    let isHidden: Bool?
    let issue: IssueType?
}

enum IssueType: String {
    case clouds
    case sharpness
    case geo_registration
    case darkness
    case cropping
    case wraping
    case lens_dirt
    case saturation
    case waves
    case distortion
    case shadow
    case empty
}
