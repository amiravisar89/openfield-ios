//
//  Imagery.swift
//  Openfield
//
//  Created by Daniel Kochavi on 06/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import SwiftDate
import UIKit

struct Imagery: AnimatableModel, Hashable {
    typealias Identity = Int

    static func == (lhs: Imagery, rhs: Imagery) -> Bool {
        lhs.identity == rhs.identity
    }

    var images: [ImageryImage]
    let date: Date
    let region: Region
    let isRead: Bool
    var identity: Int { return hashValue }
    var count: Int { return images.count }
}

struct ImageryImage: Hashable {
    let url: String
    let date: Date
    let region: Region
    let layer: AppImageType
    let field: Field
}

enum AppImageType: String, CaseIterable, Hashable {
    case rgb
    case ndvi
    case thermal

    func name() -> String {
        switch self {
        case .thermal:
            return R.string.localizable.imageLayerDataThermalName()
        case .ndvi:
            return R.string.localizable.imageLayerDataNdviName()
        case .rgb:
            return R.string.localizable.imageLayerDataRgbName()
        }
    }

    func minLabel() -> String {
        switch self {
        case .thermal:
            return R.string.localizable.imageLayerDataThermalLegendStart()
        case .ndvi:
            return R.string.localizable.imageLayerDataNdviLegendStart()
        case .rgb:
            return ""
        }
    }

    func maxLabel() -> String {
        switch self {
        case .thermal:
            return R.string.localizable.imageLayerDataThermalLegendEnd()
        case .ndvi:
            return R.string.localizable.imageLayerDataNdviLegendEnd()
        case .rgb:
            return ""
        }
    }

    func colorMap() -> [CGColor] {
        switch self {
        case .thermal:
            return [
                UIColor(red: 0.00, green: 0.00, blue: 0.02, alpha: 1.0).cgColor,
                UIColor(red: 0.08, green: 0.05, blue: 0.21, alpha: 1.0).cgColor,
                UIColor(red: 0.23, green: 0.06, blue: 0.44, alpha: 1.0).cgColor,
                UIColor(red: 0.39, green: 0.10, blue: 0.50, alpha: 1.0).cgColor,
                UIColor(red: 0.55, green: 0.16, blue: 0.51, alpha: 1.0).cgColor,
                UIColor(red: 0.72, green: 0.22, blue: 0.47, alpha: 1.0).cgColor,
                UIColor(red: 0.87, green: 0.29, blue: 0.41, alpha: 1.0).cgColor,
                UIColor(red: 0.97, green: 0.44, blue: 0.36, alpha: 1.0).cgColor,
                UIColor(red: 1.00, green: 0.62, blue: 0.43, alpha: 1.0).cgColor,
                UIColor(red: 1.00, green: 0.81, blue: 0.57, alpha: 1.0).cgColor,
                UIColor(red: 0.99, green: 0.99, blue: 0.75, alpha: 1.0).cgColor,
            ]
        case .ndvi:
            return [
                UIColor(red: 0.65, green: 0.00, blue: 0.15, alpha: 1.0).cgColor,
                UIColor(red: 0.83, green: 0.20, blue: 0.17, alpha: 1.0).cgColor,
                UIColor(red: 0.95, green: 0.43, blue: 0.26, alpha: 1.0).cgColor,
                UIColor(red: 0.99, green: 0.67, blue: 0.39, alpha: 1.0).cgColor,
                UIColor(red: 1.00, green: 0.87, blue: 0.55, alpha: 1.0).cgColor,
                UIColor(red: 0.98, green: 0.97, blue: 0.68, alpha: 1.0).cgColor,
                UIColor(red: 0.84, green: 0.93, blue: 0.56, alpha: 1.0).cgColor,
                UIColor(red: 0.64, green: 0.85, blue: 0.43, alpha: 1.0).cgColor,
                UIColor(red: 0.39, green: 0.74, blue: 0.38, alpha: 1.0).cgColor,
                UIColor(red: 0.13, green: 0.59, blue: 0.31, alpha: 1.0).cgColor,
                UIColor(red: 0.00, green: 0.41, blue: 0.22, alpha: 1.0).cgColor,
            ]
        case .rgb:
            return []
        }
    }
}

struct PreviewImage: Hashable {
    let url: String
    let height: Int
    let width: Int
    let imageId: Int
    let issue: Issue?
}
