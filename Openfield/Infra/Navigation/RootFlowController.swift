//
//  RootFlowController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 31/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Reachability
import Resolver
import SwiftyUserDefaults
import UIKit
import RxSwift

protocol LoginFlowDelegate {
  func loggedIn()
}

class RootFlowController {
  var loginFlowController: LoginFlowController!
  var mainFlowController: MainFlowController!
  var splashViewController: SplashViewController!
  var navigationController: BaseNavigationViewController
  var userStateProvider: UserStateProvider
  var loginDelegate: LoginFlowDelegate?
  let languageService: LanguageService
  let remoteConfigRepo : RemoteConfigRepositoryProtocol
  let reachability = try? Reachability()
  var disposeBag = DisposeBag()
  var alertController: UIAlertController?
  private let getVersionsLimitUseCase: GetVersionsLimitUseCaseProtocol!
  
  typealias IntentHandler = (_ intent: Intent?, _ afterLogin: Bool) -> Void
  var intentHandler: IntentHandler?
  var pendingIntent: Intent? {
    didSet {
      guard let _ = pendingIntent,
            let tabVC = mainFlowController?.tabController,
            navigationController.viewControllers.contains(tabVC) else { return }
      guard Defaults.seenAppwalkthrough.contains(Defaults.userId) else { return }
      // means there is a pending intent and
      // we are somewhere in the tabs controller, so if pending intent was set, we can initiate the handler
      executeIntentHandlerIfNeeded(afterLogin: false)
    }
  }
  
  init(navigationController: BaseNavigationViewController, userStateProvider: UserStateProvider, languageService: LanguageService, getVersionsLimitUseCase: GetVersionsLimitUseCaseProtocol, remoteConfigRepo : RemoteConfigRepositoryProtocol) {
    self.navigationController = navigationController
    self.userStateProvider = userStateProvider
    self.languageService = languageService
    self.getVersionsLimitUseCase = getVersionsLimitUseCase
    self.remoteConfigRepo = remoteConfigRepo
    self.splashViewController = SplashViewController.instantiate()
  }
  
  func setup() {
    mainFlowController = MainFlowController(parentFlowController: self, navigationController: navigationController)
    loginFlowController = LoginFlowController(parentFlowController: self, navigationController: navigationController, contractProvider: Resolver.resolve())
    navigationController.pushViewController(splashViewController, animated: false)
    startListeningNetwork()
    handleReachabilityChanges()
  }
  
  func showSplash() {
    navigationController.popToRootViewController(animated: true)
  }
  
  func goToMain() {
    loggedIn()
  }
  
  func restart(){
    showSplash()
    startNavigation()
  }
  
  private func handleLanguage() {
    let userStreamUseCase: UserStreamUsecase = Resolver.resolve()
    userStreamUseCase.userStream().compactMap { $0.settings.languageCode }
      .take(1)
      .subscribe { [weak self] languageCode in
        self?.languageService.setLanguage(languageCode: languageCode)
      }.disposed(by: disposeBag)
  }
  
  func start() {
    
    remoteConfigRepo
      .fetch()
      .observeOn(MainScheduler.instance)
      .subscribe(onCompleted: { [weak self] in
        guard let self = self else {
          log.error("Could not start app")
          return
        }
        let minVersion = self.getVersionsLimitUseCase.force()
        log.info("Minimum force version: \(minVersion)")
        let currentVersion = ConfigEnvironment.appBundleVersion
        
        guard currentVersion >= minVersion else {
          self.showForceUpdate()
          return
        }
        self.startNavigation()
       
      }, onError: { [weak self] error in
        log.error("Error fetching remote config \(error.localizedDescription)")
        self?.startNavigation()
      })
      .disposed(by: disposeBag)
    
  }
  
  private func startNavigation() {
    if userStateProvider.isUserLoggedIn() {
      loggedIn()
    } else {
      loginFlowController.goToWelcome()
    }
  }
  
  private func loggedIn() {
    handleLanguage()
    mainFlowController.goToMainTabs()
    guard Defaults.seenAppwalkthrough.contains(Defaults.userId) else {
      mainFlowController.goToAppwalkThrough() { [weak self] in
        self?.executeIntentHandlerIfNeeded(afterLogin: true)
      }
      return
    }
    executeIntentHandlerIfNeeded(afterLogin: true)
  }
  
  private func showForceUpdate(){
    splashViewController.showForceUpdatePopup()
  }
  
  func handleReachabilityChanges() {
    if reachability?.connection == .unavailable {
      if userStateProvider.isUserLoggedIn() {
        showConnectionErrorPopUp()
      }
    }
    
    reachability?.whenReachable = { reachability in
      if reachability.connection == .wifi || reachability.connection == .cellular {
        self.alertController?.dismiss(animated: true, completion: nil)
      }
    }
    reachability?.whenUnreachable = { _ in
      if self.userStateProvider.isUserLoggedIn() {
        self.showConnectionErrorPopUp()
      }
    }
  }
  
  func showConnectionErrorPopUp() {
    EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.noConnection, .sawNoConnectionError))
    self.alertController = UIAlertController(title: R.string.localizable.noConnectionNoInternetConnection(), message: R.string.localizable.noConnectionCheckYourInternetConnection(), preferredStyle: UIAlertController.Style.alert)
    guard let alertController = alertController else {
      return
    }
    alertController.addAction(UIAlertAction(title: R.string.localizable.ok(), style: UIAlertAction.Style.default, handler: nil))
    guard let presentedVc = navigationController.presentedViewController else {
      navigationController.present(alertController, animated: true, completion: nil)
      return
    }
    presentedVc.present(alertController, animated: true, completion: nil)
  }
  
  func startListeningNetwork() {
    do {
      try reachability?.startNotifier()
    } catch {
      log.warning("Unable to start reachability notifier")
    }
  }
  
  private func executeIntentHandlerIfNeeded(afterLogin: Bool) {
    guard pendingIntent != nil else { return }
    intentHandler?(pendingIntent, afterLogin)
    pendingIntent = nil
  }
}
