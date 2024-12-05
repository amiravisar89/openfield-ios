//
//  SubHeadLineTextView.swift
//  Openfield
//
//  Created by amir avisar on 16/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import UIKit

open class SubHeadlineTextView: TextViewBase {
    private static let fontSize: CGFloat = 14.0
    static let regFont = R.font.avertaRegular(size: fontSize)
}

open class SubHeadlineTextViewRegular: SubHeadlineTextView {
    override open func setupStyle() {
        super.setupStyle()
        font = SubHeadlineTextView.regFont
    }
}

open class SubHeadlineTextViewRegularSecondary: SubHeadlineTextViewRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.secondary()
    }
}
