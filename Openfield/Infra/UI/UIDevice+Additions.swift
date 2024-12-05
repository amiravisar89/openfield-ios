//
//  UIDevice+Additions.swift
//  Openfield
//
//  Created by Daniel Kochavi on 09/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

extension UIDevice {
    // If the device has a bottom "notch" safe area (e.g. iPhone X) it returns its height
    var bottomNotchHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
    }

    // If the device has a top "notch" safe area (e.g. iPhone X) it returns its height
    var topNotchHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        } else {
            return UIApplication.shared.keyWindow?.layoutMargins.top ?? 0
        }
    }

    // Returns status bar height which currently is a constant 20
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
}
