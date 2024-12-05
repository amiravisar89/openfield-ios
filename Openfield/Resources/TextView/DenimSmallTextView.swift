//
//  DenimSmallTextView.swift
//  Openfield
//
//  Created by amir avisar on 29/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation
import UIKit

open class DenimSmallTextView: TextViewBase {
    private static let fontSize: CGFloat = 12.0
    static let regFont = R.font.denimRegular(size: fontSize)
}

open class DenimSmallTextViewRegular: DenimTextView {
    override open func setupStyle() {
        super.setupStyle()
        font = DenimSmallTextView.regFont
        textColor = R.color.secondary()
    }
}
