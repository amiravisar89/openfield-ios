//
//  BaseNavigationViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 16/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController, UINavigationControllerDelegate {
  
  var style : UIStatusBarStyle = .lightContent
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.isTranslucent = false
    navigationBar.barTintColor = R.color.valleyBrand()
    navigationBar.shadowImage = UIImage() // Hide bottom separator
    navigationBar.isHidden = true
    delegate = self
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return self.style
  }
  
  func setStatusBarStyle(style: UIStatusBarStyle) {
    self.style = style
    setNeedsStatusBarAppearanceUpdate()
  }
  
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    interactivePopGestureRecognizer?.isEnabled = !(viewController is ContainerViewController || viewController is WelcomeViewController)
  }
}
