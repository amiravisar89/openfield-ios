//
//  ToolTipManager.swift
//  Openfield
//
//  Created by Daniel Kochavi on 3/10/20.
//  Copyright © 2020 Prospera. All rights reserved.
//

import EasyTipView
import UIKit

class ToolTipManager {
    var tipViews = [String: EasyTipView]()

    lazy var tipPreferences: EasyTipView.Preferences = {
        var tipPreferences = EasyTipView.Preferences()
        tipPreferences.drawing.backgroundColor = R.color.valleyDarkBrand()!
        tipPreferences.drawing.foregroundColor = R.color.white()!
        tipPreferences.drawing.textAlignment = NSTextAlignment.center
        tipPreferences.drawing.font = R.font.avertaRegular(size: 13)!
        tipPreferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        tipPreferences.drawing.arrowHeight = 14
        tipPreferences.positioning.bubbleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        tipPreferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: 0)
        tipPreferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: 0)
        tipPreferences.animating.showInitialAlpha = 0
        tipPreferences.animating.showDuration = 1
        tipPreferences.animating.dismissDuration = 1
        return tipPreferences
    }()

    public func openTipView(text: String, forView: UIView, superView: UIView) {
        let tipPreferences = self.tipPreferences
        let view = EasyTipView(text: text, preferences: tipPreferences)
        if tipViews[text] == nil {
            dismissAllTipViews()
            view.show(forView: forView, withinSuperview: superView)
            tipViews[text] = view
            PassThroughScreenOverlay.addToKeyWindow {
                self.dismissAllTipViews()
            }
        } else {
            dismissAllTipViews()
        }
    }

    func dismissAllTipViews() {
        for (key, value) in tipViews {
            value.dismiss()
            tipViews.removeValue(forKey: key)
        }
    }
}

class PassThroughScreenOverlay: UIView {
    var touchCallback: (() -> Void)?

    class func addToKeyWindow(_ touch: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.keyWindow else { return }
        let overlay = PassThroughScreenOverlay()
        overlay.touchCallback = touch
        overlay.backgroundColor = .clear
        overlay.frame = window.bounds
        overlay.isUserInteractionEnabled = true
        overlay.layer.zPosition = 1
        window.addSubview(overlay)
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        touchCallback?()
        removeFromSuperview()
        return subviews.contains(where: {
            !$0.isHidden
                && $0.isUserInteractionEnabled
                && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }
}
