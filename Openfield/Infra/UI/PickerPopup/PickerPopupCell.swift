//
//  PickerPopupCell.swift
//  Openfield
//
//  Created by Amitai Efrati on 22/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import UIKit

class PickerPopupCell: UITableViewCell {
    @IBOutlet var mainTitle: UILabel!
    @IBOutlet var radioButton: UIImageView!
    
    func bind(cell: PickerPopupCellUiElement, rowIndex: Int) {
        mainTitle.text = cell.name
        radioButton.image = cell.isSelected ? R.image.radioButtonOn() : R.image.radioButtonOff()
        
        mainTitle.accessibilityIdentifier = "\(cell.name)_row_index_\(rowIndex)"
        radioButton.accessibilityIdentifier = "radio_button_\(cell.isSelected ? "selected" : "unselected")"
    }
        
}
