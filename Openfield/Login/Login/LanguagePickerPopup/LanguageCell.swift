//
//  LanguageCell.swift
//  Openfield
//
//  Created by amir avisar on 02/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell {
    @IBOutlet var mainTitle: UILabel!
    @IBOutlet var selectionView: UIView!
    @IBOutlet var vImageContainer: UIView!

    func bind(cell: LanguageCellViewModel) {
        mainTitle.text = cell.name.capitalized
        selectionView.backgroundColor = cell.isSelected ? R.color.valleyBrand() : UIColor.clear
        mainTitle.textColor = cell.isSelected ? R.color.valleyBrand() : UIColor.black
    }
}
