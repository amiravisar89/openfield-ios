//
//  UIView+Borders.swift
//  Openfield
//
//  Created by Itay Kaplan on 30/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    private func bottomBorderName() -> String { return "bottom_border" }

    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: frame.size.width - width, y: 0, width: width, height: frame.size.height)
        layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = bottomBorderName()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)

        removeBottomBorder()
        layer.addSublayer(border)
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
        layer.addSublayer(border)
    }

    func addBorderWithColor(color: UIColor, width: CGFloat) {
        addTopBorderWithColor(color: color, width: width)
        addRightBorderWithColor(color: color, width: width)
        addBottomBorderWithColor(color: color, width: width)
        addLeftBorderWithColor(color: color, width: width)
    }

    func removeBottomBorder() {
        guard let sublayers = layer.sublayers else { return }
        var layerForRemove: CALayer?
        for layer in sublayers {
            if layer.name == bottomBorderName() {
                layerForRemove = layer
            }
        }
        if let layer = layerForRemove {
            layer.removeFromSuperlayer()
        }
    }
}
