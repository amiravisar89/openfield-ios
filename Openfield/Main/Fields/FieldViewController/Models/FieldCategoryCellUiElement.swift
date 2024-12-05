//
//  FieldCategoryCellUiElement.swift
//  Openfield
//
//  Created by amir avisar on 04/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit

struct FieldCategoryCellUiElement {
    let insightUid: String
    let read: Bool
    let title: String
    let date: String?
    let content : String?
    let highlighted : Bool
    let highlightedText: String?
    let images : [AppImage]
    let tags: [LocationTag]
    let tagColor: UIColor
    let locations : [LocationCoordinateViewModel]
    let coverImage: [SpatialImage]
    let imageStrategy : CategoryImageStrategy
    let trend : Int?
    let summery : String?

}
