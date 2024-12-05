//
//  FieldSortingPickerPopupViewController.swift
//  Openfield
//
//  Created by Amitai Efrati on 01/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import FirebaseAnalytics
import Foundation
import NVActivityIndicatorView
import ReactorKit
import Resolver
import RxCocoa
import RxDataSources
import RxSwift
import RxViewController
import STPopup
import SwiftyUserDefaults
import UIKit

class FieldsSortingCellUiElement: FieldListSorting {
    var isSelected: Bool
    
    init(sortingName: String, isSelected: Bool, type: FieldListSortingType) {
        self.isSelected = isSelected
        super.init(sortingName: sortingName, type: type)
    }
}

class FieldsSortingPickerPopupViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet var doneBtn: DoneButton!
    @IBOutlet var mainTitle: Title3BoldPrimary!
    @IBOutlet var sortingsTable: UITableView!
    
    // MARK: - RxSwift
    
    let disposeBag = DisposeBag()
    var sortingList: [FieldsSortingCellUiElement] = []
    
    // MARK: - Members
    
    var currentSortingSelected: FieldListSortingType?
    var originalSortingSelected: FieldListSortingType?
    public weak var delegate: HasFieldSortingPickerPopup?
    
    var fieldsSortingItems: BehaviorSubject<[FieldsSortingCellUiElement]> = BehaviorSubject(value: [])
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        setupUI()
        bind()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        setupStaticTexts()
        setupSelectedItem()
    }
    
    private func setupStaticTexts() {
        mainTitle.text = R.string.localizable.fieldSortingSortBy()
        doneBtn.setTitle(R.string.localizable.fieldSortingSave(), for: .normal)
    }
    
    private func setupSelectedItem() {
        sortingList = [
            FieldsSortingCellUiElement(sortingName: R.string.localizable.fieldSortingLatest(), isSelected: originalSortingSelected == FieldListSortingType.latest, type: FieldListSortingType.latest),
            FieldsSortingCellUiElement(sortingName: R.string.localizable.fieldSortingAToZ(), isSelected: originalSortingSelected == FieldListSortingType.alphanumeric, type: FieldListSortingType.alphanumeric),
            FieldsSortingCellUiElement(sortingName: R.string.localizable.fieldSortingUnread(), isSelected: originalSortingSelected == FieldListSortingType.unread, type: FieldListSortingType.unread)
        ]
    }
    
    private func initTable() {
        sortingsTable.register(UINib(resource: R.nib.fieldsSortingCell), forCellReuseIdentifier: R.reuseIdentifier.fieldsSortingCell.identifier)
        sortingsTable.bounces = false
    }
    
    // MARK: - bind
    
    private func bind() {
        fieldsSortingItems.onNext(self.sortingList)
        
        fieldsSortingItems.bind(to: sortingsTable.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.fieldsSortingCell.identifier, for: IndexPath(row: row, section: 0)) as! FieldsSortingCell
            cell.bind(cell: element, rowIndex: row)
            return cell
        }.disposed(by: disposeBag)
        
        sortingsTable.rx.modelSelected(FieldListSorting.self).subscribe { [weak self] fieldListSorting in
            guard let self = self else { return }
            let updatedSortingList = self.sortingList.map { item in
                item.isSelected = (item.type == fieldListSorting.element!.type)
                return item
            }
            self.fieldsSortingItems.onNext(updatedSortingList)
            guard let element = fieldListSorting.element else { return }
            self.currentSortingSelected = element.type
        }.disposed(by: disposeBag)
        
        sortingsTable.rx.modelSelected(FieldListSorting.self)
            .map{$0.type != self.originalSortingSelected}
            .bind(to: doneBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doneBtn.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            if let sortingSelected = self.currentSortingSelected {
                self.delegate?.selectSorting(sortingType: sortingSelected)
            }
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}

extension FieldsSortingPickerPopupViewController {
    class func instantiate(with selectedSorting: FieldListSortingType) -> FieldsSortingPickerPopupViewController {
        let vc = R.storyboard.fieldsSortingPickerPopupViewController.fieldsSortingPickerPopupViewController()!
        vc.currentSortingSelected = selectedSorting
        vc.originalSortingSelected = selectedSorting
        return vc
    }
}
