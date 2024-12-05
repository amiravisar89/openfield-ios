//
//  Keyboard.swift
//  Openfield
//
//  Created by Daniel Kochavi on 05/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

open class Keyboard: SGLabelStyleBase {
    private static let fontSize: CGFloat = 22
    static let boldFont = R.font.avertaBold(size: fontSize)
    static let regFont = R.font.avertaRegular(size: fontSize)
}

open class KeyboardRegular: Keyboard {
    override open func setupStyle() {
        super.setupStyle()
        font = Keyboard.regFont
    }
}

open class KeyboardRegularWhite: KeyboardRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.white()
    }
}
