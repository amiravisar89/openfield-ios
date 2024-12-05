//
//  PickerPopUp.swift
//  Openfield
//
//  Created by Amitai Efrati on 22/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import STPopup

protocol PickerPopup: HasPopup {
    func selectItem(itemId: Int)
}

extension PickerPopup where Self: UIViewController {
    func showPopup(itemsList: [PickerPopupCellUiElement], initialItemId: Int, titleLabel: String, buttonLabel: String, size: CGSize, cornerRadius: CGFloat, style: STPopupStyle) {
        let pickerPopupViewController = PickerPopupViewController.instantiate(with: initialItemId, itemsList: itemsList, titleLabel: titleLabel, buttonLabel: buttonLabel)
        pickerPopupViewController.delegate = self
        pickerPopupViewController.contentSizeInPopup = size
        let popupController = STPopupController(rootViewController: pickerPopupViewController)
        applyBasicPopupStyle(popupController: popupController, popupType: .language, dismiss: nil)
        popupController.style = style
        popupController.containerView.clipsToBounds = true
        popupController.containerView.layer.cornerRadius = cornerRadius
        popupController.present(in: self)
    }
}
