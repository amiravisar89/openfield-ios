//
//  SingleIssueCell.swift
//  Openfield
//
//  Created by Itay Kaplan on 11/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import FSPagerView
import Kingfisher
import NVActivityIndicatorView
import UIKit

class SingleIssueCell: FSPagerViewCell {
    @IBOutlet var bgView: UIView!
    @IBOutlet var tagImageView: TagImageViewer!
    @IBOutlet var loadingIndicator: NVActivityIndicatorView!
    @IBOutlet var placeholderImageView: UIImageView!
    @IBOutlet var indexLbl: UILabel!
    @IBOutlet var indexView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 2.74
        bgView.layer.masksToBounds = true
        // Init Loading
        loadingIndicator.color = R.color.valleyBrand()!
        loadingIndicator.type = .circleStrokeSpin
        forQA()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        tagImageView.clearTags()
        tagImageView.setImage(image: nil)
    }

    func bind(images: [AppImage], tagsArray: [LocationTag], isSelected: Bool, TagsColor: UIColor, index: String) {
        placeholderImageView.isHidden = true
        indexView.isHidden = !isSelected
        indexLbl.text = index
        accessibilityIdentifier = index
        loadingIndicator.startAnimating()
        tagImageView.clearTags()

        tagImageView.display(images: images) { [weak self] result in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
            switch result {
            case .success:
                self.placeholderImageView.isHidden = true
                self.tagImageView.drawTags(tags: tagsArray, color: TagsColor)
            case let .failure(error):
                if error.errorCode != 1003 { // cancel task error
                    self.placeholderImageView.isHidden = false
                } else {
                    self.placeholderImageView.isHidden = true
                }
            }
        }
    }

    private func forQA() {
        accessibilityIdentifier = "issue_cell"
        tagImageView.accessibilityIdentifier = "image"
        loadingIndicator.accessibilityIdentifier = "loader"
        placeholderImageView.accessibilityIdentifier = "image_placeholder"
        indexLbl.accessibilityIdentifier = "index_title"
        indexView.accessibilityIdentifier = "index_view"
    }
}
