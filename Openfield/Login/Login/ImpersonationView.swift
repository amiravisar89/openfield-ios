//
//  ImpersonationView.swift
//  Openfield
//
//  Created by Yoni Luz on 21/07/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit

class ImpersonationView: UIView {

    @IBOutlet var impersonationButton: SGButton!
    @IBOutlet var loginAsYourselfButton: SGButton!
    @IBOutlet var impersonationExplenation: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet var prefixNumberView: UIView!
    @IBOutlet var suffixNumberView: UIView!
    @IBOutlet var prefixNumberLabel: UILabel!
    @IBOutlet var suffixNumberLabel: UILabel!
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var enterPhoneNumberLabel: Title4BoldPrimary!

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        UINib(resource: R.nib.impersonationView).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
        impersonationExplenation.text = R.string.localizable.loginImpersonationExplenation()
        prefixNumberView.addBottomBorderWithColor(color: R.color.primary()!, width: 2.0)
        suffixNumberView.addBottomBorderWithColor(color: R.color.primary()!, width: 2.0)
        impersonationButton.titleString = R.string.localizable.loginImpersonationButton()
        impersonationButton.loadingTitleString = R.string.localizable.loginImpersonationButton()
        enterPhoneNumberLabel.text = R.string.localizable.loginImpersonationTitle()
        loginAsYourselfButton.titleString = R.string.localizable.loginAsYourself()
        loginAsYourselfButton.loadingTitleString = R.string.localizable.loginAsYourself()
    }
}

extension ImpersonationView {
    static func instanceFromNib() -> ImpersonationView {
        return ImpersonationView(frame: CGRect.zero)
    }
}
