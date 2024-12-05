//
//  HelpCenterCell.swift
//  Openfield
//
//  Created by Daniel Kochavi on 17/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

class HelpCenterCell: UIControl {
    @IBOutlet var contentView: UIView!
    @IBOutlet var helpCenterLabel: UILabel!

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        setupView()
        setupStaticText()
        setupQA()
    }

    private func setupView() {
        UINib(resource: R.nib.helpCenterCell).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
    }

    private func setupStaticText() {
        helpCenterLabel.text = R.string.localizable.accountHelpCenter()
    }

    private func setupQA() {
        helpCenterLabel.accessibilityIdentifier = "HelpCenterCell_\(R.string.localizable.accountHelpCenter())"
    }
}

