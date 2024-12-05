//
//  ContractViewController.swift
//  Openfield
//
//  Created by amir avisar on 14/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import NVActivityIndicatorView
import RxSwift
import UIKit
import WebKit

class ContractViewController: UIViewController {
    @IBOutlet var titleLabel: Title3Bold!
    @IBOutlet var closeBtn: UIImageView!
    @IBOutlet var gotItBtn: BrandButton!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var gradientView: GradientView!
    @IBOutlet var loadingIndicator: NVActivityIndicatorView!

    let disposeBag = DisposeBag()
    var contract: Contract!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = contract.title
        initWebView(link: contract.url)
        setupColors()
        setupStaticTexts()
        bind()
        settingAccessibilityIds()
    }

    private func setupColors() {
        view.backgroundColor = R.color.white()
        loadingIndicator.color = R.color.valleyBrand()!
        gradientView.startColor = R.color.white()!.withAlphaComponent(0)
        gradientView.endColor = R.color.white()!.withAlphaComponent(1)
        gradientView.startLocation = 0.0
        gradientView.endLocation = 0.2
    }

    private func setupStaticTexts() {
        gotItBtn.titleString = R.string.localizable.gotItButton()
    }

    private func initWebView(link: String) {
        guard let url = URL(string: link) else {
            return
        }
        webView.load(URLRequest(url: url))
    }

    private func bind() {
        loadingIndicator.startAnimating()

        closeBtn.rx.tapGesture().observeOn(MainScheduler.instance).when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)

        gotItBtn.rx.tapGesture().observeOn(MainScheduler.instance).when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)

        webView.rx.didFinishLoad.observeOn(MainScheduler.instance).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
        }.disposed(by: disposeBag)
    }

    private func settingAccessibilityIds() {
        titleLabel.accessibilityIdentifier = "title"
        closeBtn.accessibilityIdentifier = "close_button"
        gotItBtn.accessibilityIdentifier = "got_it_button"
        webView.accessibilityIdentifier = "web_view"
    }
}

extension ContractViewController {
    class func instantiate(contract: Contract) -> ContractViewController {
        let vc = R.storyboard.contractViewController.contractViewController()!
        vc.contract = contract
        return vc
    }
}
