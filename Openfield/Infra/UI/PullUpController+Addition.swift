//
//  PullUpController+Addition.swift
//  Openfield
//
//  Created by Daniel Kochavi on 20/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import PullUpController

extension PullUpController {
    func hideAndRemovePullUpController() {
        pullUpControllerMoveToVisiblePoint(0, animated: true) {
            self.removePullUpController(self, animated: true)
        }
    }

    func hidePullUpController() {
        pullUpControllerMoveToVisiblePoint(0, animated: true, completion: nil)
    }
}
