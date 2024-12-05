//
//  IssueLocationOverviewCell.swift
//  Openfield
//
//  Created by amir avisar on 03/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxGesture
import RxSwift

class IssueLocationOverviewCell: OverviewCell {
    private var issues: [(issueName: String, severity: String)] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        overviewTable.register(UINib(resource: R.nib.issueOverviewTableCell), forCellReuseIdentifier: R.reuseIdentifier.issueOverviewTableCell.identifier)
    }

    override func bind(card: OverviewCard, onClick: PublishSubject<ControlEvent<UITapGestureRecognizer>.Element?>) {
        super.bind(card: card, onClick: onClick)
        guard let card = card as? IssueLocationOverviewCard else { return }
        issues = card.issues
        overviewTable.reloadData()
    }
}

// MARK: - Overriding UITableViewDataSource functions

extension IssueLocationOverviewCell {
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return issues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.issueOverviewTableCell.identifier, for: indexPath) as! IssueOverviewTableCell
        cell.bind(issue: issues[indexPath.row].issueName, quantity: issues[indexPath.row].severity)
        return cell
    }
}

extension IssueLocationOverviewCell {
    override func tableView(_: UITableView, didSelectRowAt _: IndexPath) {}
}
