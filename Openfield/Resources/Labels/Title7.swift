//
//  Title7.swift
//  Openfield
//
//  Created by amir avisar on 04/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import UIKit

open class Title7: SGLabelStyleBase {
    private static let fontSize: CGFloat = 20.0
    static let regFont = R.font.avertaRegular(size: fontSize)
    static let semiBold = R.font.avertaSemibold(size: fontSize)
}

open class Title7Regular: Title7 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title7.regFont
    }
}
open class Title7SemiBold: Title7 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title7.semiBold
    }
}
