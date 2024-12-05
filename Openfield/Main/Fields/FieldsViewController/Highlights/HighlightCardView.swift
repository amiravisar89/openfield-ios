//
//  OverviewCell.swift
//  Openfield
//
//  Created by Itay Kaplan on 03/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import FSPagerView
import RxCocoa
import RxSwift
import UIKit

class HighlightCardView: FSPagerViewCell {
    
    @IBOutlet weak var card: HighlightCard!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.shadowColor = UIColor.clear.cgColor
    }
    
    func bind(cardData: HighlightCardData) {
        card.initCard(card: cardData)
    }
    
}



