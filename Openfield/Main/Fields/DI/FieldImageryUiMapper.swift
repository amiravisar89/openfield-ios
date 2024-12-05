//
//  FieldImageryUiMApper.swift
//  Openfield
//
//  Created by amir avisar on 14/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
class FieldImageryUiMapper {
    private var dateProvider: DateProvider

    init(dateProvider: DateProvider) {
        self.dateProvider = dateProvider
    }
    
    func image(fieldImage: FieldImage) -> FieldImageCellUiElement {
        let content = "\(R.string.localizable.fieldLatestImagery()) \(dateProvider.format(date: fieldImage.date, dateStyle: .short))"
        return FieldImageCellUiElement(imageId: fieldImage.imageId,
                                       title: R.string.localizable.fieldSatelliteImagery(),
                                       content: content,
                                       buttonTitle: R.string.localizable.fieldSeeAllImagery(), 
                                       images: [fieldImage.image])
    }

}
