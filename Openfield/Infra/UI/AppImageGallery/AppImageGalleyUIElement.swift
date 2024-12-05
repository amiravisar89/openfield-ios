//
//  AppImageGalleyUIElement.swift
//  Openfield
//
//  Created by amir avisar on 19/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit

struct AppImageGalleyUIElement {
    let images : [AppImage]
    let index: Int
    let sum: Int
    let isNightImage: Bool
    let tagsColor: UIColor
    let tags: [LocationTag]
    let showSubtitleContainer : Bool
    let dotColor: UIColor
    let subtitle: String
}
