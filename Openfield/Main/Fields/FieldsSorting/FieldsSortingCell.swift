//
//  FieldsSortingCell.swift
//  Openfield
//
//  Created by amir avisar on 02/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import UIKit

class FieldsSortingCell: UITableViewCell {
    @IBOutlet var mainTitle: UILabel!
    @IBOutlet var radioButton: UIImageView!
    
    func bind(cell: FieldsSortingCellUiElement, rowIndex: Int) {
        mainTitle.text = cell.sortingName
        radioButton.image = cell.isSelected ? R.image.radioButtonOn() : R.image.radioButtonOff()
        
        mainTitle.accessibilityIdentifier = "\(cell.sortingName)_row_index_\(rowIndex)"
        radioButton.accessibilityIdentifier = "radio_button_\(cell.isSelected ? "selected" : "unselected")"
    }
        
}
