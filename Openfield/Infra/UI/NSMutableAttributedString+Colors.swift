//
//  NSMutableAttributedString+Colors.swift
//  Openfield
//
//  Created by amir avisar on 20/07/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    func setColorFor(text: String, withColor color: UIColor) {
        let range: NSRange = mutableString.range(of: text, options: .caseInsensitive)
        addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

    func setFontFor(text: String, font: UIFont) {
        let range: NSRange = mutableString.range(of: text, options: .caseInsensitive)
        addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
}
