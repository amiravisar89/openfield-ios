//
//  BasicPopupViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 07/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import RxSwift
import STPopup
import UIKit

struct BasicPopupData {
    let title: String
    var subtitle: String? = nil
    let okButton: String
    var cancelButton: String? = nil
    let type: PopupType
}

class BasicPopupViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var cancelButton: SGButton!
    @IBOutlet var okButton: SGButton!
    @IBOutlet var viewBackground: UIView!

    public weak var delegate: HasBasicPopup?

    fileprivate var popupData: BasicPopupData?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = popupData else {
            log.error("No initial data passed to: \(#file)")
            return
        }

        titleLabel.text = data.title

        if let subtitle = data.subtitle {
            subtitleLabel.text = subtitle
        } else {
            subtitleLabel.isHidden = true
        }

        if let cancelText = data.cancelButton {
            cancelButton.titleString = cancelText
        } else {
            cancelButton.isHidden = true
        }

        okButton.titleString = data.okButton
        setupStaticColor()
    }

    private func setupStaticColor() {
        viewBackground.backgroundColor = R.color.white()
    }

    @IBAction func okClicked(_: Any) {
        delegate?.basicPopupPositiveClicked(type: popupData!.type)
    }

    @IBAction func cancelClicked(_: Any) {
        delegate?.basicPopupNegativeClicked(type: popupData!.type)
    }
}

extension BasicPopupViewController {
    class func instantiate() -> BasicPopupViewController {
        let vc = R.storyboard.basicPopupViewController.basicPopupViewController()!
        return vc
    }
}

protocol HasBasicPopup: HasPopup {
    func basicPopupDismissed(type: PopupType)
    func basicPopupPositiveClicked(type: PopupType)
    func basicPopupNegativeClicked(type: PopupType)
}

extension HasBasicPopup where Self: UIViewController {
    func showBasicPopup(data: BasicPopupData) {
        let basicPopupViewController = BasicPopupViewController.instantiate()
        basicPopupViewController.delegate = self
        basicPopupViewController.popupData = data
        basicPopupViewController.contentSizeInPopup = basicPopupViewController.view.systemLayoutSizeFitting(
            CGSize(width: 330, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        let popupController = STPopupController(rootViewController: basicPopupViewController)
        applyBasicPopupStyle(popupController: popupController, popupType: data.type, dismiss: basicPopupDismissed)
        popupController.present(in: self)
    }
}
