//
//  UIButton+Addition.swift
//  Openfield
//
//  Created by dave bitton on 08/03/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import UIKit

extension UIButton {
    func setIsEnabled(_ enable: Bool) {
        isEnabled = enable
        alpha = enable ? 1 : 0.5
    }
}
