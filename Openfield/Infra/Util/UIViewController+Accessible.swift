//
//  UIViewController+Accessible.swift
//  Openfield
//
//  Created by amir avisar on 15/03/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func addAccessibleView(id: String) {
        let accessibleView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        accessibleView.isUserInteractionEnabled = false
        accessibleView.backgroundColor = UIColor.clear
        accessibleView.isAccessibilityElement = true
        accessibleView.accessibilityIdentifier = "AccessibleView_\(id)"
        view.addSubview(accessibleView)
    }

    func generateAccessibilityIdentifiers(id: String? = nil) {
        guard ConfigEnvironment.boolValueFor(key: .useAccesability) else { return }

        let mirror = Mirror(reflecting: self)

        for child in mirror.children {
            if let view = child.value as? UIView,
               let identifier = child.label?.replacingOccurrences(of: ".storage", with: "")
            {
                view.accessibilityIdentifier = identifier
            }
        }

        if let id = id { addAccessibleView(id: id) }
    }
}
