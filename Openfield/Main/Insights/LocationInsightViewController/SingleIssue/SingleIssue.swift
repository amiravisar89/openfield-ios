//
//  SingleIssue.swift
//  Openfield
//
//  Created by Itay Kaplan on 10/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import FSPagerView
import RxCocoa
import RxSwift
import UIKit

protocol SingleIssueViewModel {
    var title: String { get }
    var info: String { get }
    var color: UIColor { get }
}

struct SingleLocationIssueViewModel: SingleIssueViewModel {
    static let viewHeight: CGFloat = 250
    var title: String
    var info: String
    var color: UIColor
}

struct SingleLocationEnhancedViewModel: SingleIssueViewModel {
    static let viewHeight: CGFloat = 300
    var title: String
    var info: String
    var color: UIColor
}

class SingleIssue: UIView {
    @IBOutlet var dotView: UIView!
    @IBOutlet var title: BodyBold!
    @IBOutlet var info: BodyRegularPrimary!
    @IBOutlet private var contentView: UIView!
    @IBOutlet var backButton: UIView!
    @IBOutlet var imagesGallery: AppImageGallery!
  
  var shouldFocuseOntitle: Bool = false {
        didSet {
            title.setContentCompressionResistancePriority(shouldFocuseOntitle ? .defaultHigh : .defaultLow, for: .horizontal)
            title.setContentHuggingPriority(shouldFocuseOntitle ? .defaultHigh : .defaultLow, for: .horizontal)
            info.alignment = shouldFocuseOntitle ? "left" : "right"
            info.setContentCompressionResistancePriority(shouldFocuseOntitle ? .defaultLow : .defaultHigh, for: .horizontal)
            info.setContentHuggingPriority(shouldFocuseOntitle ? .defaultLow : .defaultHigh, for: .horizontal)
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(resource: R.nib.singleIssue).instantiate(withOwner: self, options: nil)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        UINib(resource: R.nib.singleIssue).instantiate(withOwner: self, options: nil)
        setup()
    }

    func bind(imagesElements: [AppImageGalleyElement]) {
      setImagesGalleryPagerHeight(imagesElements: imagesElements)
      self.imagesGallery.setImages(images: imagesElements)
    }

    private func setImagesGalleryPagerHeight(imagesElements: [AppImageGalleyElement]) {
      guard let firstImage = imagesElements.first?.images.first, firstImage.width > 0, firstImage.height > 0 else {
          return
      }
      imagesGallery.setPagerHeightBasedOnImageSize(width: CGFloat(firstImage.width), height: CGFloat(firstImage.height))
    }

    private func setup() {
        contentView.frame = bounds
        addSubview(contentView)
        forQA()
    }

    private func forQA() {
        accessibilityIdentifier = "single_issue"
        dotView.accessibilityIdentifier = "dot"
        title.accessibilityIdentifier = "title"
        info.accessibilityIdentifier = "info_button"
        backButton.accessibilityIdentifier = "back_button"
        imagesGallery.accessibilityIdentifier = "image_pager"
    }
}
