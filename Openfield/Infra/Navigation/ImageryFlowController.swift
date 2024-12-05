//
//  ImageryFlowController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 01/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

class ImageryFlowController {
    let navigationController: UINavigationController
    public let parentFlowController: MainFlowController!

    init(parentFlowController: MainFlowController, navigationController: UINavigationController) {
        self.parentFlowController = parentFlowController
        self.navigationController = navigationController
    }

    func beginFlow(from _: UIViewController, with imageryDate: Date, forceRefresh: Bool = false, animated: Bool) {
        let vc = ImageryPopupViewController.instantiate(with: imageryDate, forceRefresh: forceRefresh, flowController: self)
        navigationController.present(vc, animated: animated)
    }

    func goToAnalysis(params: AnalysisParams, animated _: Bool) {
        let vc = AnalysisHolderViewController.instantiate(with: params)
        navigationController.present(vc, animated: true)
    }

    func leaveFlow() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
