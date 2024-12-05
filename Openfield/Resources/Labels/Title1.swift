//
//  Title1.swift
//  Openfield
//
//  Created by Daniel Kochavi on 26/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

open class Title1: SGLabelStyleBase {
    private static let fontSize: CGFloat = 28.0
    static let boldFont = R.font.avertaBold(size: fontSize)
    static let regFont = R.font.avertaRegular(size: fontSize)
}

open class Title1Regular: Title1 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title1.regFont
    }
}

open class Title1Bold: Title1 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title1.boldFont
    }
}

open class Title1BoldWhite: Title1Bold {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.white()
    }
}
