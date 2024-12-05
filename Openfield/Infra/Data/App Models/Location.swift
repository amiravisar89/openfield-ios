//
//  Location.swift
//  Openfield
//
//  Created by Itay Kaplan on 14/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import AVKit
import Foundation

struct Location {
    let id: Int
    let issuesIds: [Int]
    let latitude: Double
    let longitude: Double
    let images: [LocationImageMeatadata]
}

struct LocationImageMeatadata {
    let id: Int
    let date: Int
    let itemId: Int
    let isCover: Bool
    let previews: [AppImage]
    let tags: [LocationTag]
    let lat: Double?
    let long: Double?
    let levelId: Int?
    let isNightImage: Bool

    func getMinPreview() -> AppImage? { return previews.min(by: { $0.height < $1.height }) }
    func getMaxPreview() -> AppImage? { return previews.max(by: { $0.height < $1.height }) }
}

struct LocationTag {
    let type: String
    let points: [CGPoint?]
}
