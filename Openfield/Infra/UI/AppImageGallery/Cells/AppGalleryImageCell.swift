//
//  AppGalleryImageCell.swift
//  Openfield
//
//  Created by amir avisar on 19/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import FSPagerView
import RxCocoa
import RxSwift
import UIKit

class AppGalleryImageCell: FSPagerViewCell {
    
    @IBOutlet weak var image: TagImageViewer!
    @IBOutlet weak var counterLabel: Title10RegularWhite!
    @IBOutlet weak var shimmerView: AppShimmerView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nightBadge: NightBadge!
    @IBOutlet weak var subtitleContainer: UIView!
    @IBOutlet weak var subtitleLabel: SubHeadlineBoldWhite!
    @IBOutlet weak var dot: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.shadowColor = UIColor.clear.cgColor
        errorLabel.text = R.string.localizable.galleryImageLoadingError()
        image.disableZoom()
        image.isUserInteractionEnabled = false
        image.imageContentMode = .scaleToFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.errorView.isHidden = true
        self.image.isHidden = false
        self.image.setImage(image: nil)
        self.image.clearTags()
        shimmerView.stopShimmering()
    }

    func bind(uiElement: AppImageGalleyUIElement) {
        shimmerView.startShimmering()
        nightBadge.isHidden = !uiElement.isNightImage
        subtitleContainer.isHidden = !uiElement.showSubtitleContainer
        subtitleLabel.text = uiElement.subtitle
        dot.backgroundColor = uiElement.dotColor
        image.clearTags()
        
        image.display(images: uiElement.images, imageTransition: .fade(0.3))  { [weak self] result in
            guard let self = self else { return }
            shimmerView.stopShimmering()
            switch result {
            case .success:
                self.image.drawTags(tags: uiElement.tags, color: uiElement.tagsColor)
                self.errorView.isHidden = true
                self.image.isHidden = false
            case let .failure(error):
                self.image.clearTags()
                self.errorView.isHidden = false
                self.image.isHidden = true
                log.warning("could not retrive image with url - error: \(error)")
            }
        }
        counterLabel.text = "\(uiElement.index)/\(uiElement.sum)"
    }
    
}
