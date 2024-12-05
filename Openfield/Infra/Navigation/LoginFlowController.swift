//
//  LoginFlowController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 31/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

class LoginFlowController {
  let navigationController: BaseNavigationViewController
  let contractProvider: ContractProviderProtocol
  public let parentFlowController: RootFlowController!
  
  init(parentFlowController: RootFlowController, navigationController: BaseNavigationViewController, contractProvider: ContractProviderProtocol) {
    self.parentFlowController = parentFlowController
    self.navigationController = navigationController
    self.contractProvider = contractProvider
  }
  
  func goBackToRoot(animated: Bool) {
    navigationController.popToRootViewController(animated: animated)
  }
  
  func goToSplash() {
    parentFlowController.showSplash()
  }
  
  func goToWelcome() {
    self.navigationController.pushViewController(WelcomeViewController.instantiate(contractProvider: contractProvider, flowController: self), animated: true)
  }
  
  func goToLogin() {
    navigationController.pushViewController(LoginViewController.instantiate(flowController: self), animated: true)
  }
  
  func goToMain() {
    parentFlowController.goToMain()
  }
  
  func restart(){
    parentFlowController.restart()
  }
  
  func pop() {
    navigationController.popViewController(animated: true)
  }
}
