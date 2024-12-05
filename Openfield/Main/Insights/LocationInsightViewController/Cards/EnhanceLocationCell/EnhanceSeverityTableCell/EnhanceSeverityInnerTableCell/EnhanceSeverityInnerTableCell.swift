//
//  EnhanceSeverityInnerTableCell.swift
//  Openfield
//
//  Created by amir avisar on 05/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import UIKit

class EnhanceSeverityInnerTableCell: UITableViewCell {
    static let height = 32

    @IBOutlet var dot: UIView!
    @IBOutlet var nameLabel: SubHeadlineBold!
    @IBOutlet var relativeToLastLabel: SubHeadlineRegular!
    @IBOutlet var arrowImage: UIImageView!
    @IBOutlet var midtitleLabel: SubHeadlineRegular!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = R.color.screenBg()!
        selectionStyle = .none
        forQA()
    }

    private func forQA() {
        accessibilityIdentifier = "severity_cell_description"
        dot.accessibilityIdentifier = "dot"
        nameLabel.accessibilityIdentifier = "name"
        relativeToLastLabel.accessibilityIdentifier = "relativeToLastLabel"
        arrowImage.accessibilityIdentifier = "arrow"
        midtitleLabel.accessibilityIdentifier = "mid_title"
    }

    func bind(cell: severityCell) {
        nameLabel.text = cell.name
        midtitleLabel.text = " - \(cell.value)%"
        dot.backgroundColor = cell.color

        guard let relativetoLastValue = cell.relativeToLastValue else {
            relativeToLastLabel.text = "--"
            arrowImage.image = nil
            return
        }

        guard relativetoLastValue != 0 else {
            relativeToLastLabel.text = "--"
            arrowImage.image = nil
            return
        }
        relativeToLastLabel.text = "\(relativetoLastValue)%"
        arrowImage.image = relativetoLastValue > 0 ? R.image.enhance_severity_arrow_up() : R.image.enhance_severity_arrow_down()
    }
}
