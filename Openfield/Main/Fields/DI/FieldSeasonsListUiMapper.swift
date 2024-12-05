//
//  FieldSeasonsListUiMapper.swift
//  Openfield
//
//  Created by Amitai Efrati on 07/04/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

class FieldSeasonsListUiMapper {
    
    func mapToUiElement(seasons: [Season], selectedSeason: Season?) -> [PickerPopupCellUiElement] {
        guard !seasons.isEmpty else {
            return []
        }
    
        var uiElements: [PickerPopupCellUiElement] = []
        let effectiveSelectedSeason = selectedSeason ?? seasons.first!
    
        for season in seasons {
            var isSelected = false
            if (effectiveSelectedSeason.order == season.order) {
                isSelected = true
            }
            uiElements.append(PickerPopupCellUiElement(name: season.name, isSelected: isSelected, id: season.order))
        }
        return uiElements
    }
    
}
