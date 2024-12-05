//
//  SingleIssueIndexedNamedCell.swift
//  Openfield
//
//  Created by amir avisar on 16/02/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import UIKit

class SingleIssueIndexedNamedCell: SingleIssueCell {
    @IBOutlet var dotView: UIView!
    @IBOutlet var nameLabel: SubHeadlineBoldWhite!

    func bind(images: [AppImage], tagsArray: [LocationTag], isSelected: Bool, TagsColor: UIColor, index: String, color: UIColor, name: String) {
        super.bind(images: images, tagsArray: tagsArray, isSelected: isSelected, TagsColor: TagsColor, index: index)
        nameLabel.text = name
        dotView.backgroundColor = color
    }
}
