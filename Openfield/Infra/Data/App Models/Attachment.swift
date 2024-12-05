//
//  Attachment.swift
//  Openfield
//
//  Created by Itay Kaplan on 22/12/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import GEOSwift

struct Attachment {
    let insightUid: String
    let items: [AttachmentItem]
}

struct AttachmentItem {
    let data: AttachmentDataItem
    let type: String
}

struct AttachmentDataItem {
    let id: Int
    let latitude: Double
    let longitude: Double
    let images: [AttachmentDataItemImage]
}

struct AttachmentDataItemImage {
    let id: Int
    let date: Date
    let itemId: Int
    let isCover: Bool
    let longitude: Double
    let latitude: Double
    let tags: [FeatureCollection]
    let previews: [LocationImage]
}

struct LocationImage {
    let url: String
    let width: Int
    let height: Int
}

struct Coordinates {
    let latitude: Double
    let longitude: Double
}
