//
//  SignContractViewController.swift
//  Openfield
//
//  Created by amir avisar on 17/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import FirebaseAnalytics
import Foundation
import ReactorKit
import RxCocoa
import RxSwift
import STPopup
import SwiftyUserDefaults
import UIKit

class SignContractViewController: UIViewController, StoryboardView, HasContractPopup {
    typealias Reactor = SignContractViewReactor

    @IBOutlet var titleLabel: Title1Bold!
    @IBOutlet var touTextView: CaptionTextViewRegularSecondary!
    @IBOutlet var changesTextView: CaptionTextViewRegularSecondary!
    @IBOutlet var supportTextView: SubHeadlineTextViewRegularSecondary!
    @IBOutlet var acceptBtn: ButtonValleyBrandBoldWhite!

    weak var flowController: MainFlowController!
    var disposeBag: DisposeBag = .init()
    var contractProvider: TermsOfUseProviderProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStaticTexts()
        setupContractAttributedText()
        setupStaticColor()
        let screenViewParams = [AnalyticsParameterScreenName: ScreenName.signContract, AnalyticsParameterScreenClass: String(describing: SignContractViewController.self), EventParamKey.category: EventCategory.contract]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
        settingAccessibilityIds()
    }

    func setupStaticColor() {
        view.backgroundColor = R.color.screenBg()!
    }

    func setupStaticTexts() {
        titleLabel.text = R.string.localizable.contractUpdatedTouTitle()
        touTextView.text = R.string.localizable.contractUpdatedTou()
        changesTextView.text = R.string.localizable.contractTouChanges()
        supportTextView.text = R.string.localizable.contractUpdatedTouSupport()
        acceptBtn.titleString = R.string.localizable.contractAcceptBtn()
    }

    func setupContractAttributedText() {
        touTextView.textAlignment = .center
        changesTextView.textAlignment = .center
        touTextView.delegate = self
        changesTextView.delegate = self
        supportTextView.delegate = self

        let changesAttributes = [TextViewAttribute(text: R.string.localizable.contractChangesLinkablePart(),
                                                   color: R.color.valleyBrand()!,
                                                   type: ContractType.changes.rawValue, queryParam: URLParam.contractType.rawValue)]
        changesTextView.setAttributes(attributes: changesAttributes)

        let termsAttributes = [TextViewAttribute(text: R.string.localizable.contractTouLinkablePart(),
                                                 color: R.color.valleyBrand()!,
                                                 type: ContractType.terms.rawValue, queryParam: URLParam.contractType.rawValue),
                               TextViewAttribute(text: R.string.localizable.contractPpLinkablePart(),
                                                 color: R.color.valleyBrand()!,
                                                 type: ContractType.privacy.rawValue, queryParam: URLParam.contractType.rawValue)]
        touTextView.setAttributes(attributes: termsAttributes)

        let supportAttributes = [TextViewAttribute(text: R.string.localizable.contractSupportLinkablePart(),
                                                   color: R.color.valleyBrand()!,
                                                   type: ContractType.support.rawValue, queryParam: URLParam.contractType.rawValue)]

        supportTextView.setAttributes(attributes: supportAttributes)
    }

    func navigateToContractScreen(contractVersion: Double, contract: Contract) {
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.contract, .navigateToContract, [EventParamKey.contractType: contract.type.rawValue,
                                                                                                                 EventParamKey.contractVersion: String(contractVersion)]))
        showContractPopUp(cornerRadius: 8, contract: contract, style: .formSheet)
    }

    func navigateToSupport(url: URL) {
        UIApplication.shared.open(url)
    }

    func bind(reactor: SignContractViewReactor) {
        acceptBtn.rx.tapGesture().when(.recognized)
            .map { _ in Reactor.Action.signContract }
            .observeOn(MainScheduler.instance)
            .do(afterNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func settingAccessibilityIds() {
        titleLabel.accessibilityIdentifier = "title"
        touTextView.accessibilityIdentifier = "terms_label"
        changesTextView.accessibilityIdentifier = "changes_label"
        supportTextView.accessibilityIdentifier = "support_label"
        acceptBtn.accessibilityIdentifier = "button"
    }
}

extension SignContractViewController {
    class func instantiate(contractProvider: TermsOfUseProviderProtocol, flowController: MainFlowController, reactor: SignContractViewReactor) -> SignContractViewController {
        let vc = R.storyboard.signContractViewController.signContractViewController()!
        vc.reactor = reactor
        vc.contractProvider = contractProvider
        vc.flowController = flowController
        return vc
    }
}

extension SignContractViewController: UITextViewDelegate {
    func textView(_: UITextView, shouldInteractWith url: URL, in _: NSRange, interaction _: UITextItemInteraction) -> Bool {
        guard let reactor = reactor,
              let params = url.queryParameters,
              let contractType = params[URLParam.contractType.rawValue],
              let contract = ContractType(rawValue: contractType) else { return false }

        switch contract {
        case .support:
            Observable.just(Reactor.Action.goToSupport(navigation: navigateToSupport)).observeOn(MainScheduler.instance)
                .bind(to: reactor.action).disposed(by: disposeBag)
        default:
            Observable.just(Reactor.Action.goToContract(type: contract, navigation: navigateToContractScreen)).observeOn(MainScheduler.instance)
                .bind(to: reactor.action).disposed(by: disposeBag)
        }
        return false
    }
}
