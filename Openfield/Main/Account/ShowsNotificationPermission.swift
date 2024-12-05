//
//  ShowsNotificationPermission.swift
//  Openfield
//
//  Created by Daniel Kochavi on 13/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

protocol ShowsNotificationPermission: class {
    func canceledPermissionDialog()
}

extension ShowsNotificationPermission where Self: UIViewController {
    func showCustomPermissionDialog() {
        DispatchQueue.main.async {
            let appName = ConfigEnvironment.appName

            let alert = UIAlertController(title: "\"\(appName)\" would like to send you notifications", message: "To continue, allow notifications in the device Settings", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { _ in
                self.canceledPermissionDialog()
            })

            alert.addAction(cancelAction)
            alert.addAction(settingsAction)
            alert.preferredAction = settingsAction

            self.present(alert, animated: true, completion: nil)
        }
    }
}
