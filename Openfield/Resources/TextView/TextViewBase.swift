//
//  TextViewBase.swift
//  Openfield
//
//  Created by amir avisar on 16/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class SGStyleableTextView: UITextView {
    private var internalAlignment: NSTextAlignment = .natural

    @IBInspectable open var alignment: String = "left" {
        didSet {
            if alignment == "center" {
                internalAlignment = .center
            } else if alignment == "left" {
                internalAlignment = .left
            } else if alignment == "right" {
                internalAlignment = .right
            }
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
    }

    func setAttributes(attributes: [TextViewAttribute]) {
        let currentTextMutable = NSMutableAttributedString(string: text)
        let currentRange = currentTextMutable.mutableString.range(of: text, options: .caseInsensitive)

        let currentAttributes = [NSAttributedString.Key.font: font as Any,
                                 NSAttributedString.Key.foregroundColor: textColor as Any]

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = internalAlignment

        currentTextMutable.addAttribute(NSAttributedString.Key.paragraphStyle,
                                        value: paragraphStyle,
                                        range: currentRange)
        currentTextMutable.addAttribute(NSAttributedString.Key.font,
                                        value: font as Any,
                                        range: currentRange)

        currentTextMutable.addAttributes(currentAttributes, range: currentRange)

        attributes.enumerated().forEach { _, attribute in
            let appDomain: String = ConfigEnvironment.valueFor(key: .appDomain)
            guard let linkURL = URL.queryURL(domain: appDomain, params: [(key: attribute.queryParam, value: attribute.type)]) else { return }
            let range = currentTextMutable.mutableString.range(of: attribute.text, options: .caseInsensitive)
            let textAttributes = [NSAttributedString.Key.font: self.font as Any,
                                  NSAttributedString.Key.foregroundColor: attribute.color,
                                  NSAttributedString.Key.link: linkURL]
            currentTextMutable.addAttributes(textAttributes, range: range)
        }
        attributedText = currentTextMutable
    }

    override open var canBecomeFirstResponder: Bool {
        return false
    }

    open func setupStyle() {
        isEditable = false
        isSelectable = true
        tintColor = R.color.valleyBrand()
    }
}

open class TextViewBase: SGStyleableTextView {
    override open func setupStyle() {
        super.setupStyle()
        applyTextStyle()
    }

    private func applyTextStyle() {
        guard let font = font else { return }
        self.font = font
        contentInset = UIEdgeInsets(top: -7.0, left: 0.0, bottom: 0, right: 0.0)
    }
}

struct TextViewAttribute {
    let text: String
    let color: UIColor
    let type: String
    let queryParam: String
}
