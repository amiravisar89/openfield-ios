//
//  Colors.swift
//  Openfield
//
//  Created by Omer Cohen on 2/18/20.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

public enum StyleGuideColor: String {
    case

        issueLocationColors,
        rangedLocationColors

    public func getUIColors(itemsCount: Int = 0) -> [UIColor] {
        switch self {
        case .issueLocationColors:
            return [UIColor.hexStringToUIColor(hex: "#00FFFF"), UIColor.hexStringToUIColor(hex: "#FFFF00"), UIColor.hexStringToUIColor(hex: "#00FF00"), UIColor.hexStringToUIColor(hex: "#FF6DFF"), UIColor.hexStringToUIColor(hex: "#FFA096"), UIColor.hexStringToUIColor(hex: "#FFC700")]
        case .rangedLocationColors:
            return itemsCount == 3 ? [UIColor.hexStringToUIColor(hex: "#17E517"), UIColor.hexStringToUIColor(hex: "#E5E517"), UIColor.hexStringToUIColor(hex: "#E51717")] :
                [UIColor.hexStringToUIColor(hex: "#17E517"), UIColor.hexStringToUIColor(hex: "#E5E517"), UIColor.hexStringToUIColor(hex: "#E59317"), UIColor.hexStringToUIColor(hex: "#E51717")]
        }
    }
}

extension UIColor {
    // Based on: https://stackoverflow.com/a/27203691/2400982
    static func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        var int: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&int)

        // swiftlint:disable:next identifier_name
        let a, r, g, b: UInt32
        switch cString.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        return UIColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
}
