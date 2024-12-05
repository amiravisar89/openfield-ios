//
//  Title4.swift
//  Openfield
//
//  Created by Itay Kaplan on 30/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

open class Title6: SGLabelStyleBase {
    private static let fontSize: CGFloat = 14.0
    static let semiBold = R.font.avertaSemibold(size: fontSize)
    static let reg = R.font.avertaRegular(size: fontSize)
}

open class Title6SemiBoldBlack: Title6 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title6.semiBold
        textColor = R.color.blacK()!
    }
}

open class Title6Regular: Title6 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title6.reg
        textColor = R.color.blacK()!
    }
}

open class Title6RegularGray8: Title6 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title6.reg
        textColor = R.color.gray8()!
    }
}


open class Title6RegularGray: Title6 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title6.reg
        textColor = R.color.secondary()!
    }
}


