//
//  FieldImageTagData.swift
//  Openfield
//
//  Created by Daniel Kochavi on 13/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import GEOSwift
import UIKit

struct FieldImageTagData {
    var tagId: Int
    var hidden: Bool
    var data: GeoJSON
    var color: UIColor
    var shapes: [CAShapeLayer]
}
