//
//  RoundedShadowedView.swift
//  Openfield
//
//  Created by Eyal Prospera on 20/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//
import UIKit

class RoundedShadowedView: UIView {
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 25.0
    private var fillColor: UIColor = .clear

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.backgroundColor = fillColor.cgColor

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()

            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor

            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.1
            shadowLayer.shadowRadius = 5

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
