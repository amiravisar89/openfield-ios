//
//  UIView+Glowing.swift
//  Openfield
//
//  Created by amir avisar on 13/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.

import UIKit

extension UIView {
  @IBInspectable var glowingAnimationCornerRadius: CGFloat {
    set {
      layer.cornerRadius = newValue
    }
    get {
      return layer.cornerRadius
    }
  }

  func startGlowing(color: UIColor) {
    let animationKey = "shadowRadius"
    let animationLayerKey = "glowingAnimation"
    layer.borderColor = color.cgColor
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = 0.9
    layer.shadowRadius = 5
    layer.shadowOffset = .zero
    let animation = CABasicAnimation(keyPath: animationKey)
    animation.fromValue = 2.0
    animation.toValue = 15.0
    animation.duration = 1.0
    animation.autoreverses = true
    animation.repeatCount = .infinity

    // Add the animation to the layer
    layer.add(animation, forKey: animationLayerKey)
  }

  func stopGlowing(borderColor: UIColor) {
    layer.removeAllAnimations()
    layer.borderColor = borderColor.cgColor
    layer.shadowColor = UIColor.clear.cgColor
    layer.shadowOpacity = 0
    layer.shadowRadius = 0
  }
}
