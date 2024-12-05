//
//  Title11.swift
//  Openfield
//
//  Created by amir avisar on 05/03/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit

open class Title11: SGLabelStyleBase {
    private static let fontSize: CGFloat = 10.0
    static let regFont = R.font.avertaRegular(size: fontSize)
}

open class Title11RegularWhite: Title11 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title10.regFont
        textColor = R.color.white()
    }
}

