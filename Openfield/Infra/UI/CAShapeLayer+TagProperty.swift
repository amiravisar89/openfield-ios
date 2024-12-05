//
//  CAShapeLayer+TagProperty.swift
//  Openfield
//
//  Created by Yoni Luz on 20/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

import QuartzCore
import ObjectiveC


// Define keys for associated objects
private var idKey: UInt8 = 0
private var enabledKey: UInt8 = 0
private var selectedKey: UInt8 = 0

extension CAShapeLayer {
    // Custom "id" property
    var id: Int? {
        get {
            return objc_getAssociatedObject(self, &idKey) as? Int
        }
        set {
            objc_setAssociatedObject(self, &idKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // Custom "enabled" property
    var enabled: Bool {
        get {
            return (objc_getAssociatedObject(self, &enabledKey) as? Bool) ?? true
        }
        set {
            objc_setAssociatedObject(self, &enabledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var selected: Bool {
        get {
            return (objc_getAssociatedObject(self, &selectedKey) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &selectedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
