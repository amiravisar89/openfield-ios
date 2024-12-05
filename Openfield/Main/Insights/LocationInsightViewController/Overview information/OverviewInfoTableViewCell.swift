//
//  OverviewInfoTableViewCell.swift
//  Openfield
//
//  Created by dave bitton on 10/02/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import UIKit

class OverviewInfoTableViewCell: UITableViewCell {
    @IBOutlet var titleLbl: BodyBoldPrimary!
    @IBOutlet var subtitleLbl: BodyRegularPrimary!

    func bind(info: OverviewInformationView.InfoDataElement) {
        titleLbl.text = info.title
        subtitleLbl.text = info.subtitle

        guard let styles = info.subtitleStyles else { return }
        subtitleLbl.addStyles(packages: styles)
    }
}
