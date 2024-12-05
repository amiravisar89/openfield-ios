//
//  EnhanceLocationCell.swift
//  Openfield
//
//  Created by amir avisar on 03/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import FSPagerView
import ReactorKit
import Resolver
import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import UIKit

class EnhanceLocationCell: FSPagerViewCell {
    // MARK: - Outlets

    @IBOutlet var enhanceTable: UITableView!
    @IBOutlet var gradientView: GradientView!
    @IBOutlet weak var highlightBanner: HighlightBanner!
    // MARK: - Static

    static let height = 300.0
    let footerHeight = 10.0

    // MARK: - Members

    var disposeBag: DisposeBag = .init()

    var infoClick: PublishSubject<ControlEvent<UITapGestureRecognizer>.Element?> = PublishSubject()
    var imageSelected: PublishSubject<Int> = PublishSubject()
    var secctions: BehaviorSubject<[EnhanceSectionItem]> = BehaviorSubject(value: [])

    lazy var dataSource: RxTableViewSectionedReloadDataSource<EnhanceSectionItem> = {
        return RxTableViewSectionedReloadDataSource<EnhanceSectionItem>(configureCell: { _, tableView, indexPath, enhanceItem in
            switch enhanceItem.type {
            case let .description(enhanceIdemDescription):
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.enhanceDescriptionTableCell.identifier, for: indexPath) as! EnhanceDescriptionTableCell
                cell.bind(itemDescription: enhanceIdemDescription)
                return cell
            case let .severity(severity):
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.enhanceSeverityTableCell.identifier, for: indexPath) as! EnhanceSeverityTableCell
                cell.initCell(severityItem: severity)
                return cell
            case let .imagesCollection(images):
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.enhanceImagesTableCell.identifier, for: indexPath) as! EnhanceImagesTableCell
                cell.imagesCollection.rx.itemSelected.bind { self.imageSelected.onNext($0.row) }.disposed(by: cell.disposeBag)
                cell.initCell(images: images)
                return cell
            }
        })
    }()

    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()
        enhanceTable.register(UINib(resource: R.nib.enhanceSeverityTableCell), forCellReuseIdentifier: R.reuseIdentifier.enhanceSeverityTableCell.identifier)
        enhanceTable.register(UINib(resource: R.nib.enhanceDescriptionTableCell), forCellReuseIdentifier: R.reuseIdentifier.enhanceDescriptionTableCell.identifier)
        enhanceTable.register(UINib(resource: R.nib.enhanceImagesTableCell), forCellReuseIdentifier: R.reuseIdentifier.enhanceImagesTableCell.identifier)
        let tableFooter = UIView(frame: CGRect(x: 0, y: 0, width: enhanceTable.bounds.width, height: footerHeight))
        tableFooter.backgroundColor = UIColor.clear
        enhanceTable.tableFooterView = tableFooter
        initQA()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    // MARK: - QA

    func initQA() {}

    func initCell(card: EnhanceLocationCard, infoClick: PublishSubject<ControlEvent<UITapGestureRecognizer>.Element?>, imageSelected: PublishSubject<Int>) {
        self.infoClick = infoClick
        self.imageSelected = imageSelected
        highlightBanner.isHidden = card.highlight == nil
        highlightBanner.titleLable.text = card.highlight
        secctions.onNext(card.sections)
        self.contentView.layer.shadowColor = UIColor.clear.cgColor
        enhanceTable.delegate = self
        bind()
    }

    // MARK: - Bind

    func bind() {
        secctions
            .bind(to: enhanceTable.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        enhanceTable.rx.didScroll.throttle(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.toggleGradientView(show: self.shouldShowGradient())
            }.disposed(by: disposeBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        toggleGradientView(show: shouldShowGradient())
    }

    func shouldShowGradient() -> Bool {
        let offSetY = enhanceTable.contentOffset.y
        let contentHeight = enhanceTable.contentSize.height
        return offSetY < (contentHeight - enhanceTable.frame.size.height - footerHeight)
    }

    func toggleGradientView(show: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.gradientView.alpha = show ? 1 : 0
        }
    }
}

// MARK: - TableView

extension EnhanceLocationCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = EnhanceSectionHeaderView.instanceFromNib(rect: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: EnhanceSectionHeaderView.height))
        header.bind(title: dataSource.sectionModels[section].title, summery: dataSource.sectionModels[section].summery, onClick: infoClick)
        return header
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return EnhanceSectionHeaderView.height
    }
}
