//
//  LoaderViewController.swift
//  Openfield
//
//  Created by dave bitton on 28/02/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import NVActivityIndicatorView
import UIKit

class LoaderViewController: UIViewController {
    lazy var loadingIndicator: NVActivityIndicatorView = {
        let loaderSize = CGSize(width: 20, height: 20)
        let loadingIndicator = NVActivityIndicatorView(frame: CGRect(origin: .zero, size: loaderSize))
        loadingIndicator.color = R.color.valleyBrand()!
        loadingIndicator.type = .circleStrokeSpin
        loadingIndicator.center = view.bounds.center
        loadingIndicator.startAnimating()
        return loadingIndicator
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = R.color.lightGrey()
        view.addSubview(loadingIndicator)
    }
}
