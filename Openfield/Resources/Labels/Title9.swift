//
//  Title3.swift
//  Openfield
//
//  Created by Daniel Kochavi on 26/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

open class Title9: SGLabelStyleBase {
    private static let fontSize: CGFloat = 18
    static let regFont = R.font.avertaRegular(size: fontSize)
    static let semiBoldFont = R.font.avertaSemibold(size: fontSize)
}

open class Title9RegularBlack: Title9 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title9.regFont
        textColor = R.color.blacK()
    }
}

open class Title9SemiBoldBlack: Title9 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title9.semiBoldFont
        textColor = R.color.blacK()
    }
}

open class Title3: SGLabelStyleBase {
    private static let fontSize: CGFloat = 20
    static let boldFont = R.font.avertaBold(size: fontSize)
    static let semiBold = R.font.avertaSemibold(size: fontSize)
    static let regFont = R.font.avertaRegular(size: fontSize)
}

open class Title3Regular: Title3 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title3.regFont
    }
}

open class Title3RegularPrimary: Title3Regular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.primary()
    }
}

open class Title3Bold: Title3 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title3.boldFont
    }
}

open class Title3BoldWhite: Title3 {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.white()
        font = Title3.semiBold
    }
}

open class Title3BoldPrimary: Title3Bold {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.primary()
    }
}
