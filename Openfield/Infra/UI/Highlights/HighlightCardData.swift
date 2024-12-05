//
//  HighlightCardData.swift
//  Openfield
//
//  Created by amir avisar on 09/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit

enum HighlightCardDatatype {
    case cardData(data: HighlightCardData)
    case empty(emptyData: HighlightEmptyCardData)
}

struct HighlightUiElement {
    var type: HighlightCardDatatype
    var id: String
    var date: Date
}


struct HighlightCardData {
    let insightUID : String
    let field : String
    let date : String
    let insight : String
    let imageUrl : String
    let insightType : String
}

struct HighlightEmptyCardData {
    let title : String
    let subtitle : String
}
