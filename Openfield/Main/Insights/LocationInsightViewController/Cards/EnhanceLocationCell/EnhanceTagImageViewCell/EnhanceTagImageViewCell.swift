//
//  EnhanceTagImageViewCell.swift
//  Openfield
//
//  Created by amir avisar on 17/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import UIKit

class EnhanceTagImageViewCell: TagImageViewCell {
    @IBOutlet var showMoreView: UIView!
    @IBOutlet var showMoreLabel: CaptionBoldWhite!
    @IBOutlet weak var nightBadge: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        showMoreView.backgroundColor = R.color.black60()!
        forQA()
    }

    private func forQA() {
        accessibilityIdentifier = "image_cell"
        showMoreLabel.accessibilityIdentifier = "show_more"
        tagImage.accessibilityIdentifier = "image"
    }

    override func bind(images: [AppImage], color: UIColor, tags: [LocationTag], showMore: Bool, isNightImage: Bool) {
        super.bind(images: images, color: color, tags: tags, showMore: showMore, isNightImage: isNightImage)
        nightBadge.isHidden = !isNightImage
        showMoreView.isHidden = !showMore
        tagImage.isUserInteractionEnabled = false
        showMoreLabel.text = R.string.localizable.showMore()
        tagImage.focus(animation: false)
    }
}
