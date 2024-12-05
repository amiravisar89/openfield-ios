//
//  RangedLocationOverviewTableCell.swift
//  Openfield
//
//  Created by dave bitton on 26/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import UIKit

class RangedLocationOverviewTableCell: UITableViewCell {
    @IBOutlet var percentageLabel: BodyRegularPrimary!
    @IBOutlet var progressBarView: ProgressBarView!
    @IBOutlet var rangeLabel: BodyRegularSecondary!
    @IBOutlet var dotView: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
        rangeLabel.font = R.font.avertaRegular(size: 14)
        percentageLabel.font = R.font.avertaRegular(size: 14)
    }

    func bind(element: RangedLocationOverviewCardCategory) {
        dotView.backgroundColor = element.color
        rangeLabel.text = element.range
        percentageLabel.text = "\(element.percentage)%"
        progressBarView.progress = CGFloat(element.percentage) / 100.0
    }
}
