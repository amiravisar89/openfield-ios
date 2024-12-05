//
//  FieldImageryCell.swift
//  Openfield
//
//  Created by amir avisar on 14/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import UIKit

class FieldImageryCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var fieldImage: ImageViewer!
    @IBOutlet weak var buttonTitle: UILabel!
    
    func bind(uiElement: FieldImageCellUiElement) {
        fieldImage.display(images: uiElement.images)
        title.text = uiElement.title
        content.text = uiElement.content
        buttonTitle.text = uiElement.buttonTitle
    }

}
