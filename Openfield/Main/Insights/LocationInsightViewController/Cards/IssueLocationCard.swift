//
//  IssueLocationCard.swift
//  Openfield
//
//  Created by amir avisar on 16/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import UIKit

protocol LocationCard: LocationInsightCard {
    var title: String { get set }
    var info: String { get set }
    var image: [AppImage] { get set }
    var tags: [LocationTag] { get set }
    var color: UIColor! { get set }
    var showImageLoader: Bool { get set }
}

struct IssueLocationCard: LocationCard {
    var title: String
    var info: String
    var image: [AppImage]
    var tags: [LocationTag]
    var color: UIColor!
    var showImageLoader: Bool
    var description: String?
    var isNightImage: Bool

    func getCellIdentifier() -> String {
        return R.reuseIdentifier.issueCard.identifier
    }
}
