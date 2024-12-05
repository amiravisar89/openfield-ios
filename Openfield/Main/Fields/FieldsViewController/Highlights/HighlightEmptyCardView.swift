//
//  HighlightsEmptyCardView.swift
//  Openfield
//
//  Created by amir avisar on 28/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import FSPagerView
import RxCocoa
import RxSwift
import UIKit

class HighlightEmptyCardView: FSPagerViewCell {
    
    @IBOutlet weak var subtitleLabel: Title6RegularGray!
    @IBOutlet weak var titleLabel: Title9SemiBoldBlack!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = R.color.white()!
        viewCornerRadius = 16
        viewBorderWidth = 1
        viewBorderColor = R.color.grey3()!
        contentView.layer.shadowColor = UIColor.clear.cgColor
    }
    
    func bind(uiElement: HighlightEmptyCardData) {
        titleLabel.text = uiElement.title
        subtitleLabel.text = uiElement.subtitle
    }
    
}
