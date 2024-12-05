//
//  EnhanceDescriptionTableCell.swift
//  Openfield
//
//  Created by amir avisar on 04/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import UIKit

class EnhanceDescriptionTableCell: UITableViewCell {
    // MARK: - Outlets

    @IBOutlet var titleLabel: SubHeadlineBold!
    @IBOutlet var summeryLabel: SubHeadlineBold!
    @IBOutlet var viewBackground: UIView!

    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.backgroundColor = R.color.screenBg()!
        selectionStyle = .none
        forQA()
    }

    // MARK: - Bind

    func bind(itemDescription: EnhanceItemDescription) {
        titleLabel.text = itemDescription.title
        summeryLabel.text = itemDescription.summery
    }

    private func forQA() {
        accessibilityIdentifier = "description_cell"
        titleLabel.accessibilityIdentifier = "title"
        summeryLabel.accessibilityIdentifier = "summery"
    }
}
