//
//  ErrorViewController.swift
//  Openfield
//
//  Created by dave bitton on 17/02/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import RxSwift
import UIKit

class ErrorViewController: UIViewController {
    // Itay is the king //
    @IBOutlet var subtitleLbl: BodyRegularPrimary!
    @IBOutlet var titleLbl: Title3BoldPrimary!
    @IBOutlet var headerView: UIView!
    @IBOutlet var actionBtn: Button2!

    let disposeBag: DisposeBag = .init()
    var error: (title: String, subtitle: String)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        actionBtn.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    fileprivate func setupUI() {
        headerView.backgroundColor = R.color.valleyBrand()

        actionBtn.titleString = R.string.localizable.back()
        titleLbl.text = error?.title ?? R.string.localizable.feedOops()
        subtitleLbl.text = error?.subtitle ?? R.string.localizable.feedErrorInsightsSubtitle()
    }
}

// MARK: - Instantiate

extension ErrorViewController {
    class func instantiate(error: (title: String, subtitle: String)? = nil) -> ErrorViewController {
        let vc = R.storyboard.errorViewController.errorViewController()!
        vc.error = error
        return vc
    }
}
