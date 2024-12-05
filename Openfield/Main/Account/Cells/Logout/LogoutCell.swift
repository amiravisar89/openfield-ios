//
//  LogoutCell.swift
//  Openfield
//
//  Created by Eyal Prospera on 31/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

class LogoutCell: UIControl {
    @IBOutlet var contentView: UIView!
    @IBOutlet var logoutLabel: UILabel!

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
        setupLogoutText()
    }

    private func setupView() {
        UINib(resource: R.nib.logoutCell).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
    }

    private func setupLogoutText() {
        logoutLabel.text = R.string.localizable.accountLogout()
    }
}
