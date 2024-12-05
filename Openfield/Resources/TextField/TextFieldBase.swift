//
//  TextFieldBase.swift
//  Openfield
//
//  Created by Daniel Kochavi on 29/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

open class SGTextField: SGStyleableTextField {
    override open var text: String? {
        didSet {
            applyTextStyle()
        }
    }

    override open func setupStyle() {
        super.setupStyle()
        applyTextStyle()
    }

    private func applyTextStyle() {
        guard let font = font, let text = text else { return }

        let paragraphStyle = NSMutableParagraphStyle()

        let attributedString = NSMutableAttributedString(string: text)

        let selfRange = (text as NSString).range(of: text)

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: selfRange)

        attributedString.addAttribute(NSAttributedString.Key.font,
                                      value: font,
                                      range: selfRange)

        attributedText = attributedString
    }
}

@IBDesignable
open class SGStyleableTextField: UITextField {
    @IBInspectable var localisedKey: String? {
        didSet {
            guard let key = localisedKey else { return }
            text = NSLocalizedString(key, comment: "")
        }
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        #if TARGET_INTERFACE_BUILDER
            setupStyle()
        #endif
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        #if !TARGET_INTERFACE_BUILDER
            setupStyle()
        #endif
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
    }

    open func setupStyle() {}
}
