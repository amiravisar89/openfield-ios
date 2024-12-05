//
//  UIView+Addition.swift
//  Openfield
//
//  Created by Daniel Kochavi on 11/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

extension UIView {
    var originOnWindow: CGPoint { return convert(CGPoint.zero, to: nil) }

    func addParallaxToView(amount: Int) {
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        addMotionEffect(group)
    }
}
