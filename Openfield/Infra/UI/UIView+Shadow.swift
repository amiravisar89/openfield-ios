//
//  UIView+Shadow.swift
//  Openfield
//
//  Created by Daniel Kochavi on 19/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(top: Bool, shadowColor: UIColor = .black, shadowRadius: CGFloat = 2, shadowOpacity: Float = 0.1) {
        let width = frame.width
        let height = frame.height

        let shadowPath = UIBezierPath()
        if top {
            shadowPath.move(to: CGPoint(x: 0, y: 0))
            shadowPath.addLine(to: CGPoint(x: 0, y: -shadowRadius))
            shadowPath.addLine(to: CGPoint(x: width, y: -shadowRadius))
            shadowPath.addLine(to: CGPoint(x: width, y: 0))
        } else {
            shadowPath.move(to: CGPoint(x: 0, y: height))
            shadowPath.addLine(to: CGPoint(x: 0, y: height + shadowRadius))
            shadowPath.addLine(to: CGPoint(x: width, y: height + shadowRadius))
            shadowPath.addLine(to: CGPoint(x: width, y: height))
        }

        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = .zero
        layer.shadowOpacity = shadowOpacity
        layer.shadowColor = shadowColor.cgColor
    }
}

extension UIView {
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView]
    {
        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border])
            })
            borders.append(border)
            return border
        }

        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }
}
