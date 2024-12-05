//
//  FieldInsightsCell.swift
//  Openfield
//
//  Created by amir avisar on 14/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FieldIrrigationCell: UITableViewCell {

    @IBOutlet weak var insightsTableHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var buttonTitle: UILabel!
    @IBOutlet weak var insightsTable: UITableView!

    var items : BehaviorSubject<[FieldIrrigationItemUiElement]> = BehaviorSubject(value: [])
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(uiElement: FieldIrrigationUiElement) {
        title.text = uiElement.title
        buttonTitle.text = uiElement.buttonTitle
        buttonTitle.isHidden = !uiElement.btnVisible
        initTable()
        items.onNext(uiElement.items)
        bind()
        resizeTable(items: uiElement.items)
    }
    
    private func initTable(){
        insightsTable.register(UINib(resource: R.nib.fieldIrrigationItemCell), forCellReuseIdentifier: R.reuseIdentifier.fieldIrrigationItemCell.identifier)
        insightsTable.isScrollEnabled = false
    }
    
    private func bind(){
        items.bind(to: insightsTable.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fieldIrrigationItemCell.identifier, for: IndexPath(row: row, section: 0)) as! FieldIrrigationItemCell
            cell.bind(uiElement: element)
            return cell
        }.disposed(by: disposeBag)
    }
    
    private func resizeTable(items: [FieldIrrigationItemUiElement]) {
        insightsTableHeightConstraint.constant = CGFloat(items.count) * FieldIrrigationItemCell.height
        layoutIfNeeded()
    }
    


}
