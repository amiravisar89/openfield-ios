//
//  MaxDrawerHeightProvider.swift
//  Openfield
//
//  Created by Omer Cohen on 2/6/20.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

protocol MaxDrawerHeightProvider {
    func drawerHeight(contentHeight: CGFloat) -> CGFloat
    var maxDrawerHeight: CGFloat { get }
}
