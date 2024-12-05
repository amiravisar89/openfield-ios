//
//  EnhanceImagesTableCell.swift
//  Openfield
//
//  Created by amir avisar on 05/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class EnhanceImagesTableCell: UITableViewCell {
    // MARK: - Outlets

    @IBOutlet var imagesCollection: UICollectionView!
    @IBOutlet var collectionHiehgtConstraint: NSLayoutConstraint!

    // MARK: - Members

    let disposeBag = DisposeBag()
    var imagesCells: BehaviorSubject<[EnhanceImagesData]> = BehaviorSubject(value: [])

    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()
        initCollection()
        selectionStyle = .none
    }

    func initCollection() {
        imagesCollection.register(UINib(nibName: R.nib.enhanceTagImageViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.enhanceTagImageViewCell.identifier)
    }

    func initCell(images: [EnhanceImagesData]) {
        imagesCells.onNext(images)
        imagesCollection.delegate = nil // As RxSwift docs
        imagesCollection.dataSource = nil // As RxSwift docs
        imagesCollection.rx.setDelegate(self).disposed(by: disposeBag)
        imagesCells.bind(to: imagesCollection.rx.items(cellIdentifier: R.reuseIdentifier.enhanceTagImageViewCell.identifier, cellType: EnhanceTagImageViewCell.self)) { _, data, cell in
            cell.bind(images: data.image, color: data.color, tags: data.tags, showMore: data.showMore, isNightImage: data.isNightImage)
        }.disposed(by: disposeBag)
    }
}

// MARK: - CollectionView

extension EnhanceImagesTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3, height: collectionView.bounds.height)
    }
}
