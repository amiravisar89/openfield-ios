//
//  SplashViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 15/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import RxSwift
import SwiftyUserDefaults
import UIKit
import NVActivityIndicatorView

final class SplashViewController: UIViewController, HasUpdateViewController {
  
  @IBOutlet var viewBackground: UIView!
  @IBOutlet weak var loader: NVActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupStaticColor()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loader.startAnimating()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    loader.stopAnimating()
  }
  
  private func setupStaticColor() {
    viewBackground.backgroundColor = R.color.valleyDarkBrand()!
  }
}

extension SplashViewController {
  class func instantiate() -> SplashViewController {
    let vc = R.storyboard.splashViewController.splashViewController()!
    return vc
  }
}
