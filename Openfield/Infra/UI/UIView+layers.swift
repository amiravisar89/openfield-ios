//
//  UIView+layers.swift
//  PetNet
//
//  Created by Amir Avisar on 24/06/2018.
//  Copyright © 2018 Amir Avisar. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var viewBorderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var viewBorderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        } get {
            return UIColor(cgColor: layer.borderColor!)
        }
    }

    @IBInspectable var viewCornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }

    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }

    @IBInspectable var customShadowColor: UIColor {
        set {
            layer.shadowColor = newValue.cgColor
        }
        get {
            return self.customShadowColor
        }
    }
}

extension UILabel {
    func underline() {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
