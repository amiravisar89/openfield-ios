//
//  IssueOverviewTableCell.swift
//  Openfield
//
//  Created by Itay Kaplan on 03/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import UIKit

class IssueOverviewTableCell: UITableViewCell {
    @IBOutlet var issue: BodyRegularSecondary!
    @IBOutlet var quantity: BodyRegularPrimary!

    func bind(issue: String, quantity: String) {
        self.issue.text = issue
        self.quantity.text = quantity
    }
}
