//
//  WalkThrughPopUpViewController.swift
//  Openfield
//
//  Created by amir avisar on 21/04/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import RxSwift
import UIKit

protocol WalkThrughPopUpViewControllerDelegate: AnyObject {
    func positiveClicked()
    func negativeClicked()
}

class WalkThrughPopUpViewController: UIViewController {
    // MARK: - Members

    weak var delegate: WalkThrughPopUpViewControllerDelegate?
    let disposeBag = DisposeBag()

    // MARK: - Outlets

    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var mainTitle: UILabel!
    @IBOutlet var subTitle: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var rateBtn: ButtonValleyBrandBoldWhite!

    // MARK: - Ovveride

    override func viewDidLoad() {
        super.viewDidLoad()
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.feeddbackWalkthoroughPopup, .sawFeedbackWalktrough))
        mainTitle.text = R.string.localizable.insightHelpImprove()
        subTitle.text = R.string.localizable.feedbackWalkthroughSubtitle()
        rateBtn.titleString = R.string.localizable.rate()
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 5
        view.alpha = 0
        cancelBtn.addBorders(edges: .top, color: UIColor.lightGray.withAlphaComponent(0.4))
        // for animation
        containerView.frame.origin.y = UIScreen.main.bounds.height
        bind()
    }

    func bind() {
        rateBtn.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.positiveClicked()
            self.dismissWithAnimation()
        }.disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // continue animation
        UIView.animate(withDuration: 0.3) {
            self.containerView.center.y = self.view.center.y
            self.view.alpha = 1
        }
    }

    @IBAction func negativeAction(_: Any) {
        delegate?.negativeClicked()
        dismissWithAnimation()
    }

    func dismissWithAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.frame.origin.y = UIScreen.main.bounds.height
            self.view.alpha = 0
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension WalkThrughPopUpViewController {
    class func instantiate() -> WalkThrughPopUpViewController {
        let vc = R.storyboard.walkThrughPopUpViewController.walkThrughPopUpViewController()!
        return vc
    }
}
