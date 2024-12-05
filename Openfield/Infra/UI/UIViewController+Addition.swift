//
//  UIViewController+Addition.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

extension UIViewController {
    func setStatusBarColor(color: UIColor) {
        if let statusBar = UIApplication.shared.statusBarUIView {
            statusBar.backgroundColor = color
        }
    }

    func removeAllChildens() {
        children.forEach { child in
            child.willMove(toParent: nil)
            child.removeFromParent()
            child.view.removeFromSuperview()
        }
    }
}
