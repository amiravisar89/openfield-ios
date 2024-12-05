//
//  AppImageGallery.swift
//  Openfield
//
//  Created by amir avisar on 19/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import UIKit
import Resolver
import FSPagerView

@IBDesignable
class AppImageGallery: UIView {
    
    @IBOutlet private weak var pagerController: FSPageControl!
    @IBOutlet private weak var imagesPager: FSPagerView!
    @IBOutlet private var contentView: UIView!
    
    private let elements : PublishSubject<[AppImageGalleyElement]> = PublishSubject()
    private let uiMapper: AppGalleyUiMapper = Resolver.resolve()
    
    public let indexSelected : PublishSubject<Int> = PublishSubject()
    public let indexDisplayed : PublishSubject<Int> = PublishSubject()
    public let didEndDecelerating : PublishSubject<Int> = PublishSubject()
    public let disposeBag = DisposeBag()
  
    private var pagerHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        initPager()
    }
  
    func setPagerHeightBasedOnImageSize(width: CGFloat, height: CGFloat) {
      let aspectRatio = height / width
      let newHeight = imagesPager.frame.size.width * aspectRatio
      pagerHeightConstraint?.constant = newHeight   
      pagerHeightConstraint?.isActive = true

      layoutIfNeeded()
    }
  
    
    
    private func setupView() {
        UINib(resource: R.nib.appImageGallery).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in make.left.right.top.bottom.equalToSuperview() }
        pagerHeightConstraint = imagesPager.heightAnchor.constraint(equalToConstant: 0)
        setPageController()
        bind()
    }
    
    private func bind(){
        elements
            .map { [weak self] elements -> [AppImageGalleyUIElement] in
                guard let self = self else {return [AppImageGalleyUIElement]()}
                return self.uiMapper.map(elements: elements)
            }
            .do { [weak self] cards in
                self?.imagesPager.isInfinite = cards.count > 1
                self?.pagerController.numberOfPages = cards.count
                self?.pagerController.isHidden = cards.count == 1
                self?.pagerController.currentPage = self?.imagesPager.currentIndex ?? 0
            }
            .bind(to: imagesPager.rx.items(cellIdentifier: R.reuseIdentifier.appGalleryImageCell.identifier, cellType: AppGalleryImageCell.self)) { _, element, cell in
                cell.bind(uiElement: element)
            }.disposed(by: disposeBag)

        imagesPager.rx.willEndDragging
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] index in
                self?.pagerController.currentPage = index
            })
            .disposed(by: disposeBag)

        imagesPager.rx.willDisplayCell
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] c, index in
                self?.indexDisplayed.onNext(index)
            })
            .disposed(by: disposeBag)
        
        imagesPager.rx.itemSelected.subscribe { [weak self] index in
            self?.indexSelected.onNext(index)
        }.disposed(by: disposeBag)
        
        imagesPager.rx.didEndDecelerating.subscribe { [weak self] element in
            self?.didEndDecelerating.onNext(element.currentIndex)
        }.disposed(by: disposeBag)

        imagesPager.rx.didEndDisplayingCell.subscribe { (cell: FSPagerViewCell, _: Int) in
            guard let galleryCell = cell as? AppGalleryImageCell else {
                return
            }
            galleryCell.image.cancelDownloadTask()
        }.disposed(by: disposeBag)
    }
    
    private func setPageController(){
        pagerController.contentHorizontalAlignment = .center
        pagerController.setStrokeColor(R.color.grey3(), for: .normal)
        pagerController.setStrokeColor(R.color.valleyBrand(), for: .selected)
        pagerController.setFillColor(R.color.valleyBrand(), for: .selected)
        pagerController.setFillColor(R.color.grey3(), for: .normal)
    }
    
    private func initPager() {
        imagesPager.register(UINib(resource: R.nib.appGalleryImageCell), forCellWithReuseIdentifier: R.reuseIdentifier.appGalleryImageCell.identifier)
    }
    
    public func setImages(images: [AppImageGalleyElement]) {
        elements.onNext(images)
    }
    
    public func goToIndex(index: Int, animated: Bool = false) {
        imagesPager.scrollToItem(at: index, animated: animated)
        pagerController.currentPage = index
    }

    public func currentIndex() -> Int {
        return pagerController.currentPage
    }

}
