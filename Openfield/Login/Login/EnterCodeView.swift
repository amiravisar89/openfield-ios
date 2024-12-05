//
//  EnterCodeView.swift
//  Openfield
//
//  Created by Itay Kaplan on 30/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import UIKit

class EnterCodeView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var firstCodeNumberView: UIView!
    @IBOutlet var firstCodeNumberLabel: UILabel!
    @IBOutlet var secondCodeNumberView: UIView!
    @IBOutlet var secondCodeNumberLabel: UILabel!
    @IBOutlet var thirdCodeNumberView: UIView!
    @IBOutlet var thirdCodeNumberLabel: UILabel!
    @IBOutlet var forthCodeNumberView: UIView!
    @IBOutlet var forthCodeNumberLabel: UILabel!
    @IBOutlet var fifthCodeNumberView: UIView!
    @IBOutlet var fifthCodeNumberLabel: UILabel!
    @IBOutlet var sixthCodeNumberView: UIView!
    @IBOutlet var sixthCodeNumberLabel: UILabel!
    @IBOutlet var title: UILabel!

    @IBOutlet var loginButton: SGButton!
    @IBOutlet var codeStackView: UIStackView!
    @IBOutlet var errorLabel: SGLabelStyleBase!
    @IBOutlet var codeInfoLabel: UILabel!

    @IBOutlet var resendCodeLabel: UILabel!
    @IBOutlet var didNotReceiveLabel: CaptionRegularPrimary!

    @IBOutlet var loadingIndicator: NVActivityIndicatorView!
    private var allLabels: [UILabel] {
        return [firstCodeNumberLabel, secondCodeNumberLabel, thirdCodeNumberLabel, forthCodeNumberLabel, fifthCodeNumberLabel, sixthCodeNumberLabel]
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
        enterCodeViewSetUp()
        setupStaticColor()
        setupStaticText()
        setCodeDigitView(borderColor: R.color.primary()!, borderWidth: 2.0)
    }

    private func setupStaticColor() {
        loadingIndicator.color = R.color.valleyBrand()!
        loadingIndicator.type = .circleStrokeSpin
    }

    public func setupStaticText() {
        let attributedString = NSMutableAttributedString(string: R.string.localizable.loginResendCode())
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 0, length: attributedString.length))
        resendCodeLabel.attributedText = attributedString
        loginButton.titleString = R.string.localizable.loginEnterCode()

        loginButton.loadingTitleString = R.string.localizable.loginVerifyCode()
        title.text = R.string.localizable.loginEnterCode()
        didNotReceiveLabel.text = R.string.localizable.loginNotReceive()
    }

    public func setCode(codeString: [String]) {
        for (index, label) in allLabels.enumerated() {
            label.text = (codeString.count) > index ? codeString[index] : ""
        }
    }

    private func enterCodeViewSetUp() {
        UINib(resource: R.nib.enterCodeView).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds

        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
    }

    private func setCodeDigitView(borderColor: UIColor, borderWidth: CGFloat) {
        firstCodeNumberView.addBottomBorderWithColor(color: borderColor, width: borderWidth)
        secondCodeNumberView.addBottomBorderWithColor(color: borderColor, width: borderWidth)
        thirdCodeNumberView.addBottomBorderWithColor(color: borderColor, width: borderWidth)
        forthCodeNumberView.addBottomBorderWithColor(color: borderColor, width: borderWidth)
        fifthCodeNumberView.addBottomBorderWithColor(color: borderColor, width: borderWidth)
        sixthCodeNumberView.addBottomBorderWithColor(color: borderColor, width: borderWidth)
    }
}

extension EnterCodeView {
    static func instanceFromNib() -> EnterCodeView {
        return EnterCodeView(frame: CGRect.zero)
    }
}

extension Reactive where Base: EnterCodeView {
    var code: Binder<[String]> {
        return Binder(base) { enterCodeView, code in
            enterCodeView.setCode(codeString: code)
        }
    }
}
