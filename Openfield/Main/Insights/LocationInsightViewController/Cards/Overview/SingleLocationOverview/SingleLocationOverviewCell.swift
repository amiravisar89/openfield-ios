//
//  SingleLocationOverviewCell.swift
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

class SingleLocationOverviewCell: OverviewCell {
    @IBOutlet var chipsList: AppChipsList!
    
    var list: BehaviorSubject<[SingleLocationOverviewItem]> = BehaviorSubject(value: [])
    var imageSelected: PublishSubject<Int> = PublishSubject()

    override func awakeFromNib() {
        super.awakeFromNib()
        initTable()
    }

    func initTable() {
        overviewTable.register(UINib(resource: R.nib.enhanceImagesTableCell), forCellReuseIdentifier: R.reuseIdentifier.enhanceImagesTableCell.identifier)

        overviewTable.register(UINib(resource: R.nib.singleLocationDateCell), forCellReuseIdentifier: R.reuseIdentifier.singleLocationDateCell.identifier)

        overviewTable.register(UINib(resource: R.nib.singleLocationImageCell), forCellReuseIdentifier: R.reuseIdentifier.singleLocationImageCell.identifier)

    }

    override func bind(card: OverviewCard, onClick: PublishSubject<ControlEvent<UITapGestureRecognizer>.Element?>) {
        super.bind(card: card, onClick: onClick)
        guard let card = card as? SingleLocationOverviewCard else { return }
        overviewTable.delegate = nil
        overviewTable.dataSource = nil
        list.onNext(card.items)

        list.bind(to: overviewTable.rx.items) { [weak self] tableView, row, element in
            guard let self = self else { return UITableViewCell() }
            let cell = self.getCell(element: element, tableView: tableView, indexPath: IndexPath(row: row, section: 0))
            return cell
        }.disposed(by: disposeBag)

        let chips = card.chipsConfig.chips.map { $0.text }
        chipsList.removeAllTags()
        chipsList.bind(chips: chips)
        chipsList.chipBackgroundColor = card.chipsConfig.secondaryColor
        chipsList.chipBorderColor = card.chipsConfig.mainColor
        self.contentView.layer.shadowColor = UIColor.clear.cgColor
    }

    func setImageClick(imageSelected: PublishSubject<Int>) {
        self.imageSelected = imageSelected
    }

    func getCell(element: SingleLocationOverviewItem, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: element.getCellIdentifier(), for: indexPath)

        if let imagesCell = cell as? EnhanceImagesTableCell,
           let item = element as? SingleLocationImagesItem
        {
            imagesCell.imagesCollection.rx.itemSelected.bind { self.imageSelected.onNext($0.row) }.disposed(by: imagesCell.disposeBag)
            imagesCell.initCell(images: item.images)
        } else if let dateCell = cell as? SingleLocationDateCell,
                  let dateItem = element as? SingleLocationDateItem
        {
            dateCell.bind(imageDate: dateItem.imageDate, fullReportDate: dateItem.fullReportDate, region: dateItem.region)
        } else if let imageCell = cell as? SingleLocationImageCell,
                  let imageItem = element as? SingleLocationTagImageItem
        {
            imageCell.bind(data: imageItem.data)
            imageCell.rx.tapGesture().when(.recognized).bind { _ in self.imageSelected.onNext(.zero) }.disposed(by: imageCell.disposeBag)
        }

        return cell
    }
}
