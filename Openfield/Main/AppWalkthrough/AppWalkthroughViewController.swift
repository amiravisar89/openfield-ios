//
//  AppWalkthroughViewController.swift
//  Openfield
//
//  Created by Omer Cohen on 2/23/20.
//  Copyright © 2020 Prospera. All rights reserved.
//

import FirebaseAnalytics
import FSPagerView
import ReactorKit
import RxCocoa
import RxSwift
import SwiftyUserDefaults
import UIKit

protocol AppWalkthroughViewControllerDelegate: AnyObject {
    func AppWalkthroughViewControllerDismissed()
}

class AppWalkthroughViewController: UIViewController, StoryboardView, HasContractPopup {
    weak var flowController: MainFlowController!
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var contentView: UIView!

    typealias Reactor = AppWalkthroughViewReactor

    var disposeBag: DisposeBag = .init()

    weak var delegate: AppWalkthroughViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPagerView()
        setupView()
        setupPageControl()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Analytics
        let screenViewParams = [AnalyticsParameterScreenName: ScreenName.introCarousel, AnalyticsParameterScreenClass: String(describing: AppWalkthroughViewController.self), EventParamKey.category: EventCategory.carousel]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        flowController.setStatusBarStyle(style: .lightContent)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        flowController.setStatusBarStyle(style: .darkContent)
    }

    private func setupView() {
        setupColors()
    }

    private func setupColors() {
        contentView.backgroundColor = R.color.screenBg()!
    }

    private func setupPagerView() {
        pagerView.register(UINib(resource: R.nib.appWalkthroughCell), forCellWithReuseIdentifier: R.reuseIdentifier.appWalkthroughCell.identifier)
    }

    private func setupPageControl() {
        pageControl.setStrokeColor(R.color.valleyBrand(), for: .normal)
        pageControl.setStrokeColor(R.color.valleyBrand(), for: .selected)
        pageControl.setFillColor(R.color.valleyBrand(), for: .selected)
        pageControl.contentHorizontalAlignment = .center
    }

    func navigateToContractScreen(contractVersion: Double, contract: Contract) {
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.contract, .navigateToContract, [EventParamKey.contractType: contract.type.rawValue,
                                                                                                                 EventParamKey.contractVersion: String(contractVersion)]))
        showContractPopUp(cornerRadius: 8, contract: contract, style: .formSheet)
    }

    func bind(reactor: AppWalkthroughViewReactor) {
        pagerView.rx.willEndDragging
            .bind { [weak self] index in self?.pageControl.currentPage = index }
            .disposed(by: disposeBag)

        pagerView.rx.willEndDragging.observeOn(MainScheduler.instance)
            .subscribe { [weak self] index in
                guard let self = self,
                      let index = index.element else { return }
                let direction: String = index > self.pageControl.currentPage ? "right" : "left"
                EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.introCarousel, .carouselMove, [EventParamKey.direction: direction]))
                EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.introCarousel, .carouselItemShown, [EventParamKey.carouselItem: "\(index + 1)"]))
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.layerCarousel }.bind(to: pagerView.rx.items) { [weak self] pagerView, index, layerElement in
            guard let self = self else { return FSPagerViewCell() }
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.appWalkthroughCell.identifier, at: index) as! AppWalkthroughCell
            let nextIndex = index + 1
            cell.setAppWalkthroughCell(appWalkthroughCellInput: layerElement, index: index)

            cell.button.rx.tapGesture().when(.recognized).observeOn(MainScheduler.instance)
                .do(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    guard self.pageControl.numberOfPages > nextIndex else { return }
                    self.pageControl.currentPage = nextIndex
                    self.pagerView.scrollToItem(at: nextIndex, animated: true)
                    self.pagerView.isUserInteractionEnabled = false
                })
                .map { [unowned self ] _ in Reactor.Action.setCarouselIndex(index: nextIndex, navigation: self.dismissNavigation) }
                .bind(to: reactor.action)
                .disposed(by: cell.disposeBag)

            cell.contractSelected.observeOn(MainScheduler.instance)
                .map { [weak self] contract in
                  guard let self = self else {return .nothing}
                  return Reactor.Action.goToContract(type: contract, navigation: self.navigateToContractScreen) }
                .bind(to: reactor.action).disposed(by: cell.disposeBag)

            cell.signToggle.isSelected
                .map { Reactor.Action.setIsContractSigned(isSigned: $0) }
                .bind(to: reactor.action)
                .disposed(by: cell.disposeBag)

            cell.emptyBtn.rx.tapGesture().when(.recognized)
                .map { _ in Reactor.Action.showError }
                .bind(to: reactor.action)
                .disposed(by: cell.disposeBag)

            return cell
        }.disposed(by: disposeBag)

        reactor.state.map { $0.layerCarousel.count }
            .bind { [weak self] count in self?.pageControl.numberOfPages = count }
            .disposed(by: disposeBag)
      
      
      pagerView.rx.didEndScrollAnimation
        .bind { [weak self] index in self?.pagerView.isUserInteractionEnabled = true }
          .disposed(by: disposeBag)

        reactor.state.map { $0.isContractSigned }.observeOn(MainScheduler.instance)
        .subscribe { [weak self] isContractSigned in
            guard let self = self,
                  let isContractSigned = isContractSigned.element else { return }
            self.pagerView.isScrollEnabled = isContractSigned
        }.disposed(by: disposeBag)
    }

    private func dismissNavigation() {
        navigationController?.popViewController(animated: true)
        delegate?.AppWalkthroughViewControllerDismissed()
    }
}

extension AppWalkthroughViewController {
    class func instantiate(reactor: AppWalkthroughViewReactor, flowController: MainFlowController) -> AppWalkthroughViewController {
        let vc = R.storyboard.appWalkthroughViewController.appWalkthroughViewController()!
        vc.reactor = reactor
        vc.flowController = flowController
        return vc
    }
}

