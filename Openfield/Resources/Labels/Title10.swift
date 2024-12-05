//
//  Title10.swift
//  Openfield
//
//  Created by amir avisar on 25/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit

open class Title10: SGLabelStyleBase {
    private static let fontSize: CGFloat = 12.0
    static let regFont = R.font.avertaRegular(size: fontSize)
}

open class Title10Regular: Title10 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title10.regFont
        textColor = R.color.blacK()
    }
}

open class Title10RegularWhite: Title10 {
    override open func setupStyle() {
        super.setupStyle()
        font = Title10.regFont
        textColor = R.color.white()
    }
}
