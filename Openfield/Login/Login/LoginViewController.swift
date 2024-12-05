//
//  LoginViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 29/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import FirebaseAnalytics
import ReactorKit
import Resolver
import RxCocoa
import RxSwift
import RxViewController
import UIKit

enum LoginPage: Int {
    case phone = 0
    case code = 1
    case impersonation = 2
    case welcome = 3
}

class LoginViewController: UIViewController, StoryboardView, HasPhonePrefixPickerViewController {
    var disposeBag: DisposeBag = .init()
    weak var flowController: LoginFlowController!
    private var containedViews: [UIView]?
    private var currentPage: LoginPage? {
        didSet {
            switch currentPage {
            case .phone:
                let screenViewParams = [AnalyticsParameterScreenName: ScreenName.loginPhone, AnalyticsParameterScreenClass: String(describing: EnterPhoneView.self), EventParamKey.category: EventCategory.login]
                Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
            case .code:
                let screenViewParams = [AnalyticsParameterScreenName: ScreenName.loginCode, AnalyticsParameterScreenClass: String(describing: EnterCodeView.self), EventParamKey.category: EventCategory.login]
                Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
            case .impersonation:
                let screenViewParams = [AnalyticsParameterScreenName: ScreenName.loginImpersonation, AnalyticsParameterScreenClass: String(describing: ImpersonationView.self), EventParamKey.category: EventCategory.login]
                Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
            default:
                break
            }
        }
    }

    private var enterPhoneView: EnterPhoneView?
    private var enterCodeView: EnterCodeView?
    private var impersonationView: ImpersonationView?
    private let supportPhoneNumber: String = "18882230595"
    private var targetText = ""
    typealias Reactor = LoginViewReactor

    @IBOutlet var customKeyboard: KeyboardView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var backBtn: UIImageView!

    private var translationService: TranslationService = Resolver.resolve()

    override func viewDidLoad() {
        super.viewDidLoad()
        initWithPage(page: .phone)
        customKeyboard.isAccessibilityElement = false // QA
    }

    func selectedCountry(country: CountryCellData) {
        Observable
            .just(country.prefix)
            .map { [weak self] prefix in
                if self?.currentPage == .phone {
                    return Reactor.Action.changePhonePrefix(newPrefix: prefix)
                } else {
                    return Reactor.Action.changePhoneImpersonationPrefix(newPrefix: prefix)
                }
            }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }

    func bind(reactor: LoginViewReactor) {
        // Actions
        enterCodeView?.resendCodeLabel.rx.tapGesture()
            .when(.recognized)
            .map { _ in Reactor.Action.resendSms }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        enterPhoneView?.prefixNumberView.rx.tapGesture()
            .when(.recognized)
            .map { [unowned self] _ in Reactor.Action.phonePrefixPopup(effect: self.showPhonePrefixPopup) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        impersonationView?.prefixNumberView.rx.tapGesture()
            .when(.recognized)
            .map { [unowned self] _ in Reactor.Action.phonePrefixPopup(effect: self.showPhonePrefixPopup) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        backBtn.rx.tapGesture()
            .when(.recognized)
            .map { _ in Reactor.Action.navigateBackward }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        enterPhoneView?.sendCodeButton.rx.tapGesture()
            .when(.recognized)
            .map { _ in Reactor.Action.sendSMS }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        impersonationView?.impersonationButton.rx.tapGesture()
            .when(.recognized)
            .map { [unowned self] _ in Reactor.Action.impersonate(doneNavigation: self.flowController.goToMain) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        impersonationView?.loginAsYourselfButton.rx.tapGesture()
            .when(.recognized)
            .map { [unowned self] _ in Reactor.Action.loginAsYourself(doneNavigation: self.flowController.goToMain) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        enterCodeView?.loginButton.rx.tapGesture()
            .when(.recognized)
            .map { [unowned self] _ in Reactor.Action.login(doneNavigation: self.flowController.goToMain) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        customKeyboard.rx.tapKey
            .map { [unowned self] key in Reactor.Action.numberPressed(key: key, doneNavigation: self.flowController.goToMain) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        customKeyboard.rx.tapDelete
            .map { Reactor.Action.deletePressed }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State
        reactor.state.map { $0.enterPhoneState.isPhoneLoading }
            .bind(to: enterPhoneView!.sendCodeButton.rx.loading)
            .disposed(by: disposeBag)

        reactor.state.map { $0.enterPhoneState.isPhoneEnabled }
            .bind(to: enterPhoneView!.sendCodeButton.rx.enable)
            .disposed(by: disposeBag)

        reactor.state.map { $0.enterPhoneState.phoneErrorMessage }
            .bind(to: enterPhoneView!.errorMessage.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.enterPhoneState.prefixPhone } // TODO-Eyal: check for different solution than delay
            .distinctUntilChanged()
            .map { [weak self] prefix in
                self?.enterPhoneView!.prefixNumberLabel.text = prefix
            }
            .delay(.milliseconds(5), scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.enterPhoneView!.prefixNumberView.addBottomBorderWithColor(color: R.color.primary()!, width: 2.0)
            })
            .subscribe()
            .disposed(by: disposeBag)

        reactor.state.map { $0.enterPhoneState.suffixPhone }
            .bind(to: enterPhoneView!.suffixNumberLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.impersonationState.isImpersonateLoading }
            .bind(to: impersonationView!.impersonationButton.rx.loading)
            .disposed(by: disposeBag)

        reactor.state.map { $0.impersonationState.isImpersonateEnabled }
            .bind(to: impersonationView!.impersonationButton.rx.enable)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.impersonationState.isSkipLoading }
            .bind(to: impersonationView!.loginAsYourselfButton.rx.loading)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.impersonationState.isSkipEnabled }
            .bind(to: impersonationView!.loginAsYourselfButton.rx.enable)
            .disposed(by: disposeBag)

        reactor.state.map { $0.impersonationState.errorMessage }
            .bind(to: impersonationView!.errorMessage.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.impersonationState.prefixPhone }
            .distinctUntilChanged()
            .map { [weak self] prefix in
                self?.impersonationView!.prefixNumberLabel.text = prefix
            }
            .delay(.milliseconds(5), scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.impersonationView!.prefixNumberView.addBottomBorderWithColor(color: R.color.primary()!, width: 2.0)
            })
            .subscribe()
            .disposed(by: disposeBag)

        reactor.state.map { $0.impersonationState.suffixPhone }
            .bind(to: impersonationView!.suffixNumberLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.impersonationState.isImpersonateLoading }
            .bind(to: impersonationView!.impersonationButton.rx.loading)
            .disposed(by: disposeBag)

        reactor.state.map { $0.fullPhoneNumber }
            .map { R.string.localizable.loginCodeScreenInfo_IOS($0) }
            .bind(to: enterCodeView!.codeInfoLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.enterCodeState.authCode }
            .bind(to: enterCodeView!.rx.code)
            .disposed(by: disposeBag)

        reactor.state.map { $0.enterCodeState.authCodeIsLoading }
            .bind(to: enterCodeView!.loginButton.rx.loading)
            .disposed(by: disposeBag)

        reactor.state.map { $0.enterCodeState.resendCodeIsLoading }
            .subscribe(onNext: { [weak self] isPhoneLoading in
                isPhoneLoading ? self?.enterCodeView!.loadingIndicator.startAnimating() : self?.enterCodeView!.loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.enterCodeState.authCodeIsLoginButtonEnabled }
            .bind(to: enterCodeView!.loginButton.rx.enable)
            .disposed(by: disposeBag)

        reactor.state.map { $0.enterCodeState.authCodeError }
            .bind(onNext: { [weak self] errorMessage in
                self?.enterCodeView!.errorLabel.text = errorMessage
                if errorMessage == R.string.localizable.loginErrorsInvalid_account_error_IOS(R.string.localizable.loginErrorsInvalid_account_target_error()) {
                    self?.targetText = R.string.localizable.loginErrorsInvalid_account_target_error()
                    self?.setupAttributedString()
                }
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isLoading in
                self?.customKeyboard.isEnabled = !isLoading
                self?.enterCodeView?.resendCodeLabel.isEnabled = !isLoading
                self?.enterCodeView?.resendCodeLabel.isUserInteractionEnabled = !isLoading
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.page }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] page in
                switch page {
                case .welcome:
                    self?.navigationController?.popViewController(animated: true)
                    break
                default:
                    self?.slide(to: page)
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    private func setupAttributedString() {
        enterCodeView!.errorLabel.linkAttributedString(text: R.string.localizable.loginErrorsInvalid_account_error_IOS(R.string.localizable.loginErrorsInvalid_account_target_error()), defaultColor: R.color.orange()!, colorTarget: R.color.white()!, textTarget: targetText)

        enterCodeView!.errorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:))))
    }

    @objc func tapLabel(gesture _: UITapGestureRecognizer) {
        callNumber()
    }

    private func callNumber() {
        if let url = URL(string: "telprompt://\(R.string.localizable.loginErrorssupportNumber())") {
            UIApplication.shared.open(url)
        }
    }

    private func initWithPage(page: LoginPage) {
        guard let nibs = containedViews else { return }
        let child = nibs[page.rawValue]
        containerView.addSubview(child)
        child.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        child.frame = containerView.bounds
        currentPage = page
    }

    private func slide(to: LoginPage) {
        guard let views = containedViews else { return }
        guard let currentPage = currentPage, to != currentPage else { return }
        let toView = views[to.rawValue]
        let fromView = views[currentPage.rawValue]
        let scrollRight = to.rawValue > currentPage.rawValue
        let screenWidth = UIScreen.main.bounds.size.width
        let viewSize = fromView.frame

        fromView.superview?.addSubview(toView)

        toView.frame = CGRect(x: scrollRight ? screenWidth : -screenWidth, y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)

        UIView.animate(withDuration: 0.25, delay: TimeInterval(0.0), options: [.curveEaseOut, .preferredFramesPerSecond60], animations: {
            fromView.frame = CGRect(x: scrollRight ? -screenWidth : screenWidth, y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)
            toView.frame = CGRect(x: 0, y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)
        }) { _ in
            fromView.removeFromSuperview()
            self.currentPage = to
        }
    }
}

extension LoginViewController {
  class func instantiate(flowController: LoginFlowController) -> LoginViewController {
        let vc = R.storyboard.loginViewController.loginViewController()!
        let phoneView = EnterPhoneView.instanceFromNib()
        let codeView = EnterCodeView.instanceFromNib()
        let impersonationView = ImpersonationView.instanceFromNib()
        vc.enterPhoneView = phoneView
        vc.flowController = flowController
        vc.enterCodeView = codeView
        vc.impersonationView = impersonationView
        vc.containedViews = [phoneView, codeView, impersonationView]
        vc.reactor = Resolver.optional()
        return vc
    }
}
