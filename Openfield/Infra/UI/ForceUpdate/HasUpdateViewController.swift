//
//  HasUpdateViewController.swift
//  Openfield
//
//  Created by Omer Cohen on 2/13/20.
//  Copyright © 2020 Prospera. All rights reserved.
//

import STPopup
import SwiftyUserDefaults
import UIKit

protocol HasUpdateViewController: HasPopup {}

extension HasUpdateViewController where Self: UIViewController {
    func showForceUpdatePopup() {
        let sideMargin: CGFloat = 26
        let popupAppStore = UpdatePopUpViewController.instantiate()
        popupAppStore.delegate = self
        let width = UIScreen.main.bounds.width - sideMargin * 2
        popupAppStore.contentSizeInPopup = CGSize(width: width, height: 550)
        let popupController = STPopupController(rootViewController: popupAppStore)
        applyBasicPopupStyle(popupController: popupController, popupType: .phonePrefix, isDismissable: false, dismiss: nil)
        popupController.containerView.clipsToBounds = true
        popupController.containerView.layer.cornerRadius = 10
        popupController.present(in: self)
    }
}
