//
//  EmptyLocationOverviewCell.swift
//  Openfield
//
//  Created by dave bitton on 10/03/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import UIKit

class EmptyLocationOverviewCell: OverviewCell {
    static let height = 220.0

    @IBOutlet var summeryLabel: BodyRegularSecondary!
    @IBOutlet var button: ButtonValleyBrandBoldWhite!

    override func bind(card: OverviewCard, onClick: PublishSubject<ControlEvent<UITapGestureRecognizer>.Element?>) {
        super.bind(card: card, onClick: onClick)
        guard let overViewCard = (card as? EmptyLocationOverviewCard) else { return }
        summeryLabel.text = overViewCard.summery
        button.titleString = R.string.localizable.insightEmptyLocationOverviewCardButtonLabel()
        forQA()
    }

    func forQA() {
        summeryLabel.accessibilityIdentifier = "summery_label"
        button.accessibilityIdentifier = "image_button"
    }
}
