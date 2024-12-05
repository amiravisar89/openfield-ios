//
//  ShareableInsightVC.swift
//  Openfield
//
//  Created by dave bitton on 04/02/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Resolver
import UIKit

protocol ShareableVC where Self: UIViewController {
    func share(withText text: String, view: UIView?)
}

extension ShareableVC {
    func share(withText text: String, view: UIView?) {
        let viewToshare = view ?? self.view
        let itemToShare: [Any] = [text] as [Any]
        let activityVc = UIActivityViewController(activityItems: itemToShare, applicationActivities: nil)
        if let popoverController = activityVc.popoverPresentationController { popoverController.sourceView = viewToshare }
        present(activityVc, animated: true, completion: nil)
    }
}
