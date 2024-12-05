//
//  CaptionTextView.swift
//  Openfield
//
//  Created by amir avisar on 17/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import UIKit

open class CaptionTextView: TextViewBase {
    private static let fontSize: CGFloat = 16.0
    static let regFont = R.font.avertaRegular(size: fontSize)
}

open class CaptionTextViewRegular: CaptionTextView {
    override open func setupStyle() {
        super.setupStyle()
        font = CaptionTextView.regFont
    }
}

open class CaptionTextViewRegularSecondary: CaptionTextViewRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.secondary()
    }
}
