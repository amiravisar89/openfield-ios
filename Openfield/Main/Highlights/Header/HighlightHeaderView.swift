//
//  HighlightHeaderView.swift
//  Openfield
//
//  Created by amir avisar on 15/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit

class HighlightHeaderView: UIView {
    static let height: CGFloat = 50

    @IBOutlet var titleLabel: BodySemiBoldBlack!
    @IBOutlet private var contentView: UIView!

    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        UINib(resource:
            R.nib.highlightHeaderView).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = R.color.screenBg()!
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

extension HighlightHeaderView {
    static func instanceFromNib(rect: CGRect) -> HighlightHeaderView {
        return HighlightHeaderView(frame: rect)
    }
}

