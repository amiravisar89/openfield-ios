//
//  Label+AttributedText.swift
//  Openfield
//
//  Created by dave bitton on 14/02/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import UIKit

struct StylePackage {
    let font: UIFont
    let substring: String
}

extension UILabel {
    func addStyles(packages: [(font: UIFont, substring: String)]) {
        guard let labelText = text else { return }
        let newAttributedText = NSMutableAttributedString(string: labelText)
        for package in packages {
            if let range = labelText.range(of: package.substring) {
                let nsRange = NSRange(range, in: labelText)
                newAttributedText.addAttributes([
                    .font: package.font,
                ], range: nsRange)
            }
        }
        attributedText = newAttributedText
    }
}
