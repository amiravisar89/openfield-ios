//
//  HasContractPopUp.swift
//  Openfield
//
//  Created by amir avisar on 14/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import STPopup
import UIKit

protocol HasContractPopup: HasPopup {}

extension HasContractPopup where Self: UIViewController {
    var popUpWidth: CGFloat {
        return UIScreen.main.bounds.width - 40
    }

    var popUpHeight: CGFloat {
        return UIScreen.main.bounds.height - 100
    }

    func showContractPopUp(cornerRadius: CGFloat, contract: Contract, style: STPopupStyle) {
        let contractPopUp = ContractViewController.instantiate(contract: contract)
        contractPopUp.contentSizeInPopup = CGSize(width: popUpWidth, height: popUpHeight)
        let popupController = STPopupController(rootViewController: contractPopUp)
        applyBasicPopupStyle(popupController: popupController, popupType: .contract, dismiss: nil)
        popupController.style = style
        popupController.containerView.clipsToBounds = true
        popupController.containerView.layer.cornerRadius = cornerRadius
        popupController.present(in: self)
    }
}
