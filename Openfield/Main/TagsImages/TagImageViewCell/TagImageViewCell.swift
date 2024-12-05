//
//  TagImageViewCell.swift
//  Openfield
//
//  Created by amir avisar on 05/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import AVKit
import NVActivityIndicatorView
import UIKit

class TagImageViewCell: UICollectionViewCell {
    @IBOutlet weak var errorViewHC: NSLayoutConstraint!
    @IBOutlet weak var tagImage: TagImageViewer!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var loader: NVActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagImage.clearTags()
        tagImage.setImage(image: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setAccesabilties()
        loader.color = R.color.valleyBrand()!
    }

    func bind(images: [AppImage], color: UIColor, tags: [LocationTag], showMore _: Bool, isNightImage: Bool) {
        loader.startAnimating()
        if let image = images.first {
            let height = getImageSize(imageSize: image.imageSize).height
            errorViewHC.constant = height
            errorView.layoutIfNeeded()
        }
        tagImage.display(images: images) { [weak self] result in

            guard let self = self else { return }
            self.loader.stopAnimating()
            switch result {
            case .success:
                self.errorView.isHidden = true
                self.tagImage.isHidden = false
            case let .failure(error):
                self.errorView.isHidden = false
                self.tagImage.isHidden = true
                log.warning("Could not retrive image with url - error : \(error)")
            }
            self.tagImage.clearTags()
            self.tagImage.drawTags(tags: tags, color: color)
        }
    }

    private func getImageSize(imageSize: CGSize) -> CGRect {
        let actualImageSize = CGSize(width: imageSize.width, height: imageSize.height)
        let innerImageRect = AVMakeRect(aspectRatio: actualImageSize, insideRect: bounds)
        return innerImageRect
    }

    private func setAccesabilties() {
        tagImage.accessibilityIdentifier = "image"
        errorView.accessibilityIdentifier = "error"
        loader.accessibilityIdentifier = "loader"
    }
}
