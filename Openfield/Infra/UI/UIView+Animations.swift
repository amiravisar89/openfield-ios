//
//  UIView+Animations.swift
//  Openfield
//
//  Created by amir avisar on 18/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func animateClick() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.identity
            }
        })
    }
}
