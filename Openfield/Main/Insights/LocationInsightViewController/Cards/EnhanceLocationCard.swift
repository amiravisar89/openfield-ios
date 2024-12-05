//
//  EnhanceLocationCard.swift
//  Openfield
//
//  Created by amir avisar on 16/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import UIKit

class EnhanceLocationCard: LocationInsightCard {

    let sections: [EnhanceSectionItem]
    let highlight: String?

    init(sections: [EnhanceSectionItem], highlight: String? = nil) {
        self.sections = sections
        self.highlight = highlight
    }

    func getCellIdentifier() -> String {
        return R.reuseIdentifier.enhanceLocationCell.identifier
    }
}

struct EnhanceLocationImageCard: LocationCard {
    var title: String
    var info: String
    var image: [AppImage]
    var tags: [LocationTag]
    var color: UIColor!
    var showImageLoader: Bool
    var isNightImage: Bool

    func getCellIdentifier() -> String {
        return R.reuseIdentifier.issueCard.identifier
    }
}
