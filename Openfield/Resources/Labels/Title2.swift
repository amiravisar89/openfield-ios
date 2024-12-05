//
//  Title2.swift
//  Openfield
//
//  Created by Daniel Kochavi on 26/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

open class Title2: SGLabelStyleBase {
    private static let fontSize: CGFloat = 24.0
    static let boldFont = R.font.avertaBold(size: fontSize)
    static let regFont = R.font.avertaRegular(size: fontSize)
}

open class Title2Regular: SGLabelStyleBase {
    override open func setupStyle() {
        super.setupStyle()
        font = Title2.regFont
    }
}

open class Title2RegularWhite: Title2Regular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.white()
    }
}

open class Title2RegularWhiteBold: Title2Regular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.white()
        font = Title2.boldFont
    }
}

open class Title2Bold: SGLabelStyleBase {
    override open func setupStyle() {
        super.setupStyle()
        font = Title2.boldFont
    }
}

open class Title2BoldPrimary: Title2Bold {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.primary()
    }
}
