//
//  Title4.swift
//  Openfield
//
//  Created by Itay Kaplan on 30/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

open class Title5: SGLabelStyleBase {
    private static let fontSize: CGFloat = 22.0
    static let regFont = R.font.avertaRegular(size: fontSize)
}

open class Title5Regular: Title5 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title5.regFont
    }
}
