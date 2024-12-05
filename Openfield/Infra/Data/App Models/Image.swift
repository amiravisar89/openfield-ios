//
//  Image.swift
//  Openfield
//
//  Created by Itay Kaplan on 04/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import UIKit

struct ImageBounds: Decodable, Hashable {
    var boundsLeft: Double
    var boundsBottom: Double
    var boundsRight: Double
    var boundsTop: Double
}

class AppImage: Hashable {
    let height: Int
    let width: Int
    let url: String

    var imageSize: CGSize {
        return CGSize(width: width, height: height)
    }

    init(height: Int, width: Int, url: String) {
        self.height = height
        self.width = width
        self.url = url.replacingOccurrences(of: " ", with: "%20")
    }

    static func == (lhs: AppImage, rhs: AppImage) -> Bool {
        return lhs.url == rhs.url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}

class SpatialImage: AppImage {
    let bounds: ImageBounds

    init(height: Int, width: Int, url: String, bounds: ImageBounds) {
        self.bounds = bounds

        super.init(height: height, width: width, url: url)
    }
}
