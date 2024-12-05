//
//  AppCalendarCollection.swift
//  Openfield
//
//  Created by amir avisar on 17/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import UIKit
import Resolver

@IBDesignable
class AppCalendarCollection: UIView {
    
    private let feebackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var datesCollection: UICollectionView!
    
    private let elements : BehaviorSubject<[AppCallendarElement]> = BehaviorSubject(value: [])
    private let uiMapper: AppCalendarUiMapper = Resolver.resolve()

    public let itemSelected : PublishSubject<AppCallendarElement> = PublishSubject()
    public let disposeBag = DisposeBag()
    
    var items : [AppCallendarElement]? {
        try? elements.value()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        initCollection()
    }
    
    private func setupView() {
        UINib(resource: R.nib.appCalendarCollection).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in make.left.right.top.bottom.equalToSuperview() }
        datesCollection.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0, right: 10.0)
        bind()
    }
    
    private func bind() {
        self.elements.map({ [weak self] elements in
            guard let self = self else {return [AppCallendarUIElement]()}
            return uiMapper.map(elements: elements)
        }).bind(to: datesCollection.rx.items(cellIdentifier: R.reuseIdentifier.appCalendarCell.identifier, cellType: AppCalendarCell.self)) { _, element, cell in
            cell.bind(uiElement: element)
        }.disposed(by: disposeBag)
        
        self.datesCollection.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self else {return }
            let item = try? self.elements.value()[indexPath.row]
            if item?.enabled == true {
                self.itemSelected.onNext(item!)
                self.feebackGenerator.impactOccurred()
            }
        }.disposed(by: disposeBag)
    }
    
    private func initCollection() {
        datesCollection.register(UINib(nibName: R.nib.appCalendarCell.identifier, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.appCalendarCell.identifier)
    }
    
    public func setDates(elements: [AppCallendarElement]) {
        self.elements.onNext(elements)
    }
    
    public func goToIndex(index: Int, animated: Bool = false) {
        datesCollection.scrollToItem(at: IndexPath(row: index, section: .zero), at: .centeredHorizontally, animated: animated)
    }
    
  
}



