//
//  HighlightsCardProvider.swift
//  Openfield
//
//  Created by amir avisar on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

protocol HighlightsCardsProvider {
    func cards(highlights: [HighlightItem]) -> [HighlightUiElement]
    func card(highlight: HighlightItem) -> HighlightUiElement? 
}
