//
//  YourRollCell.swift
//  Openfield
//
//  Created by amir avisar on 12/04/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

class YourRollCell: UIControl {
    // MARK: - Outlets

    @IBOutlet var contentView: UIView!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: BodyBoldPrimary!

    // MARK: - Members

    // MARK: - Override

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
            R.nib.yourRollCell).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
        titleLabel.text = R.string.localizable.accountMyRole()
    }
}

