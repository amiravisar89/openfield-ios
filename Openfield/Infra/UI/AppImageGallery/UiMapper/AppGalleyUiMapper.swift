//
//  AppGalleyUiMapper.swift
//  Openfield
//
//  Created by amir avisar on 19/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit

class AppGalleyUiMapper {

    func map(elements: [AppImageGalleyElement]) -> [AppImageGalleyUIElement] {
        return elements.enumerated().map { index, element in
            return AppImageGalleyUIElement(images: element.images, index: index + 1, sum: elements.count, isNightImage: element.isNightImage, tagsColor: R.color.enhancedLocationColor()!, tags: element.tags, showSubtitleContainer: element.showSubtitleContainer, dotColor: element.dotColor, subtitle: element.subtitle)
        }
    }
    
}
