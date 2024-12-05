//
//  CGRect+Center.swift
//  Openfield
//
//  Created by amir avisar on 13/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import AVKit
import Foundation

extension CGRect {
    var center: CGPoint { return CGPoint(x: midX, y: midY) }
}

