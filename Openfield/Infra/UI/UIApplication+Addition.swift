//
//  UIApplication+Addition.swift
//  Openfield
//
//  Created by Daniel Kochavi on 04/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//
// stackoverflow: https://stackoverflow.com/a/57394751/8247859

import UIKit

extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 3_848_245

            let keyWindow = UIApplication.shared.connectedScenes
                .map { $0 as? UIWindowScene }
                .compactMap { $0 }
                .first?.windows.first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
                let statusBarView = UIView(frame: height)
                statusBarView.tag = tag
                statusBarView.layer.zPosition = 999_999

                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }

        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
}
