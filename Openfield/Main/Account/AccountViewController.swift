//
//  AccountViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 16/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import FirebaseAnalytics
import ReactorKit
import Resolver
import RxSwift
import UIKit
import RxViewController

final class AccountViewController: UIViewController, StoryboardView, HasBasicPopup {
  var disposeBag: DisposeBag = .init()
  
  @IBOutlet weak var notificationCell: NotificationCell!
  @IBOutlet weak var logoutCell: LogoutCell!
  @IBOutlet weak var yourRollCell: YourRollCell!
  @IBOutlet weak var helpCenterCell: HelpCenterCell!
  @IBOutlet weak var yourAccountCell: YourAccountCell!
  @IBOutlet weak var languageCell: AccountLanguageCell!
  @IBOutlet weak var mainScrollView: UIScrollView!
  @IBOutlet weak var versionCell: AccountVersionCell!
  
  @IBOutlet weak var secondaryStackView: UIStackView!
  weak var flowController: MainFlowController!
  let translationService: TranslationService = Resolver.resolve()
  let getUserRolesUseCase: GetUserRolesUseCase = Resolver.resolve()
  let animationProvider: AnimationProvider = Resolver.resolve()

  typealias Reactor = AccountViewReactor

  @IBOutlet weak var viewBackground: UIView!
  @IBOutlet weak var topHeader: UIView!

  @IBOutlet weak var backBtn: UIImageView!
  @IBOutlet weak var headerTitle: Title2RegularWhiteBold!

  // MARK: - LanguagePopup

  let languagePopupHeight: CGFloat = 300
  let languagePopupCornerRadius: CGFloat = 10

  override func viewDidLoad() {
    super.viewDidLoad()
    setupStaticColor()
    setupStaticTexts()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let screenViewParams = [AnalyticsParameterScreenName: ScreenName.accountSettings, AnalyticsParameterScreenClass: String(describing: AccountViewController.self), EventParamKey.category: EventCategory.settings]
    Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
    PerformanceManager.shared.stopTrace(for: .account_settings)
  }

  private func setupStaticColor() {
    viewBackground.backgroundColor = R.color.screenBg()!
    topHeader.backgroundColor = R.color.valleyDarkBrand()!
  }

  private func setupStaticTexts() {
    headerTitle.text = R.string.localizable.accountSettings()
  }

  private func setupStaticCells() {
    helpCenterCell.isHidden = false
    logoutCell.isHidden = false
    versionCell.isHidden = false
    versionCell.titleLabel.text = "Version: \(ConfigEnvironment.appVersion)"
  }

  private func setupCells() {
    notificationCell.delegate = self
    setupQA()
  }

  private func setupQA() {
    logoutCell.contentView.accessibilityIdentifier = "AcoountSettingsLogout"
  }

  private func showLanguagePopUpWithParams() {
    let width = UIScreen.main.bounds.width
    showLanguagePopup(size: CGSize(width: width, height: languagePopupHeight), cornerRadius: languagePopupCornerRadius, style: .bottomSheet)
  }

  func basicPopupDismissed(type: PopupType) {
    switch type {
    case .disableNotification:
      enableNotification(enable: true)
    case .logout:
      trackCancelLogout()
    default:
      break
    }
  }

  func basicPopupPositiveClicked(type: PopupType) {
    dismissPopup()
    switch type {
    case .disableNotification:
      enableNotification(enable: false)
    case .logout:
      logOut()
    default:
      break
    }
  }

  func basicPopupNegativeClicked(type: PopupType) {
    dismissPopup()
    switch type {
    case .disableNotification:
      enableNotification(enable: true)
    case .logout:
      trackCancelLogout()
    default:
      break
    }
  }

  private func trackCancelLogout() {
    EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.settingsLogout, .logoutConfirmCancel))
  }

  private func logOut() {
    
    Observable.just(())
      .map { [weak self] _ in
        guard let self = self else {return .nothing}
        return Reactor.Action.logOut(navigation: self.flowController.restart) }
      .bind(to: reactor!.action)
      .disposed(by: disposeBag)
  }

  private func enableNotification(enable: Bool) {
    Observable.just(())
      .map { Reactor.Action.changeNotificationState(to: enable) }
      .bind(to: reactor!.action)
      .disposed(by: disposeBag)
  }

  private func handleRoleSelected(roles: [String]?) {
    guard let roles = roles else {
      yourRollCell.subtitleLabel.textColor = .red
      yourRollCell.subtitleLabel.text = R.string.localizable.roleNoRoleSelected()
      return
    }
    yourRollCell.subtitleLabel.textColor = .lightGray
    yourRollCell.subtitleLabel.text = roles.joined(separator: ", ")
  }

  func bind(reactor: AccountViewReactor) {

    logoutCell.contentView.rx.tapGesture()
      .when(.recognized)
      .map { [unowned self]_ in Reactor.Action.showLogoutPopup(logoutConfirmationDialog: self.showLogoutDialog) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    languageCell.contentView.rx.tapGesture()
      .when(.recognized)
      .map { [unowned self] _ in Reactor.Action.showLanguagePopup(show: self.showLanguagePopUpWithParams) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    yourRollCell.contentView.rx.tapGesture()
      .when(.recognized)
      .map { [unowned self] _ in Reactor.Action.showYourRollView(yourRollDialog: self.showYorRollDialog) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    helpCenterCell.contentView.rx.tapGesture()
      .when(.recognized)
      .map { [unowned self] _ in Reactor.Action.goToHelpCenter(navigation: self.navigateToUrl) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    backBtn.rx.tapGesture()
      .when(.recognized)
      .subscribe(onNext: { [unowned self] _ in self.flowController.pop()})
      .disposed(by: disposeBag)
    notificationCell
      .notificationSwitchButton
      .rx
      .tapGesture()
      .when(.recognized)
      .map { [unowned self] _ in Reactor.Action.flipNotificationState(disableDialog: self.showDisableDialog) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    reactor.state
      .compactMap { $0.userLanguage }
      .map { $0.name }
      .distinctUntilChanged()
      .map { $0.capitalized }
      .bind(to: languageCell.subtitleLabel.rx.text)
      .disposed(by: disposeBag)

    // State
    reactor.state
      .compactMap { ($0.user?.settings) }
      .observeOn(MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] settings in
        self?.notificationCell.notificationSwitch.isOn = settings.notificationsEnabled
        self?.notificationCell.notificationsEnabled = settings.notificationsEnabled
        self?.notificationCell.setToggleIndex(settings.notificationsPush ? 0 : 1)
      })
      .disposed(by: disposeBag)

    reactor.state.compactMap { ($0.user?.settings) }
      .observeOn(MainScheduler.instance)
      .distinctUntilChanged()
      .map { [weak self] userSettings -> [String]? in
        guard let self = self else { return nil }
        return self.translateRole(role: userSettings.userRole)
      }
      .subscribe { [weak self] roles in
        guard let self = self else { return }
        guard let roles = roles.element else { return }
        self.handleRoleSelected(roles: roles)
      }.disposed(by: disposeBag)

    reactor.state
      .observeOn(MainScheduler.instance)
      .map { ($0.user?.phone) }
      .subscribe(onNext: { [weak self] phone in self?.notificationCell.phoneNumber = phone })
      .disposed(by: disposeBag)

    let setupStaticCellsObs = Observable.just(setupStaticCells())
    let userObserver = reactor.state.compactMap { $0.user }
    
    Observable.combineLatest(rx.viewDidAppear, setupStaticCellsObs)
      .flatMap { _ in userObserver }
      .observeOn(MainScheduler.instance)
      .take(1) // We setup the entire list only once
      .subscribe(onNext: { [weak self] user in
        guard let self = self else { return }
        self.setupCells()
        self.secondaryStackView.isHidden = false
        guard user.isOwner else {
          self.yourAccountCell.isHidden = true
          return
        }
        _ = self.animationProvider.animate(duration: 0.3, delay: .zero, animations: { [weak self] in
          self?.mainScrollView.layoutIfNeeded()
        }).subscribe()
      })
      .disposed(by: disposeBag)
  }

  private func translateRole(role: UserRole?) -> [String]? {
    let configRoles = getUserRolesUseCase.roles()

    guard let userRole = role else { return nil }
    guard let rolesIds = userRole.rolesIds else { return nil }
    let filteredIds = userRole.rolesIds?.filter { $0 != UserRoleConfiguration.OtherRoleId }

    guard var translatedRoles = filteredIds?.compactMap({ [weak self] id -> String? in
      guard let self = self else { return nil }
      guard let configRole = configRoles.first(where: { $0.id == id }) else { return nil }
      return self.translationService.localizedString(localizedString: configRole.i18n_role, defaultValue: configRole.id)
    }) else { return nil }

    if let otherText = userRole.otherText {
      translatedRoles.append(otherText)
    } else if rolesIds.contains(UserRoleConfiguration.OtherRoleId) {
      translatedRoles.append(R.string.localizable.roleOther())
    }
    return translatedRoles
  }

  private func navigateToUrl(url: URL) {
    UIApplication.shared.open(url)
  }

  private func showDisableDialog() {
    showBasicPopup(data: BasicPopupData(title: R.string.localizable.accountNotificationsPopUpTitle(),
                                        subtitle: R.string.localizable.accountNotificationsPopUpSubtitle(),
                                        okButton: R.string.localizable.continue(),
                                        cancelButton: R.string.localizable.cancel(),
                                        type: .disableNotification))
  }

  private func showLogoutDialog() {
    showBasicPopup(data: BasicPopupData(title: R.string.localizable.accountLogoutPopUpTitle(),
                                        okButton: R.string.localizable.accountLogoutPopUpOk(),
                                        cancelButton: R.string.localizable.cancel(),
                                        type: .logout))
  }

  private func showYorRollDialog() {
    let vc = RoleSelectionViewController.instantiate(type: .popUp2)
    vc.delegate = self
    navigationController?.present(vc, animated: false, completion: nil)
  }
}

extension AccountViewController {
  class func instantiate(reactor: AccountViewReactor, flowController: MainFlowController) -> AccountViewController {
    let vc = R.storyboard.accountViewController.accountViewController()!
    vc.flowController = flowController
    vc.reactor = reactor
    return vc
  }
}

extension AccountViewController: NotificationCellDelegate {
  func notificationTypeChanged(value: String) {
    Observable
      .just(value)
      .map { _ in Reactor.Action.changedNotificationType }
      .bind(to: reactor!.action)
      .disposed(by: disposeBag)
  }
}

extension AccountViewController: HasLanguagePickerPopup {
  func selectLanguage(language: LanguageData) {
    Observable
      .just(language)
      .map { [weak self] _ in
        guard let self = self else {return .nothing}
        return Reactor.Action.updateUserLanguage(language: language, splashNavigation: self.flowController.restart) }
      .bind(to: reactor!.action)
      .disposed(by: disposeBag)
  }
}

extension AccountViewController: RoleSelectionDelegate {
  func roleSelected(role: UserRole) {
    Observable
      .just(())
      .map { Reactor.Action.updateUserRole(role: role) }
      .bind(to: reactor!.action)
      .disposed(by: disposeBag)
  }
}
