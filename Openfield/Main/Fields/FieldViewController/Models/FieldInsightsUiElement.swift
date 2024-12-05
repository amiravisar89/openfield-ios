//
//  FieldInsightsUiElement.swift
//  Openfield
//
//  Created by amir avisar on 14/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

struct FieldIrrigationUiElement {
    let title: String
    let buttonTitle: String
    let items : [FieldIrrigationItemUiElement]
    let btnVisible : Bool
}

struct FieldIrrigationItemUiElement {
    let insightUid: String
    let title: String
    let content: String
    let date: String?
    let images : [AppImage]
    let read: Bool
    let bottomLineVisible : Bool
}
