//
//  RangedLocationOverviewCell.swift
//  Openfield
//
//  Created by dave bitton on 26/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import UIKit

class RangedLocationOverviewCell: OverviewCell {
    @IBOutlet var summeryLabel1: BodyRegularSecondary!
    @IBOutlet var summeryLabel2: BodyRegularPrimary!

    private let googleFormURL = "https://forms.gle/BXbSBY6UjxVNcB6i7"

    typealias RangedLocationOverviewTableRow = RangedLocationOverviewCardItem

    private var counts: [RangedLocationOverviewTableRow] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        overviewTable.register(UINib(resource: R.nib.rangedLocationOverviewTableCell), forCellReuseIdentifier: R.reuseIdentifier.rangedLocationOverviewTableCell.identifier)
        overviewTable.register(UINib(resource: R.nib.rangeLocationOverviewStandCountTableCell), forCellReuseIdentifier: R.reuseIdentifier.rangeLocationOverviewStandCountTableCell.identifier)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        subTitle.font = R.font.avertaRegular(size: 12)
        summeryLabel1.font = R.font.avertaRegular(size: 14)
        summeryLabel2.font = R.font.avertaRegular(size: 14)
    }

    override func bind(card: OverviewCard, onClick: PublishSubject<ControlEvent<UITapGestureRecognizer>.Element?>) {
        super.bind(card: card, onClick: onClick)
        guard let card = card as? RangedLocationOverviewCard else { return }
        summeryLabel1.text = card.avgCountTitle
        summeryLabel2.text = card.avgCount.description
        counts = card.categories
        overviewTable.reloadData()
        forQA()
    }

    func forQA() {
        summeryLabel1.accessibilityIdentifier = "summery_label_1"
        summeryLabel2.accessibilityIdentifier = "summery_label_2"
        subTitle.accessibilityIdentifier = "sub_title"
    }
}

// MARK: - Overriding UITableViewDataSource functions

extension RangedLocationOverviewCell {
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return counts.count
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard counts[indexPath.row] as? RangedLocationOverviewCardGoal != nil, let url = URL(string: googleFormURL) else {
            return
        }
        UIApplication.shared.open(url)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let element = counts[indexPath.row] as? RangedLocationOverviewCardCategory {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.rangedLocationOverviewTableCell.identifier, for: indexPath) as! RangedLocationOverviewTableCell
            cell.bind(element: element)
            return cell
        } else if let element = counts[indexPath.row] as? RangedLocationOverviewCardGoal {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.rangeLocationOverviewStandCountTableCell.identifier, for: indexPath) as! RangeLocationOverviewStandCountTableCell
            cell.bind(element: element)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
