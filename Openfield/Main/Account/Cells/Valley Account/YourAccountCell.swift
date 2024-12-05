//
//  YourAccountCell.swift
//  Openfield
//
//  Created by Eyal Prospera on 31/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

class YourAccountCell: UIControl {
    @IBOutlet var contentView: UIView!
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var manageTeamLabel: UILabel!
    @IBOutlet var infoImage: UIImageView!
    @IBOutlet var availbleLabel: UILabel!

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
    }

    private func setupView() {
        UINib(resource: R.nib.yourAccountCell).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
        infoImage.image = R.image.info_blue()
        infoImage.tintColor = R.color.valleyBrand()
    }

    private func setupStaticText() {
        accountLabel.text = R.string.localizable.accountYourAccount()
        manageTeamLabel.text = R.string.localizable.accountManageAccount()
        availbleLabel.text = R.string.localizable.accountAvailbleOnWeb()
    }
}

