//
//  SubHeadeline.swift
//  Openfield
//
//  Created by Daniel Kochavi on 26/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

open class SubHeadline: SGLabelStyleBase {
    private static let fontSize: CGFloat = 15.0
    static let boldFont = R.font.avertaBold(size: fontSize)
    static let regFont = R.font.avertaRegular(size: fontSize)
}

open class SubHeadlineRegular: SubHeadline {
    override open func setupStyle() {
        super.setupStyle()
        font = SubHeadline.regFont
    }
}

open class SubHeadlineRegularWhite: SubHeadlineRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.white()
    }
}

open class SubHeadlineRegularSecondary: SubHeadlineRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.secondary()
    }
}

open class SubHeadlineRegularPrimary: SubHeadlineRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.primary()
    }
}

open class SubHeadlineRegularRed: SubHeadlineRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.red()
    }
}

open class SubHeadlineBold: SubHeadline {
    override open func setupStyle() {
        super.setupStyle()
        font = SubHeadline.boldFont
    }
}

open class SubHeadlineBoldWhite: SubHeadlineBold {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.white()
    }
}

open class SubHeadlineBoldOrange: SubHeadlineBold {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.orange()
    }
}
