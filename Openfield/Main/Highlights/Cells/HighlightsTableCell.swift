//
//  HighlightsTableCell.swift
//  Openfield
//
//  Created by amir avisar on 14/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import UIKit

class HighlightsTableCell: UITableViewCell {

    @IBOutlet weak var card: HighlightCard!
    
    func bind(cardData: HighlightCardData) {
        card.initCard(card: cardData)
    }
    
}
