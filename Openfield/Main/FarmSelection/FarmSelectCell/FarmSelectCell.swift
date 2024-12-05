//
//  FarmSelectCell.swift
//  Openfield
//
//  Created by amir avisar on 16/04/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

class FarmSelectCell: UITableViewCell {
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var vImage: UIImageView!
    @IBOutlet var imageContainerView: UIView!

    func initCell(farm: FilteredFarm, didSelect: Bool) {
        mainLabel.text = farm.name
        imageContainerView.backgroundColor = didSelect ? R.color.selectedBackGround()! : .clear
        imageContainerView.viewBorderColor = didSelect ? R.color.valleyBrand()! : R.color.lightGrey()!
        vImage.image = didSelect ? R.image.blueV() : nil
        counterLabel.text = String(farm.fieldIds.count)

        counterLabel.accessibilityIdentifier = "counter_label_\(farm.id)"
        imageContainerView.accessibilityIdentifier = "image_view_\(farm.id)_\(didSelect ? "selected" : "unselected")"
        mainLabel.accessibilityIdentifier = "farm_name_\(farm.id)"
    }
}
