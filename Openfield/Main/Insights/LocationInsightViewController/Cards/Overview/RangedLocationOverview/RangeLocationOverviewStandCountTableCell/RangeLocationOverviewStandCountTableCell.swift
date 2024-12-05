//
//  RangeLocationOverviewStandCountTableCell.swift
//  Openfield
//
//  Created by amir avisar on 26/05/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import UIKit

class RangeLocationOverviewStandCountTableCell: UITableViewCell {
    // MARK: - Members

    @IBOutlet private var holderView: UIView!
    @IBOutlet private var editLabel: CaptionRegularValley!
    @IBOutlet private var subTitleLabel: BodyBoldSecondary!
    @IBOutlet private var titleLabel: CaptionRegularSecondary!

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.text = R.string.localizable.insightGoalStandCountText()
        editLabel.text = R.string.localizable.insightEdit()
        holderView.backgroundColor = R.color.lightGrey()
        selectionStyle = .none
    }

    func bind(element: RangedLocationOverviewCardGoal) {
        subTitleLabel.text = element.subtitle
    }
}
