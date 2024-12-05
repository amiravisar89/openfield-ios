//
//  InsightViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 15/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import GEOSwift
import Kingfisher
import KingfisherWebP
import PullUpController
import ReactorKit
import Resolver
import RxKingfisher
import RxSwift
import STPopup
import UIKit

final class InsightViewController: UIViewController, StoryboardView {
    var disposeBag: DisposeBag = .init()
    private var toolTipManager = ToolTipManager()
    typealias Reactor = InsightViewReactor

    @IBOutlet var fieldImageBottom: NSLayoutConstraint!
    @IBOutlet var fieldImage: FieldImageView!
    @IBOutlet var backButton: SGButton!
    @IBOutlet var endViewMarker: UIView!
    @IBOutlet var backButtonHeaderBottomLine: UIView!
    @IBOutlet var backButtonHeaderBackground: UIView!
    @IBOutlet var viewBackground: UIView!
    weak var flowController: MainFlowController!
    private weak var drawer: InsightDrawerViewController?
    lazy var drawerMaxHeight: CGFloat = UIScreen.main.bounds.height - self.backButton.frame.height - self.backButton.frame.minY

    func navigateBack() {
      flowController.pop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fieldImage.delegate = self
        setupStaticColor()
        setStatusBarColor(color: .clear)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PerformanceManager.shared.stopTrace(for: .insight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        flowController.setStatusBarStyle(style: .lightContent)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        flowController.setStatusBarStyle(style: .darkContent)
    }

    private var backButtonBorderColor: UIColor {
        backButton.defaultButtonStyle.borderColor
    }

    private func setupStaticColor() {
        viewBackground.backgroundColor = R.color.screenBg()!
    }

    func bind(reactor: InsightViewReactor) {

        fieldImage.legendInfoView.rx.tapGesture().when(.recognized).observeOn(MainScheduler.instance).subscribe { [weak self] _ in
            guard let self = self else { return }
            guard let type = self.fieldImage.typeImage, let sourceType = self.fieldImage.sourceTypeImage else { return }
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.imageViewer, .imageLegendClicked, [EventParamKey.imageId: self.fieldImage.analyticsImageId, EventParamKey.imageLayer: type.rawValue]))
            let vc = LayerGuideViewController.instantiate()
            vc.imageType = type
            vc.imageSourceType = sourceType
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)

        backButton
            .rx
            .tapGesture()
            .when(.recognized)
            .compactMap { [weak self] _ in
                guard let self = self else { return nil }
                return Reactor.Action.clickBack(navigationEffect: self.navigateBack, showFeedbackDialog: self.showFeedbackWalkthroughPopup)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        let layoutObs = rx.viewDidAppear

        let insightObs = reactor.state
            .compactMap { $0.insight }

        let showDrawerTooltipObs = reactor.state
            .map { $0.showDrawerTooltip }

        Observable.zip(reactor.state.compactMap{$0.user}, insightObs) { user, insight -> (User, IrrigationInsight) in (user, insight) }
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] user, insight in
                guard let self = self else { return }
                if user.tracking.tsSawComparePopup == nil, insight.uid != WelcomeInsightsIds.irrigation.rawValue {
                    self.showComparePopUp()
                }
            })
            .disposed(by: disposeBag)

        Observable.zip(layoutObs, insightObs, showDrawerTooltipObs) { _, _, showDrawerTooltip -> Bool in showDrawerTooltip }
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] showDrawerTooltip in
                guard let self = self else { return }
                self.showDrawer(withTooltip: showDrawerTooltip) // TODO-Daniel: To work smoothly this requires waiting for viewDidAppear()
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.insight }
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] insight in
                guard let self = self else { return }
                guard let mainImage = insight.mainImage else { return }
                self.fieldImage.display(image: (mainImage.previews[0].url,
                                                mainImage.previews[1].url),
                                        imageId: mainImage.id,
                                        bounds: mainImage.bounds,
                                        type: mainImage.type,
                                        issue: mainImage.issue,
                                        sourceType: mainImage.sourceType)

                self.fieldImage.showTag(id: insight.tag.id, data: insight.tag.tag, color: .white)
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.insight }
            .take(1)
            .subscribe(onNext: { [weak self] insight in
                guard let self = self else { return }
                self.generateAccessibilityIdentifiers(id: insight.uid)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.showBackButtonHeader }
            .subscribe(onNext: { [weak self] isAnimated in
                guard let self = self else { return }
                self.animateLineAndBackground(toVisible: isAnimated)
            })
            .disposed(by: disposeBag)
        Observable.combineLatest(rx.viewDidAppear, reactor.state
            .compactMap { $0.insight }.distinctUntilChanged()).map { _ in Reactor.Action.reportScreenView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func showDrawer(withTooltip: Bool) {
        guard drawer == nil,
              let drawerHeight = fieldImageBottom?.constant else { return }
        let drawerVC = InsightDrawerViewController.instantiate(with: reactor, flowController: flowController)
        addPullUpController(drawerVC, initialStickyPointOffset: drawerHeight, animated: true)
        drawer = drawerVC
        if withTooltip {
            Observable.just(())
                .map { _ in Reactor.Action.shownCardTooltip }
                .bind(to: reactor!.action)
                .disposed(by: disposeBag)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                guard let self = self else { return }
                self.toolTipManager.openTipView(text: R.string.localizable.insightOpenCardTooltip(), forView: drawerVC.view, superView: self.view)
            }
        }
    }

    private func animateLineAndBackground(toVisible: Bool) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            self.backButtonHeaderBottomLine.backgroundColor = toVisible ? R.color.lightGrey() : .clear
            self.backButtonHeaderBackground.isHidden = !toVisible

            self.backButton.defaultButtonStyle.borderColor = toVisible ? .clear : self.backButtonBorderColor
            self.backButton.setupView()
        }, completion: nil)
    }

    private func showFeedbackWalkthroughPopup() {
        let vc = WalkThrughPopUpViewController.instantiate()
        vc.delegate = self
        navigationController?.present(vc, animated: true, completion: nil)
    }

    private func showComparePopUp() {
        let vc = ComparePopUpViewController.instantiate()
        navigationController?.present(vc, animated: true, completion: nil)
        Observable.just(())
            .map { _ in Reactor.Action.shownComparePopUp }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
}

extension InsightViewController {
    class func instantiate(insightUid: String, origin: NavigationOrigin, flowController: MainFlowController!) -> InsightViewController {
        let vc = R.storyboard.insightViewController.insightViewController()!
        let reactor: InsightViewReactor = Resolver.resolve(args: [insightUid, origin.rawValue])
        vc.reactor = reactor
        vc.flowController = flowController
        return vc
    }
}

extension InsightViewController: WalkThrughPopUpViewControllerDelegate {
    func positiveClicked() {
        drawer?.openDrawer()
        drawer?.scrollUpDrawerContent()
    }

    func negativeClicked() {}
}

extension InsightViewController: FieldImageViewDelegate {
    func scrollViewDidScroll(scrollView _: UIScrollView) {}
    func scrollViewDidTapZoom(scrollView _: UIScrollView, toRect _: CGRect) {}
}

extension InsightViewController: MaxDrawerHeightProvider {
    var maxDrawerHeight: CGFloat {
        drawerMaxHeight
    }

    public func drawerHeight(contentHeight: CGFloat) -> CGFloat {
        let backButtonRestriction = UIScreen.main.bounds.height - backButton.originOnWindow.y - backButton.bounds.height

        let contentHeightRestriction = contentHeight + backButton.frame.minY - UIDevice.current.topNotchHeight

        return min(backButtonRestriction, contentHeightRestriction)
    }
}
