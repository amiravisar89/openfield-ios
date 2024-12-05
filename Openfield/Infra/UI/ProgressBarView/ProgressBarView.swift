//
//  ProgressBarView.swift
//  Openfield
//
//  Created by dave bitton on 26/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ProgressBarView: UIView {
    @IBInspectable var color: UIColor = R.color.lightGrey()! {
        didSet { setNeedsDisplay() }
    }

    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    private let progressLayer = CALayer()
    private let backgroundMask = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    private func setupLayers() {
        layer.addSublayer(progressLayer)
    }

    override func draw(_ rect: CGRect) {
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height).cgPath
        layer.mask = backgroundMask

        let progressRectHeight = rect.height
        let progressRect = CGRect(origin: .init(x: 0, y: 0), size: CGSize(width: rect.width * progress, height: progressRectHeight))

        progressLayer.frame = progressRect
        progressLayer.backgroundColor = color.cgColor
        progressLayer.cornerRadius = progressRect.height * 0.5
    }
}
