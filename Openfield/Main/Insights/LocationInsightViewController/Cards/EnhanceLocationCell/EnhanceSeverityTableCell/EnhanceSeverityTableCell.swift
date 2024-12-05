//
//  EnhanceSeverityTableCell.swift
//  Openfield
//
//  Created by amir avisar on 05/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class EnhanceSeverityTableCell: UITableViewCell {
    @IBOutlet var severityTable: UITableView!

    let disposeBag = DisposeBag()
    var severityCells: BehaviorSubject<[severityCell]> = BehaviorSubject(value: [])
    var severityItem: EnhanceSeverityTableCellData!
    @IBOutlet var tableviewHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        severityTable.backgroundColor = R.color.screenBg()!
        selectionStyle = .none
        initTable()
        accessibilityIdentifier = "severity_cell"
    }

    func initTable() {
        severityTable.register(UINib(resource: R.nib.enhanceSeverityInnerTableCell), forCellReuseIdentifier: R.reuseIdentifier.enhanceSeverityInnerTableCell.identifier)
    }

    func initCell(severityItem: EnhanceSeverityTableCellData) {
        self.severityItem = severityItem
        severityCells.onNext(severityItem.severityCells)
        severityTable.delegate = nil // As RxSwift docs
        severityTable.dataSource = nil // As RxSwift docs
        severityTable.delegate = self
        adjustTableViewHeight()
        bind()
    }

    // tried in a native way, took to long
    func adjustTableViewHeight() {
        tableviewHeightConstraint?.constant = CGFloat(severityItem.severityCells.count * EnhanceSeverityInnerTableCell.height) + EnhanceSeverityHeaderView.height
        layoutIfNeeded()
    }

    func bind() {
        severityCells.bind(to: severityTable.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.enhanceSeverityInnerTableCell.identifier, for: IndexPath(row: row, section: 0)) as! EnhanceSeverityInnerTableCell
            cell.bind(cell: element)
            return cell
        }.disposed(by: disposeBag)
    }
}

extension EnhanceSeverityTableCell: UITableViewDelegate {
    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let header = EnhanceSeverityHeaderView.instanceFromNib(rect: CGRect(x: 0, y: 0, width: severityTable.bounds.width, height: EnhanceSeverityHeaderView.height))
        header.title = severityItem.title
        header.subtitle = severityItem.subtitle
        header.midtitle = severityItem.midtitle
        return header
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return EnhanceSeverityHeaderView.height
    }
}
