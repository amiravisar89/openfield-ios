//
//  HasLanguagePickerPopup.swift
//  Openfield
//
//  Created by amir avisar on 02/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import STPopup

protocol HasLanguagePickerPopup: HasPopup {
    func selectLanguage(language: LanguageData)
}

extension HasLanguagePickerPopup where Self: UIViewController {
    func showLanguagePopup(size: CGSize, cornerRadius: CGFloat, style: STPopupStyle) {
        let langugePopup = LanguagePickerPopupViewController.instantiate()
        langugePopup.delegate = self
        langugePopup.contentSizeInPopup = size
        let popupController = STPopupController(rootViewController: langugePopup)
        applyBasicPopupStyle(popupController: popupController, popupType: .language, dismiss: nil)
        popupController.style = style
        popupController.containerView.clipsToBounds = true
        popupController.containerView.layer.cornerRadius = cornerRadius
        popupController.present(in: self)
    }
}
