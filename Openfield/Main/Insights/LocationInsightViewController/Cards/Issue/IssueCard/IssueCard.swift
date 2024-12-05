//
//  IssueCard.swift
//  Openfield
//
//  Created by Itay Kaplan on 06/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import FSPagerView
import NVActivityIndicatorView
import RxSwift
import UIKit

class IssueCard: FSPagerViewCell {
    // MARK: - Outlets

    @IBOutlet weak var title: BodyBoldPrimary!
    @IBOutlet weak var info: BodyRegularPrimary!
    @IBOutlet weak var dot: UIView!
    @IBOutlet weak var tagImage: TagImageViewer!
    @IBOutlet weak var loader: NVActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: BodyRegularSecondary!
    @IBOutlet weak var descriptionLabelHC: NSLayoutConstraint!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var nightBadge: NightBadge!
    
    let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLabel.font = R.font.avertaRegular(size: 14)
        errorView.isHidden = true
        loader.color = R.color.valleyBrand()!
        addAccesabilties()
    }

    // MARK: - Bind

    func bind(title: String, info: String, description: String?, dotColor: UIColor, image: [AppImage], tags: [LocationTag], showLoader: Bool, isNightImage: Bool) {
        self.nightBadge.isHidden = !isNightImage
        self.title.text = title
        self.info.text = info
        if let diaplayDescription = description {
            setDescriptionLabel(diaplayDescription)
        }
        dot.backgroundColor = dotColor
        isUserInteractionEnabled = !showLoader
        loader.startAnimating()
        tagImage.shoulSwitchImages = false
        errorView.isHidden = true
        guard !image.isEmpty else {
            return
        }
        tagImage.display(images: image) { [weak self] result in
            guard let self = self else {
                return
            }
            self.loader.stopAnimating()
            self.tagImage.clearTags()
            switch result {
            case .success:
                self.tagImage.drawTags(tags: tags, color: dotColor)
                self.tagImage.focus(animation: false)
                self.errorView.isHidden = true
            case .failure:
                self.errorView.isHidden = false
            }
        }
    }

    private func setDescriptionLabel(_ description: String) {
        descriptionLabel.text = description
        descriptionLabel.sizeToFit()
        descriptionLabelHC.constant = descriptionLabel.frame.height
    }

    private func addAccesabilties() {
        title.accessibilityIdentifier = "title"
        info.accessibilityIdentifier = "info"
        dot.accessibilityIdentifier = "dot"
        tagImage.accessibilityIdentifier = "tagImage"
        loader.accessibilityIdentifier = "loader"
        descriptionLabel.accessibilityIdentifier = "description"
        errorView.accessibilityIdentifier = "errorView"
    }
}
