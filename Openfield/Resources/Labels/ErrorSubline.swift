//
//  ErrorSubline.swift
//  Openfield
//
//  Created by amir avisar on 14/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import UIKit

open class ErrorSubline: SGLabelStyleBase {
    private static let fontSize: CGFloat = 12.0
    static let regFont = R.font.avertaRegular(size: fontSize)
}

open class ErrorSublineRegular: ErrorSubline {
    override open func setupStyle() {
        super.setupStyle()
        font = ErrorSubline.regFont
    }
}

open class ErrorSublineRegularRed: ErrorSublineRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.red()
    }
}
