//
//  AppAlertController.swift
//  Openfield
//
//  Created by amir avisar on 15/04/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AppAlertController: UIAlertController {

    func addButtons(actions : [UIAlertAction]){
        actions.forEach { action in
            self.addAction(action)
        }
    }
}
