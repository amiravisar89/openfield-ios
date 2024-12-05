//
//  ComparePopUpViewController.swift
//  Openfield
//
//  Created by amir avisar on 19/07/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import ImageIO
import SwiftyGif
import UIKit

class ComparePopUpViewController: UIViewController {
    // MARK: - Members

    @IBOutlet var viewHolder: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var gifView: UIImageView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGif()
        setUpStaticText()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1
        }
    }

    private func setUpStaticText() {
        titleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.adjustsFontSizeToFitWidth = true
        closeBtn.setTitle(R.string.localizable.thanksGotIt(), for: .normal)
        titleLabel.text = R.string.localizable.compareCompareFields()
        titleLabel.textColor = R.color.valleyBrand()
        let myString = R.string.localizable.compareComparingDifferentDatesOrLayers() + R.string.localizable.compareCheckItOut()
        let attributedString = NSMutableAttributedString(string: myString)
        attributedString.setColorFor(text: R.string.localizable.compareCheckItOut(), withColor: R.color.secondary()!)
        subtitleLabel.attributedText = attributedString
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func setupGif() {
        do {
            let gif = try UIImage(gifName: "compare_gif.gif")
            gifView.setGifImage(gif, loopCount: -1) // Will loop forever
        } catch {
            log.error("Compare gif couldn't load with error: \(error.localizedDescription)")
        }
    }

    // MARK: - Action

    @IBAction func closeAction(_: Any) {
        dismissWithAnimation()
    }

    func dismissWithAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension ComparePopUpViewController {
    class func instantiate() -> ComparePopUpViewController {
        let vc = R.storyboard.comparePopUpViewController.comparePopUpViewController()!
        return vc
    }
}
