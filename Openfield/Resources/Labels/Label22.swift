//
//  Label22.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

open class Label22: SGLabelStyleBase {
    private static let fontSize: CGFloat = 22
    static let boldFont = R.font.avertaBold(size: fontSize)
    static let regFont = R.font.avertaRegular(size: fontSize)
}

open class Label22Regular: Label22 {
    override open func setupStyle() {
        super.setupStyle()
        font = Label22.regFont
    }
}

open class Label22RegularWhite70: Label22Regular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.white70()
    }
}

open class Label22Bold: Label22 {
    override open func setupStyle() {
        super.setupStyle()
        font = Label22.boldFont
    }
}

open class Label22BoldWhite: Label22Bold {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.white()
    }
}
