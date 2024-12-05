//
//  AppCalendarCell.swift
//  Openfield
//
//  Created by amir avisar on 17/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import UIKit
import Resolver

class AppCalendarCell: UICollectionViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayNumberLabel: UILabel!
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    let dateProvider: DateProvider = Resolver.resolve()
    
    public func bind(uiElement: AppCallendarUIElement){
        monthLabel.text = uiElement.monthName
        dayNumberLabel.text = uiElement.dayNumber
        dayNameLabel.text = uiElement.dayName
        mainView.viewBorderWidth = uiElement.enabled && !uiElement.selected ? 1 : .zero
        mainView.backgroundColor = uiElement.selected ? R.color.primaryGreen() : .clear
        monthLabel.textColor = uiElement.selected ? R.color.white() : R.color.gray10()
        dayNumberLabel.textColor = uiElement.selected ? R.color.white() : R.color.blacK()
        dayNameLabel.textColor = uiElement.selected ? R.color.white() : R.color.gray10()
        self.isUserInteractionEnabled = uiElement.enabled
    }

}
