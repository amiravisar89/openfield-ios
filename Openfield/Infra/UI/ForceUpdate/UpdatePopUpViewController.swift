//
//  UpdatePopUpViewController.swift
//  Openfield
//
//  Created by Omer Cohen on 2/13/20.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import StoreKit
import STPopup

class UpdatePopUpViewController: UIViewController, SKStoreProductViewControllerDelegate {
    // MARK: - Outlets

    @IBOutlet var mainTitleLabel: Title3BoldPrimary!
    @IBOutlet var contentLabel: BodyRegularSecondary!
    @IBOutlet var updateNowButton: Button5!

    // MARK: - Members

    public var delegate: HasUpdateViewController?
    var storeProductViewController = SKStoreProductViewController()
    // An automatically generated ID assigned to your app.
    let appleID = 1_497_154_674
    private let appStoreUrl = "itms-apps://apple.com/app"

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStaticText()
        setupUI()
    }

    // MARK: - UI

    private func setupStaticText() {
        mainTitleLabel.text = R.string.localizable.updateVersionUpdateRequired()
        contentLabel.text = R.string.localizable.updateNewVersionAvailable()
        updateNowButton.titleString = R.string.localizable.updateUpdateNow()
    }

    private func setupUI() {
        storeProductViewController.delegate = self
        updateNowButton.backgroundColor = R.color.valleyBrand()
        updateNowButton.addTarget(self, action: #selector(goToAppStore(_:)), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc func goToAppStoreInsideTheApp(_: Any) {
        // Create a product dictionary using the App Store's iTunes identifer.
        let parametersDict = [SKStoreProductParameterITunesItemIdentifier: appleID]

        /* Attempt to load it, present the store product view controller if success
         and print an error message, otherwise. */
        storeProductViewController.loadProduct(withParameters: parametersDict, completionBlock: { (status: Bool, error: Error?) in
            if status {
                self.present(self.storeProductViewController, animated: true, completion: nil)
            } else {
                log.warning("Error opening app store: \(error?.localizedDescription ?? "No error provided")")
            }
        })
    }

    @objc func goToAppStore(_: Any) {
        if let url = URL(string: "\(appStoreUrl)/\(appleID)") {
            UIApplication.shared.open(url)
        }
    }

    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension UpdatePopUpViewController {
    class func instantiate() -> UpdatePopUpViewController {
        let vc = R.storyboard.updatePopUpViewController.updatePopUpViewController()!
        return vc
    }
}
