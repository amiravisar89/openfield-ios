//
//  EnhanceItem.swift
//  Openfield
//
//  Created by amir avisar on 03/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import Resolver
import RxSwift
import UIKit

struct EnhanceSectionItem: SectionModel {
    var id: String
    var items: [Item]
    let title: String
    let summery: String

    init(items: [EnhanceItem], title: String, summery: String, id: String) {
        self.items = items
        self.title = title
        self.summery = summery
        self.id = id
    }

    static func == (lhs: EnhanceSectionItem, rhs: EnhanceSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}

extension EnhanceSectionItem {
    typealias Item = EnhanceItem

    var identity: String {
        return id
    }

    init(original: EnhanceSectionItem, items: [Item]) {
        self = original
        self.items = items
    }
}

struct EnhanceItem {
    typealias identity = String
    let identity: String
    var type: EnhanceItemTypes

    init(identity: String, type: EnhanceItemTypes) {
        self.identity = identity
        self.type = type
    }

    static func == (lhs: EnhanceItem, rhs: EnhanceItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}

enum EnhanceItemTypes {
    case severity(severity: EnhanceSeverityTableCellData)
    case imagesCollection(images: [EnhanceImagesData])
    case description(itemDescription: EnhanceItemDescription)
}

struct EnhanceItemDescription {
    let title: String
    let summery: String
}

struct EnhanceSeverityTableCellData {
    let title: String
    let midtitle: String
    let subtitle: String
    let severityCells: [severityCell]
}

struct severityCell {
    let order: Int
    let color: UIColor
    let name: String
    let value: Int
    let relativeToLastValue: Int?
}

struct EnhanceImagesData {
    let image: [AppImage]
    let tags: [LocationTag]
    let showMore: Bool
    let color: UIColor
    let isNightImage: Bool
}
