//
//  MainFlowController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 31/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Resolver
import RxSwift
import UIKit
import Resolver

class MainFlowController {
  let navigationController: BaseNavigationViewController
  weak var tabController: ContainerViewController?
  public let parentFlowController: RootFlowController!
  var imageryFlowController: ImageryFlowController!
  var disposeBag = DisposeBag()
  var tabControllerSelectedIndex: CustomTabBar.TabItem = .fields
  
  typealias WalkthroughCallback = () -> Void
  var walkthroughCallback: WalkthroughCallback?
  
  init(parentFlowController: RootFlowController, navigationController: BaseNavigationViewController) {
    self.parentFlowController = parentFlowController
    self.navigationController = navigationController
    imageryFlowController = ImageryFlowController(parentFlowController: self, navigationController: navigationController)
  }
  
  func goBackToRoot(animated: Bool) {
    navigationController.popToRootViewController(animated: animated)
    imageryFlowController.leaveFlow()
  }
  
  func goToMainTabs() {
    let inboxVC = InboxListViewController.instantiate(flowController: self)
    let fieldListVC = FieldsListViewController.instantiate(flowContorller: self, animationProvider: Resolver.resolve())
    
    let tabViewControllers = [
      fieldListVC,
      inboxVC,
    ]
    
    let mainVC = ContainerViewController.instantiate(withViewControllers: tabViewControllers,
                                                     selectedIndex: tabControllerSelectedIndex,
                                                     contractProvider: Resolver.resolve(),
                                                     flowController: self, animationProvider: Resolver.resolve(), reactor: Resolver.resolve())
    tabController = mainVC
    navigationController.pushViewController(mainVC, animated: true)
  }
  
  func pop() {
    navigationController.popViewController(animated: true)
  }
  
  func goToIboxTab() {
    guard let tabController = tabController else { return }
    tabController.externalPageChange(tab: .insights)
  }
  
  func goToMyFieldsTab() {
    guard let tabController = tabController else { return }
    tabController.externalPageChange(tab: .fields)
  }
  
  func showRollPopUp(vc: RoleSelectionDelegate, type: RolePopUpType, setting _: UserSettings) {
    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
      DispatchQueue.main.async {
        let rolePopupVC = RoleSelectionViewController.instantiate(type: type)
        rolePopupVC.delegate = vc
        self.navigationController.present(rolePopupVC, animated: false, completion: nil)
      }
    }
  }
  
  func showSubscriptionPopUp(vc: SubscribePopupViewControllerDelegate) {
    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
      DispatchQueue.main.async {
        let surveyPopUpVC = SubscribePopupViewController.instantiate()
        surveyPopUpVC.delegate = vc
        self.navigationController.pushViewController(surveyPopUpVC, animated: false)
      }
    }
  }
  
  func goToAccount() {
    let accountVC = AccountViewController.instantiate(reactor: Resolver.resolve(), flowController: self)
    navigationController.pushViewController(accountVC, animated: true)
  }
  
  func goToIrrigationInsight(insightUid : String, origin: NavigationOrigin) {
    let farmFilter: FarmFilter = Resolver.resolve()
    if origin == .link || origin == .notification { farmFilter.resetFarms() }
    let irrigationInsightVC = InsightViewController.instantiate(insightUid: insightUid, origin: origin, flowController: self)
    navigationController.pushViewController(irrigationInsightVC, animated: true)
  }
  
  func goToLocationInsight(insightUid: String, category: String, subCategory: String, fieldId: Int?,  cycleId: Int?, publicationYear: Int?, origin: NavigationOrigin) {
    let farmFilter: FarmFilter = Resolver.resolve()
    if origin == .link || origin == .notification { farmFilter.resetFarms() }
    let locationInsightVC = LocationInsightsPagerViewController.instantiate(insightUid: insightUid, category: category, subCategory: subCategory, fieldId: fieldId, cycleId: cycleId, publicationYear: publicationYear, origin: origin, flowController: self)
    navigationController.pushViewController(locationInsightVC, animated: true)
  }
  
  func goToImageryPopup(imageryDate: Date, forceRefresh: Bool = false, animated: Bool, origin: NavigationOrigin) {
    let farmFilter: FarmFilter = Resolver.resolve()
    if origin == .link || origin == .notification { farmFilter.resetFarms() }
    goToIboxTab()
    EventTracker.track(event: AnalyticsEventFactory.buildDialogEvent(EventCategory.imageryPopup, ImageryPopupViewController.analyticName, true, [EventParamKey.origin: origin.rawValue]))
    imageryFlowController.beginFlow(from: navigationController, with: imageryDate, forceRefresh: forceRefresh, animated: animated)
  }
  
  func naviagteToErrorScreen(withError error: (title: String, subtitle: String)? = nil) {
    let errorVC = ErrorViewController.instantiate(error: error)
    navigationController.pushViewController(errorVC, animated: true)
  }
  
  func navigateToHighlights(fieldId : Int? = nil, categoryId : String? = nil) {
    let highlightsVC = HighlightsViewController.instantiate(flowContorller: self, highlightsCardsProvider: Resolver.resolve(), animationProvider: Resolver.resolve(), fieldId: fieldId, categoryId: categoryId)
    
    navigationController.pushViewController(highlightsVC, animated: true)
  }
  
  func navigateToSignContractScreen() {
    let contractProvider: TermsOfUseProviderProtocol = Resolver.resolve()
    let signContractVC = SignContractViewController.instantiate(contractProvider: contractProvider, flowController: self, reactor: Resolver.resolve())
    navigationController.present(signContractVC, animated: true)
  }
  
  func restart() {
    parentFlowController.restart()
  }
  
  func goToAppwalkThrough(completion: WalkthroughCallback? = nil) {
    let appWalkthrough = AppWalkthroughViewController.instantiate(reactor: Resolver.resolve(), flowController: self)
    appWalkthrough.delegate = self
    walkthroughCallback = completion
    navigationController.pushViewController(appWalkthrough, animated: false)
  }
  
  func showLoaderOnContainer() {
    tabController?.showLoader()
  }
  
  func hideLoaderOnContainer() {
    tabController?.hideLoader()
  }
  
  func setStatusBarStyle(style: UIStatusBarStyle) {
    navigationController.setStatusBarStyle(style: style)
  }
  
  func present(_ viewControllerToPresent: UIViewController, animated: Bool) {
    navigationController.present(viewControllerToPresent, animated: animated)
  }
  
}

extension MainFlowController: AppWalkthroughViewControllerDelegate {
  func AppWalkthroughViewControllerDismissed() {
    guard let callback = walkthroughCallback else { return }
    callback()
  }
}

enum NavigationOrigin: String {
  case highlights
  case feed
  case link
  case field
  case notification
  case fields_list
  case insights_list
  case location_insight
  case irrigation_insight
  case highlights_list
  case fields_highlights
  case imagery_popup
  case insight_drawer
  case insight
  case app_launch
  case account_settings
  case farm_selection
  case analysis
  case field_after_season_selection
  case virtual_scouting
}
