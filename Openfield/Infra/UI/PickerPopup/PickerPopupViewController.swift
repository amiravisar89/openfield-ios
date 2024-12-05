//
//  PickerPopupViewController.swift
//  Openfield
//
//  Created by Amitai Efrati on 22/02/2024.
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

class PickerPopupCellUiElement {
    var isSelected: Bool
    var name: String
    var id: Int
    
    init(name: String, isSelected: Bool, id: Int) {
        self.name = name
        self.isSelected = isSelected
        self.id = id
    }
}

class PickerPopupViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet var doneBtn: DoneButton!
    @IBOutlet var mainTitle: Title3BoldPrimary!
    @IBOutlet var itemsTable: UITableView!
    
    // MARK: - RxSwift
    
    let disposeBag = DisposeBag()
    
    // MARK: - Members
    
    var currentSelectedItemId: Int?
    var originalSelectedItemId: Int?
    var titleLabel: String?
    var buttonLabel: String?
    var itemsList: [PickerPopupCellUiElement] = []
    public weak var delegate: PickerPopup?
    var items: BehaviorSubject<[PickerPopupCellUiElement]> = BehaviorSubject(value: [])
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        setupUI()
        bind()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        setupTexts()
    }
    
    private func setupTexts() {
        mainTitle.text = titleLabel
        doneBtn.setTitle(buttonLabel, for: .normal)
    }
    
    private func initTable() {
        itemsTable.register(UINib(resource: R.nib.pickerPopupCell), forCellReuseIdentifier: R.reuseIdentifier.pickerPopupCell.identifier)
        itemsTable.bounces = false
    }
    
    // MARK: - bind
    
    private func bind() {
        items.onNext(self.itemsList)
        
        items.bind(to: itemsTable.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.pickerPopupCell.identifier, for: IndexPath(row: row, section: 0)) as! PickerPopupCell
            cell.bind(cell: element, rowIndex: row)
            return cell
        }.disposed(by: disposeBag)
        
        itemsTable.rx.modelSelected(PickerPopupCellUiElement.self).subscribe { [weak self] uiElement in
            guard let self = self else { return }
            let updatedItemsList = self.itemsList.map { item in
                item.isSelected = (item.id == uiElement.element!.id)
                return item
            }
            self.items.onNext(updatedItemsList)
            guard let element = uiElement.element else { return }
            self.currentSelectedItemId = element.id
        }.disposed(by: disposeBag)
        
        itemsTable.rx.modelSelected(PickerPopupCellUiElement.self)
            .map{$0.id != self.originalSelectedItemId}
            .bind(to: doneBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doneBtn.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            if let itemSelected = self.currentSelectedItemId {
                self.delegate?.selectItem(itemId: itemSelected)
            }
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}

extension PickerPopupViewController {
    class func instantiate(with initialItemId: Int, itemsList: [PickerPopupCellUiElement], titleLabel: String, buttonLabel: String) -> PickerPopupViewController {
        let vc = R.storyboard.pickerPopupViewController.pickerPopupViewController()!
        vc.currentSelectedItemId = initialItemId
        vc.originalSelectedItemId = initialItemId
        vc.itemsList = itemsList
        vc.titleLabel = titleLabel
        vc.buttonLabel = buttonLabel
        return vc
    }
}

