//
//  AppTagView.swift
//  Openfield
//
//  Created by amir avisar on 08/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.

import Foundation
import NVActivityIndicatorView
import TagListView
import UIKit

@IBDesignable
class AppTagView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var tagImage: TagImageViewer!
    @IBOutlet var errorView: UIView!
    @IBOutlet var loader: NVActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupView() {
        UINib(resource: R.nib.appTagView).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in make.left.right.top.bottom.equalToSuperview() }
        setAccesabilties()
    }

    func bind(data: TagsData) {
        loader.startAnimating()
        tagImage.display(images: data.image) { [weak self] result in
            guard let self = self else { return }
            self.loader.stopAnimating()
            switch result {
            case .success:
                self.errorView.isHidden = true
                self.tagImage.isHidden = false
            case let .failure(error):
                self.errorView.isHidden = false
                self.tagImage.isHidden = true
                log.warning("Could not retrive image with url - error: \(error)")
            }
            self.tagImage.clearTags()
            self.tagImage.drawTags(tags: data.tags, color: data.color)
        }
    }

    private func setAccesabilties() {
        tagImage.accessibilityIdentifier = "image"
        errorView.accessibilityIdentifier = "error"
        loader.accessibilityIdentifier = "loader"
    }
}

struct TagsData {
    let image: [AppImage]
    let tags: [LocationTag]
    let color: UIColor
}
