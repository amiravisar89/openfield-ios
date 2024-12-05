//
//  Title4.swift
//  Openfield
//
//  Created by Itay Kaplan on 30/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

open class Title4: SGLabelStyleBase {
    private static let fontSize: CGFloat = 18
    static let boldFont = R.font.avertaBold(size: fontSize)
    static let regFont = R.font.avertaRegular(size: fontSize)
}

open class Title4Bold: Title4 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title4.boldFont
    }
}

open class Title4BoldPrimary: Title4Bold {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.primary()
    }
}
