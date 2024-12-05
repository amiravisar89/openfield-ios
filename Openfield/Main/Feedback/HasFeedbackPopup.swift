//
//  HasFeedbackPopup.swift
//  Openfield
//
//  Created by amir avisar on 12/06/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import STPopup

protocol hasFeedBackView: HasPopup {}

extension hasFeedBackView where Self: UIViewController {
    func showFeedBackPopup(size: CGSize, cornerRadius: CGFloat, style: STPopupStyle, reactor: InsightViewReactor) {
        let feedBackPopup = FeedbackViewController.instantiate(with: reactor)

        feedBackPopup.contentSizeInPopup = size
        let popupController = STPopupController(rootViewController: feedBackPopup)
        applyBasicPopupStyle(popupController: popupController, popupType: .language, dismiss: nil)
        popupController.style = style
        popupController.containerView.clipsToBounds = true
        popupController.containerView.layer.cornerRadius = cornerRadius
        popupController.present(in: self)
    }
}
