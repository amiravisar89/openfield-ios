//
//  InsightDrawerViewController.swift
//  OpenInsightDrawer
//
//  Created by Daniel Kochavi on 16/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Cosmos
import PullUpController
import ReactorKit
import Resolver
import RxCocoa
import RxDataSources
import RxSwift
import RxViewController
import STPopup
import UIKit

final class InsightDrawerViewController: PullUpController, StoryboardView, ViewControllerMeasureDelegate, ShareableVC, hasFeedBackView {
    typealias Reactor = InsightViewReactor
    var disposeBag = DisposeBag()
    var measuredHeight: CGFloat = 0
    let drawerCornerRadius: CGFloat = 20

    public static var maxHeight = UIScreen.main.bounds.height

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var farmName: UILabel!
    @IBOutlet var fieldName: UILabel!
    @IBOutlet var insightSubject: UILabel!
    @IBOutlet var affectedAreaLabel: UILabel!
    @IBOutlet var affectedAreaValue: UILabel!
    @IBOutlet var imageTakenValue: UILabel!
    @IBOutlet var imageTakenLabel: UILabel!
    @IBOutlet var descriptionValue: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var thanksForFeedbak: UILabel!
    @IBOutlet var analyzeButton: SGButton!
    @IBOutlet var shareButton: SGButton!
    @IBOutlet var topShareButton: SGButton!
    @IBOutlet var markAsUnreadButton: SGButton!
    @IBOutlet var valleyButton: SGButton!
    @IBOutlet var feedbackStarsView: CosmosView!
    @IBOutlet var starsLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var fakeShare: ShareButton!
    @IBOutlet var fakeFieldName: ClearButton!
    @IBOutlet var fakeAnalayze: ClearButton!
    @IBOutlet var actionButtonsContainer: UIStackView!
    @IBOutlet var takeActionLabel: UILabel!
    @IBOutlet var bottomPartConstraint: NSLayoutConstraint!
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var secondTopSeparator: UIView!
    @IBOutlet var feedbackView: UIView!
    private var toolTipManager = ToolTipManager()
    @IBOutlet var topSeparator: UIView!
    @IBOutlet var feedbacktitleLabel: BodyRegularPrimary!

    let starsSubject = PublishSubject<Int>()
    let drawerAtMaxHeight = PublishSubject<Bool>()
    let dateProvider: DateProvider = Resolver.resolve()
    weak var flowController: MainFlowController!

    let feedbackPopupHeight: CGFloat = 350
    let feedbackPopupCornerRadius: CGFloat = 2

    var starsMargin: CGFloat {
        return starsLeadingConstraint.constant
    }

    lazy var drawerMaxHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.attach(to: self)
        setupStaticContent()
        setupDrawerAppearance()
        setupStars()
        setupViews()
        setupStaticColor()
    }

    private func setupStaticColor() {
        viewBackground.backgroundColor = R.color.white()
        scrollView.backgroundColor = R.color.screenBg()!
        topSeparator.backgroundColor = R.color.lightGrey()
        secondTopSeparator.backgroundColor = R.color.lightGrey()
        feedbackView.backgroundColor = R.color.screenBg()!
        fakeShare.highlightedButtonStyle?.bgColor = .clear
        fakeFieldName.highlightedButtonStyle?.bgColor = .clear
        fakeAnalayze.highlightedButtonStyle?.bgColor = .clear
    }

    private func setupViews() {
        feedbackStarsView.didFinishTouchingCosmos = { [weak self] rating in
            self?.starsSubject.onNext(Int(rating))
        }
        thanksForFeedbak.alpha = 0
    }

    @IBAction private func clickedDrawer(_: Any) {
        openDrawer()
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.insightCard,
                                                                   .insightCardOpen, [EventParamKey.action: "click"]))
    }

    private func setupStars() {
        let screenWidth = UIScreen.main.bounds.width - 2 * starsMargin
        let starWidth = CGFloat(feedbackStarsView.settings.starSize)
        let starCount = feedbackStarsView.settings.totalStars
        let marginSize = (screenWidth - (starWidth * CGFloat(starCount))) / CGFloat(starCount - 1)
        feedbackStarsView.settings.starMargin = Double(marginSize)
    }

    private func setupDrawerAppearance() {
        view.clipsToBounds = true
        scrollView.bounces = false
        showCorners(show: true)
        takeActionLabel.text = R.string.localizable.insightTakeAction()
        feedbacktitleLabel.text = R.string.localizable.insightWasUseful()
    }

    private func showCorners(show: Bool) {
        let radius = show ? drawerCornerRadius : 0
        if #available(iOS 11.0, *) {
            view.layer.cornerRadius = radius
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            let path = UIBezierPath(roundedRect: view.bounds,
                                    byRoundingCorners: [.topRight, .topLeft],
                                    cornerRadii: CGSize(width: radius, height: radius))

            let maskLayer = CAShapeLayer()

            maskLayer.path = path.cgPath
            view.layer.mask = maskLayer
        }
    }

    func backNavigation() {
        navigationController?.popViewController(animated: true)
    }

    private func showThankYou() {
        if thanksForFeedbak.alpha == 0 {
            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let self = self else { return }
                self.thanksForFeedbak.alpha = 1
            }
        }
    }

    // This method is called after the pull up controller's view move to a point.
    override func pullUpControllerDidMove(to point: CGFloat) {
        calculateDrawerMaxHeight(to: point, isDrag: false)
        if point == pullUpControllerAllStickyPoints[0] {
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.insightCard, .insightCardClose))
        }
    }

    // This method is called after the pull up controller's view is dragged to a point.
    override func pullUpControllerDidDrag(to point: CGFloat) {
        calculateDrawerMaxHeight(to: point, isDrag: true)
    }

    private func calculateDrawerMaxHeight(to point: CGFloat, isDrag: Bool) {
        let isdrawerAtMaxHeight = point == drawerMaxHeight && (parent as? MaxDrawerHeightProvider)?.maxDrawerHeight ?? 0 == drawerMaxHeight
        drawerAtMaxHeight.onNext(isdrawerAtMaxHeight)
        showCorners(show: !isdrawerAtMaxHeight)
        topSeparator.isHidden = isdrawerAtMaxHeight
        if isdrawerAtMaxHeight, isDrag {
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.insightCard, .insightCardOpen, [EventParamKey.action: "drag"]))
        }
    }

    private func hideWelcomeViews(hide: Bool) {
        fakeFieldName.isHidden = hide
        fakeShare.isHidden = hide
        fakeAnalayze.isHidden = hide
    }

    func bind(reactor: InsightViewReactor) {
        reactor.state
            .compactMap { $0.insight }
            .take(1)
            .subscribe(onNext: { [weak self] insight in
                guard let self = self else { return }
                self.generateAccessibilityIdentifiers(id: insight.uid)
            })
            .disposed(by: disposeBag)

        shareButton.rx.tapGesture()
            .when(.recognized)
            .compactMap { [weak self] _ in
                guard let self = self else { return nil }
                return Reactor.Action.shareInsight(shareEffect: self.share, view: self.shareButton)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        topShareButton.rx.tapGesture()
            .when(.recognized)
            .compactMap { [weak self] _ in
                guard let self = self else { return nil }
                return Reactor.Action.shareInsight(shareEffect: self.share, view: self.topShareButton)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        drawerAtMaxHeight
            .distinctUntilChanged()
            .map { isAnimated in Reactor.Action.drawerReachedMaxHeight(atMax: isAnimated) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        markAsUnreadButton.rx.tapGesture()
            .when(.recognized)
            .compactMap { [weak self] _ in
                guard let self = self else { return nil }
                return Reactor.Action.markInsightAsUnread(navigationEffect: self.backNavigation)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        analyzeButton.rx.tapGesture()
            .when(.recognized)
            .compactMap { [weak self] _ in
                guard let self = self else { return nil }
                return Reactor.Action.clickedAnalyze(navigationEffect: self.navigateToAnalyze)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        starsSubject
            .compactMap { [weak self] rating in
                guard let self = self else { return nil }
                return Reactor.Action.selectedRating(rating: rating, navigationEffect: self.displayFeedback, uiEffect: self.showThankYou)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        fieldName.rx.tapGesture()
            .when(.recognized)
            .compactMap { [weak self] _ in
                guard let self = self else { return nil }
                return Reactor.Action.clickedField(navigationEffect: self.navigateToField(field:))
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap{$0.insight}
            .map { $0.subject }
            .bind(to: insightSubject.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.insight }
            .map { $0.farmName }
            .subscribe(onNext: { [weak self] farmName in
                if farmName.isEmpty { self?.farmName.isHidden = true }
                else { self?.farmName.text = "\(farmName) /" }
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap{$0.insight}
            .map { $0.fieldName.capitalize() }
            .bind(to: fieldName.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.insight }
            .map { (number: $0.affectedArea, unit: $0.affectedAreaUnit) }
            .map { String(format: "%.2f \($0.unit)", $0.number) }
            .bind(to: affectedAreaValue.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.insight }
            .compactMap { [weak self] insight in
                guard let self = self else { return nil }
                return self.dateProvider.format(date: insight.imageDate, region: insight.dateRegion, format: .shortHourTimeZone)
            }
            .bind(to: imageTakenValue.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap{$0.insight}
            .map { $0.description }
            .bind(to: descriptionValue.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.insight?.feedback.rating }
            .subscribe(onNext: { [weak self] rating in
                self?.feedbackStarsView.rating = Double(rating)
                self?.showThankYou()
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isWelcomeInsight}
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isWelcome in
                self?.hideWelcomeViews(hide: !isWelcome)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isFieldOwner}
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isFieldOwner in
                self?.fieldName.textColor = isFieldOwner ? R.color.valleyBrand() : R.color.primary()
                self?.fieldName.isUserInteractionEnabled = isFieldOwner
            })
            .disposed(by: disposeBag)
        

      Observable.combineLatest(reactor.state.compactMap{$0.insight}, reactor.state.map{$0.isWelcomeInsight}, reactor.state.map{$0.isFieldOwner}).subscribe(onNext: { [weak self] (insight, isWelcomeInsight, isFieldOwner) in
            if !isFieldOwner, !isWelcomeInsight {
                self?.noFieldPermissionUI()
            }
        }).disposed(by: disposeBag)
    }

    private func setupStaticContent() {
        affectedAreaLabel.text = R.string.localizable.insightAffectedArea()
        imageTakenLabel.text = R.string.localizable.insightImageTaken()
        descriptionLabel.text = R.string.localizable.insightDescription()
        analyzeButton.titleString = R.string.localizable.insightAnalyzeInsight()
        shareButton.titleString = R.string.localizable.share()
        markAsUnreadButton.titleString = R.string.localizable.insightMarkUnread()
        thanksForFeedbak.text = R.string.localizable.insightThanksFeedback()
    }

    private func noFieldPermissionUI() {
        actionButtonsContainer.isHidden = true
        analyzeButton.isHidden = true
        takeActionLabel.isHidden = true
        bottomPartConstraint.priority = UILayoutPriority(rawValue: 1000)
        topShareButton.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if drawerMaxHeight == 0 {
            updatePreferredFrameIfNeeded(animated: false)
        }
    }

    // MARK: Feedback

    func displayFeedback(feedback _: Feedback, reactor: InsightViewReactor) {
        let width = UIScreen.main.bounds.width
        showFeedBackPopup(size: CGSize(width: width, height: feedbackPopupHeight), cornerRadius: feedbackPopupCornerRadius, style: .bottomSheet, reactor: reactor)
    }

    @objc func backgroundViewDidTap() {
        presentedViewController?.dismiss(animated: true, completion: nil)
        EventTracker.track(event: AnalyticsEventFactory.buildDialogEvent(EventCategory.feedbackSheet, FeedbackViewController.analyticName, false, [EventParamKey.origin: "click_outside"]))
    }

    func navigateToAnalyze(field: Field, insight: IrrigationInsight, fieldInsights _: [IrrigationInsight]) {
        let vc = AnalysisHolderViewController.instantiate(with: AnalysisParams(fieldId: field.id, initialDate: insight.imageDate, initialLayer: insight.mainImage!.type, field: field, insight: insight, initialInsights: [insight], origin: "insight"))
        navigationController?.present(vc, animated: true)
    }

    func navigateToField(field: Field) {
        let vc = FieldViewController.instantiate(fieldId: field.id, categoriesUiMapper: Resolver.resolve(), fieldImageryUiMapper: Resolver.resolve(), fieldIrrigationUiMapper: Resolver.resolve(), fieldSeasonsListUiMapper: Resolver.resolve(), flowController: flowController, animationProvider: Resolver.resolve())
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: Pull Up Controller

    override var pullUpControllerPreferredSize: CGSize {
        drawerMaxHeight = getDrawerMaxHeight()

        return CGSize(width: UIScreen.main.bounds.width, height: drawerMaxHeight)
    }

    private func getDrawerMaxHeight() -> CGFloat {
        let contentHeight = scrollView.contentSize.height
        if let drawerMaxHeight = (parent as? MaxDrawerHeightProvider)?.drawerHeight(contentHeight: contentHeight) {
            return drawerMaxHeight
        } else {
            log.warning("Problem calculating drawer max height, setting default value")
            return 587
        }
    }

    // MARK: TipView

    @IBAction func clickedFakeShare(_: Any) {
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.insightCard, .toolTipShown, [EventParamKey.itemId: "welcome_share_tooltip"]))
        toolTipManager.openTipView(text: R.string.localizable.welcomeShareTip(), forView: shareButton, superView: view)
    }

    @IBAction func clickedFakeFieldName(_: Any) {
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.insightCard, .toolTipShown, [EventParamKey.itemId: "welcome_field_tooltip"]))
        toolTipManager.openTipView(text: R.string.localizable.welcomeFieldTip(), forView: fakeFieldName, superView: view)
    }

    @IBAction func clickedFakeAnalayze(_: Any) {
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.insightCard, .toolTipShown, [EventParamKey.itemId: "welcome_analyze_tooltip"]))
        toolTipManager.openTipView(text: R.string.localizable.welcomeAnalayzeTip(), forView: fakeAnalayze, superView: view)
    }

    @objc func openDrawer() {
        drawerMaxHeight = getDrawerMaxHeight()
        pullUpControllerMoveToVisiblePoint(drawerMaxHeight, animated: true, completion: nil)
    }

    func scrollUpDrawerContent() {
        let scrollOffset = scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom + UIDevice.current.bottomNotchHeight

        scrollView.setContentOffset(CGPoint(x: 0, y: scrollOffset), animated: true)
    }
}

extension InsightDrawerViewController {
    class func instantiate(with reactor: InsightViewReactor?, flowController: MainFlowController) -> InsightDrawerViewController {
        let vc = R.storyboard.insightDrawerViewController.insightDrawerViewController()!
        vc.reactor = reactor
        vc.flowController = flowController
        return vc
    }
}
