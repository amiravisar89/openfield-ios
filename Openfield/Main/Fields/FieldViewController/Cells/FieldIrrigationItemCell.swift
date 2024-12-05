//
//  FieldIrrigationItemCell.swift
//  Openfield
//
//  Created by amir avisar on 14/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import UIKit

class FieldIrrigationItemCell: UITableViewCell {
    
    static let height = 98.0

    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var readDot: UIView!
    @IBOutlet weak var insightImage: ImageViewer!
    @IBOutlet weak var titleLabel: Title9SemiBoldBlack!
    @IBOutlet weak var contentLabel: Title6Regular!
    @IBOutlet weak var dateLabel: Title6RegularGray8!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.lineBreakMode = .byTruncatingMiddle
    }

    func bind(uiElement: FieldIrrigationItemUiElement) {
        titleLabel.text = uiElement.title
        contentLabel.text = uiElement.content
        dateLabel.text = uiElement.date
        insightImage.display(images: uiElement.images)
        readDot.isHidden = uiElement.read
        titleLabel.font = uiElement.read ? R.font.avertaRegular(size: titleLabel.font.pointSize) : R.font.avertaSemibold(size: titleLabel.font.pointSize)
        bottomLine.isHidden = !uiElement.bottomLineVisible
    }
}
