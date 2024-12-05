//
//  FeedSectionHeaderView.swift
//  Openfield
//
//  Created by amir avisar on 19/05/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import UIKit

class FeedSectionHeaderView: UIView {
    // MARK: - Static members

    static let height: CGFloat = 50

    // MARK: - Outlets

    @IBOutlet var titleLabel: BodyRegularSecondary!
    @IBOutlet private var contentView: UIView!

    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    // MARK: - required

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    // MARK: - UI

    private func setup() {
        setupView()
    }

    private func setupView() {
        UINib(resource:
            R.nib.feedSectionHeaderView).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = R.color.screenBg()!
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

extension FeedSectionHeaderView {
    static func instanceFromNib(rect: CGRect) -> FeedSectionHeaderView {
        return FeedSectionHeaderView(frame: rect)
    }
}
