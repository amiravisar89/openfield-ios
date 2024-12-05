//
//  SubscribePopupViewController.swift
//  Openfield
//
//  Created by amir avisar on 22/09/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Kingfisher
import Resolver
import UIKit

protocol SubscribePopupViewControllerDelegate: AnyObject {
    func mainBtnClicked()
}

class SubscribePopupViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var secondaryButton: UIButton!
    @IBOutlet var mainButton: UIButton!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!

    // MARK: - Members

    weak var delegate: SubscribePopupViewControllerDelegate?
    private var remoteConfigRepository: RemoteConfigRepository = Resolver.resolve()
    private let getSubscriptionPopupDataUseCase: GetSubscriptionPopupDataUseCase = Resolver.resolve()

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarColor(color: .clear)
        setUpStaticText()
        setUpImage()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1
        }
    }

    // MARK: - Private func

    private func setUpStaticText() {
        secondaryButton.setTitle(getSubscriptionPopupDataUseCase.secondaryButtonTitle(), for: .normal)
        mainButton.setTitle(getSubscriptionPopupDataUseCase.mainButtonTitleUnclick(), for: .normal)
        subtitleLabel.text = getSubscriptionPopupDataUseCase.subtitle()
        titleLabel.text = getSubscriptionPopupDataUseCase.title()
    }

    private func setUpImage() {
        imageView?.kf.setImage(with: getSubscriptionPopupDataUseCase.imageUrl(), placeholder: R.image.imageThumbnailPlaceHolder()!, options: [.transition(.fade(1))], completionHandler:  { result in
            switch result {
            case let .success(value):
                self.imageView?.image = value.image
            case let .failure(error):
                self.imageView?.image = R.image.imageThumbnailPlaceHolder()!
                log.error("KingFisher error: \(error)")
            }
        })
        
    }

    func dismissWithAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }) { _ in
            self.navigationController?.popViewController(animated: false)
        }
    }

    // MARK: - Actions

    @IBAction func mainButtonAction(_: Any) {
        mainButton.backgroundColor = R.color.tealishGreen()
        mainButton.setTitle(getSubscriptionPopupDataUseCase.mainButtonTitleClick(), for: .normal)
        mainButton.isEnabled = false
        delegate?.mainBtnClicked()
    }

    @IBAction func secondaryButtonAction(_: Any) {
        dismissWithAnimation()
    }
}

extension SubscribePopupViewController {
    class func instantiate() -> SubscribePopupViewController {
        let vc = R.storyboard.subscribePopupViewController.subscribePopupViewController()!
        return vc
    }
}
