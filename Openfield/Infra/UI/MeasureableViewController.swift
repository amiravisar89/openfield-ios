//
//  MeasureableViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 30/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

/**
 A `UIViewController` implementing this protocol will allow its presnting `UIViewController` (implementing `ViewControllerMeasureDelegate`) know its content height before displaying it. It is recomended to measure the `UIViewController`'s height in `viewDidAppear()` and call `measuredHeight(height: CGFloat)` with the result.
 */
protocol MeasurableViewController: UIViewController {
    var measureDelegate: ViewControllerMeasureDelegate? { get set }
}

extension MeasurableViewController {
    func measuredHeight(height: CGFloat) {
        measureDelegate?.didMeasureView(self, height: height)
    }
}

/**
 A `UIViewController` implementing this protocol will use will call `measureVCOnViewDidAppear(vc: MeasurableViewController)` in its `viewDidAppear(_ animated: Bool)` lifecycle method  to measure a `UIViewController` implementing `MeasurableViewController`.
 */
protocol ViewControllerMeasureDelegate: UIViewController {
    var measuredHeight: CGFloat { get set }
}

extension ViewControllerMeasureDelegate {
    func measureVCOnViewDidAppear(vc: MeasurableViewController) {
        if measuredHeight == 0 {
            measureVC(vc: vc)
        }
    }

    private func measureVC(vc: MeasurableViewController) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        view.addSubview(vc.view)
        vc.view.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
        vc.measureDelegate = self
    }

    func didMeasureView(_ sender: MeasurableViewController, height: CGFloat) {
        sender.removeFromParent()
        sender.measureDelegate = nil
        measuredHeight = height
    }
}
