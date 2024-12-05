//
//  WelcomeViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 29/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import FirebaseAnalytics
import ReactorKit
import Resolver
import RxSwift
import STPopup
import UIKit

class WelcomeViewController: UIViewController, StoryboardView, HasContractPopup {
    var disposeBag: DisposeBag = .init()
    typealias Reactor = WelcomeViewReactor
    weak var flowController: LoginFlowController!
    var contractProvider: ContractProviderProtocol!

    @IBOutlet var subscriptionButton: Button9!
    @IBOutlet var languageBtn: UIButton!
    @IBOutlet var loginWithPhoneButton: Button8!
    @IBOutlet var companeyLabel: DenimSmallTextViewRegular!
    @IBOutlet var troubleLoginTextView: DenimTextViewRegular!

    // MARK: - LanguagePopup

    let sideMargin: CGFloat = 26
    let languagePopupHeight: CGFloat = 300
    let languagePopupCornerRadius: CGFloat = 2

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let screenViewParams = [AnalyticsParameterScreenName: ScreenName.welcome, AnalyticsParameterScreenClass: String(describing: WelcomeViewController.self), EventParamKey.category: EventCategory.login]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStaticContent()
        setupContractAttributedText()
        setupTroubleLoginText()
    }

    func bind(reactor: WelcomeViewReactor) {
        // Actions
        loginWithPhoneButton.rx.tapGesture()
            .when(.recognized)
            .map { [weak self] _ in
              guard let self = self else {return Reactor.Action.nothing}
              return Reactor.Action.navigateToLogin(navigate: self.navigateToLogin) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        subscriptionButton.rx.tapGesture()
            .when(.recognized)
            .map { [weak self] _ in
              guard let self = self else {return Reactor.Action.nothing}
              return Reactor.Action.clickSubscription(navigation: self.navigateToUrl(url:)) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        languageBtn.rx.tapGesture()
            .when(.recognized)
            .map { [weak self]_ in
              guard let self = self else {return Reactor.Action.nothing}
              return Reactor.Action.showLanguagePopup(show: self.showLanguagePopUpWithParams) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // reactor
        reactor.state
            .compactMap { $0.userLanguage }
            .map { $0.locale.languageCode?.uppercased() }
            .distinctUntilChanged()
            .bind(to: languageBtn.rx.title())
            .disposed(by: disposeBag)
    }

    private func showLanguagePopUpWithParams() {
        let width = UIScreen.main.bounds.width - sideMargin * 2
        showLanguagePopup(size: CGSize(width: width, height: languagePopupHeight), cornerRadius: languagePopupCornerRadius, style: .formSheet)
    }

    private func setupStaticContent() {
        loginWithPhoneButton.titleString = R.string.localizable.loginLoginWithPhone()
        subscriptionButton.titleString = R.string.localizable.loginSubscribeToValley()
    }

    func setupTroubleLoginText() {
        troubleLoginTextView.text = "\(R.string.localizable.loginTroubleLogin()) \(R.string.localizable.loginContactSupport())"
        troubleLoginTextView.delegate = self
        let attributes = [TextViewAttribute(text: R.string.localizable.loginContactSupport(),
                                            color: R.color.valleyBrand()!,
                                            type: ContractType.support.rawValue, queryParam: URLParam.contractType.rawValue)]
        troubleLoginTextView.setAttributes(attributes: attributes)
    }

    func setupContractAttributedText() {
        companeyLabel.text = "\(R.string.localizable.loginValmontIdustries()) \(ConfigEnvironment.appVersion)"
        companeyLabel.delegate = self
        let attributes = [TextViewAttribute(text: R.string.localizable.loginValmontIdustriesLinkPart(),
                                            color: R.color.valleyBrand()!,
                                            type: ContractType.terms.rawValue, queryParam: URLParam.contractType.rawValue)]
        companeyLabel.setAttributes(attributes: attributes)
    }

    func navigateToContractScreen(contractVersion: Double, contract: Contract) {
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.contract, .navigateToContract, [EventParamKey.contractType: contract.type.rawValue,
                                                                                                                 EventParamKey.contractVersion: String(contractVersion)]))
        showContractPopUp(cornerRadius: 8, contract: contract, style: .formSheet)
    }

    private func navigateToUrl(url: URL) {
        UIApplication.shared.open(url)
    }

    private func navigateToLogin() {
        flowController.goToLogin()
    }
}

extension WelcomeViewController {
  class func instantiate(contractProvider: ContractProviderProtocol, flowController: LoginFlowController) -> WelcomeViewController {
        let vc = R.storyboard.welcomeViewController.welcomeViewController()!
        vc.contractProvider = contractProvider
        vc.flowController = flowController
        vc.reactor = Resolver.optional()
        return vc
    }
}

extension WelcomeViewController: HasLanguagePickerPopup {
    func selectLanguage(language: LanguageData) {
        Observable
            .just(language)
            .map { _ in Reactor.Action.updateUserLanguage(language: language, splashNavigation: self.flowController.restart) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
}

extension WelcomeViewController: UITextViewDelegate {
    func textView(_: UITextView, shouldInteractWith URL: URL, in _: NSRange, interaction _: UITextItemInteraction) -> Bool {
        guard let params = URL.queryParameters,
              let contractType = params[URLParam.contractType.rawValue],
              let contract = ContractType(rawValue: contractType) else { return false }

        switch contract {
        case .terms:
            guard let contract = contractProvider.getContract(by: contract),
                  let remoteContracts = contractProvider.remoteContracts else { return false }
            navigateToContractScreen(contractVersion: remoteContracts.version, contract: contract)
        case .privacy:
            break
        case .changes:
            break
        case .support:
            guard let reactor = reactor else { break }
            Observable.just(Reactor.Action.goToSupport(navigation: navigateToUrl)).observeOn(MainScheduler.instance)
                .bind(to: reactor.action).disposed(by: disposeBag)
        }
        return false
    }
}
