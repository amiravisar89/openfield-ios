//
//  TextFieldTitle2.swift
//  Openfield
//
//  Created by Daniel Kochavi on 29/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import UIKit

open class TextFieldTitle2Regular: SGTextField {
    private static let fontSize: CGFloat = 17
    static let boldFont: UIFont = R.font.avertaBold(size: fontSize)!
    static let regFont: UIFont = R.font.avertaRegular(size: fontSize)!

    override open func setupStyle() {
        super.setupStyle()
        font = TextFieldTitle2Regular.regFont
    }
}

open class TextFieldTitle2RegularWhite: TextFieldTitle2Regular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.white()
        tintColor = R.color.white()
        attributedPlaceholder = NSAttributedString(string: R.string.localizable.searchSearchForField(),
                                                   attributes: [NSAttributedString.Key.foregroundColor: R.color.secondary()!,
                                                                NSAttributedString.Key.font: TextFieldTitle2Regular.regFont])
        tintColorDidChange()
    }
}
