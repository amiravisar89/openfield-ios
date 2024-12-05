//
//  HighlightPagerTableCell.swift
//  Openfield
//
//  Created by amir avisar on 29/07/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import UIKit
import FSPagerView
import RxSwift
import Resolver

class HighlightPagerTableCell: UITableViewCell {

    @IBOutlet weak var hightLightsPager: FSPagerView!
    @IBOutlet weak var highlightsPageController: FSPageControl!
    @IBOutlet weak var pagerControllerContainer: UIView!
    
    private let highlights : PublishSubject<[HighlightItem]> = PublishSubject()
    private let highlightsCardsProvider : HighlightsCardsProvider = Resolver.resolve()

    public let itemSelected : PublishSubject<Int> = PublishSubject()
    
    public var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupHighlightsPager()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    public func bind(to item: FieldHighlightsContent) {
        bind()
        highlights.onNext(item.highlights)
    }
    
    private func setupHighlightsPager() {
        hightLightsPager.register(UINib(resource: R.nib.highlightCardView), forCellWithReuseIdentifier: R.reuseIdentifier.highlightCardView.identifier)
        hightLightsPager.register(UINib(resource: R.nib.highlightEmptyCardView), forCellWithReuseIdentifier: R.reuseIdentifier.highlightEmptyCardView.identifier)

        hightLightsPager.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: 165)
        highlightsPageController.contentHorizontalAlignment = .center
        highlightsPageController.setStrokeColor(R.color.gray4(), for: .normal)
        highlightsPageController.setStrokeColor(R.color.valleyBrand(), for: .selected)
        highlightsPageController.setFillColor(R.color.valleyBrand(), for: .selected)
        highlightsPageController.setFillColor(R.color.gray4(), for: .normal)
    }
    
    private func bind(){
        hightLightsPager.rx.willEndDragging.subscribe { [weak self] index in
            self?.highlightsPageController.currentPage = index
        }.disposed(by: disposeBag)
        
        highlights.map{$0.count}.observeOn(MainScheduler.instance).subscribe { [weak self] count in
            guard let self = self,
                  let count = count.element else {return}
            self.highlightsPageController.numberOfPages = count
        }.disposed(by: disposeBag)
        
        highlights.map{$0.count == 1}
            .bind(to: self.pagerControllerContainer.rx.isHidden)
            .disposed(by: disposeBag)
        
        highlights.distinctUntilChanged().observeOn(MainScheduler.instance).subscribe { [weak self] isEmpty in
            guard let self = self else {return}
            self.highlightsPageController.currentPage = self.hightLightsPager.currentIndex
        }.disposed(by: disposeBag)
        
        hightLightsPager.rx.itemSelected.subscribe { [weak self] index in
            self?.itemSelected.onNext(index)
        }.disposed(by: disposeBag)
        
        highlights
            .compactMap{ [weak self] in
                self?.highlightsCardsProvider.cards(highlights: $0)
            }
            .bind(to: hightLightsPager.rx.items) { pagerView, index, element in
                switch element.type {
                case .cardData(let data):
                    let card = pagerView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.highlightCardView.identifier, at: index) as! HighlightCardView
                    card.bind(cardData: data)
                    return card
                case .empty(let emptyData):
                    let card = pagerView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.highlightEmptyCardView.identifier, at: index) as! HighlightEmptyCardView
                    card.bind(uiElement: emptyData)
                    return card
                }
            }.disposed(by: disposeBag)
        
    }
    
}
