//
//  SingleLocationImageCell.swift
//  Openfield
//
//  Created by amir avisar on 09/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import RxSwift
import UIKit

class SingleLocationImageCell: UITableViewCell {
    @IBOutlet var tagImage: AppTagView!

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        tagImage.tagImage.clearTags()
        tagImage.tagImage.setImage(image: nil)
        disposeBag = DisposeBag()
    }

    func bind(data: TagsData) {
        tagImage.bind(data: data)
    }
}
