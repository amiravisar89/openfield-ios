//
//  HasPhonePrefixPickerViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 11/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import STPopup

protocol HasPhonePrefixPickerViewController: HasPopup {
    func selectedCountry(country: CountryCellData)
}

extension HasPhonePrefixPickerViewController where Self: UIViewController {
    func showPhonePrefixPopup() {
        let sideMargin: CGFloat = 26
        let phonePrefixPopup = PhonePrefixPickerViewController.instantiate()
        phonePrefixPopup.delegate = self
        let width = UIScreen.main.bounds.width - sideMargin * 2
        phonePrefixPopup.contentSizeInPopup = CGSize(width: width, height: 550)
        let popupController = STPopupController(rootViewController: phonePrefixPopup)
        applyBasicPopupStyle(popupController: popupController, popupType: .phonePrefix, dismiss: nil)
        popupController.containerView.clipsToBounds = true
        popupController.containerView.layer.cornerRadius = 2
        popupController.present(in: self)
    }
}
