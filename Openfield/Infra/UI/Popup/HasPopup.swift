//
//  HasPopup.swift
//  Openfield
//
//  Created by Daniel Kochavi on 11/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import STPopup
import UIKit

protocol HasPopup: class {}

extension HasPopup where Self: UIViewController {
    func applyBasicPopupStyle(popupController: STPopupController, popupType: PopupType, isDismissable: Bool = true, dismiss: ((PopupType) -> Void)?) {
        popupController.hidesCloseButton = true
        popupController.navigationBarHidden = true
        if NSClassFromString("UIBlurEffect") != nil {
            let blurEffect = UIBlurEffect(style: .dark)
            popupController.backgroundView = UIVisualEffectView(effect: blurEffect)
        }

        if isDismissable {
            popupController.backgroundView?.addTapGestureRecognizer { [unowned self] in
                if let dismissClosure = dismiss { dismissClosure(popupType) }
                self.dismissPopup()
            }
        }
    }

    func dismissPopup() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
