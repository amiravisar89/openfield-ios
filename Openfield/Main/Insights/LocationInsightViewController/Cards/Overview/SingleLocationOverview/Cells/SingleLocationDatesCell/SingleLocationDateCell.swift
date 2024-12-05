//
//  SingleLocationDateCell.swift
//  Openfield
//
//  Created by amir avisar on 03/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Resolver
import SwiftDate
import UIKit

class SingleLocationDateCell: UITableViewCell {
    @IBOutlet var firstLabel: SubHeadlineBold!
    @IBOutlet var secondLabel: SubHeadlineBold!

    @IBOutlet var firstLabelValue: SubHeadlineRegular!
    @IBOutlet var secondLabelValue: SubHeadlineRegular!

    let dateProvider: DateProvider = Resolver.resolve()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
        addAccesabilities()
    }

    func setupUI() {
        firstLabel.text = R.string.localizable.insightImageTaken()
        secondLabel.text = R.string.localizable.insightFullReportETA()
        firstLabelValue.alignment = UIView.userInterfaceLayoutDirection(
            for: semanticContentAttribute) == .rightToLeft ? "left" : "right"
        secondLabelValue.alignment = UIView.userInterfaceLayoutDirection(
            for: semanticContentAttribute) == .rightToLeft ? "left" : "right"
    }

    func addAccesabilities() {
        firstLabelValue.accessibilityIdentifier = "first_text_value"
        secondLabelValue.accessibilityIdentifier = "second_text_value"
        firstLabel.accessibilityIdentifier = "second_value"
        secondLabel.accessibilityIdentifier = "second_value"
    }

    func bind(imageDate: Date, fullReportDate: Date, region: Region) {
        firstLabelValue.text = dateProvider.format(date: imageDate, dateStyle: .short, timeStyle: .short, timeZone: region.timeZone)

        secondLabelValue.text =
            "\(dateProvider.format(date: fullReportDate, timeZone: region.timeZone, format: "EE")), \(dateProvider.format(date: fullReportDate, dateStyle: .short, timeStyle: .none, timeZone: region.timeZone))"
    }
}
