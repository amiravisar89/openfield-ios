//
//  EnterPhoneView.swift
//  Openfield
//
//  Created by Eyal Prospera on 29/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation
import UIKit

class EnterPhoneView: UIView {
    @IBOutlet var sendCodeButton: SGButton!
    @IBOutlet var smsWillBeSent: UILabel!
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
        UINib(resource: R.nib.enterPhoneView).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
        smsWillBeSent.text = R.string.localizable.loginSmsSent()
        prefixNumberView.addBottomBorderWithColor(color: R.color.primary()!, width: 2.0)
        suffixNumberView.addBottomBorderWithColor(color: R.color.primary()!, width: 2.0)
        sendCodeButton.titleString = R.string.localizable.loginSendCode()
        sendCodeButton.loadingTitleString = R.string.localizable.loginSendCode()
        enterPhoneNumberLabel.text = R.string.localizable.loginEnterPhone()
    }
}

extension EnterPhoneView {
    static func instanceFromNib() -> EnterPhoneView {
        return EnterPhoneView(frame: CGRect.zero)
    }
}
