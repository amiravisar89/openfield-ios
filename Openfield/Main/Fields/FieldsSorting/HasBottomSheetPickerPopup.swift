//
//  HasBottomSheetPickerPopup.swift
//  Openfield
//
//  Created by Amitai Efrati on 01/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import STPopup

protocol HasFieldSortingPickerPopup: HasPopup {
    func selectSorting(sortingType: FieldListSortingType)
}

extension HasFieldSortingPickerPopup where Self: UIViewController {
    func showFieldSortingPopup(sortingType: FieldListSortingType, size: CGSize, cornerRadius: CGFloat, style: STPopupStyle) {
        let fieldSortingPopup = FieldsSortingPickerPopupViewController.instantiate(with: sortingType)
        fieldSortingPopup.delegate = self
        fieldSortingPopup.contentSizeInPopup = size
        let popupController = STPopupController(rootViewController: fieldSortingPopup)
        applyBasicPopupStyle(popupController: popupController, popupType: .language, dismiss: nil)
        popupController.style = style
        popupController.containerView.clipsToBounds = true
        popupController.containerView.layer.cornerRadius = cornerRadius
        popupController.present(in: self)
    }
}
