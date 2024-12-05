//
//  AnalysisViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 16/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import PullUpController
import ReactorKit
import Resolver
import RxGesture
import RxSwift
import UIKit

protocol AnalysisViewControllerDelegate: AnyObject {
    func compareClick()
    func scrollViewDidScroll(scrollView: UIScrollView)
    func scrollViewDidTapZoom(scrollView: UIScrollView, toRect: CGRect)
}

final class AnalysisViewController: UIViewController, StoryboardView {
    @IBOutlet private var analysisTabs: AnalysisTabs!
    @IBOutlet var fieldImage: FieldImageView!
    @IBOutlet var viewBackground: UIView!
    private weak var datesDrawerViewController: DatesFilterViewController?
    private weak var layersDrawerViewController: LayerFilterViewController?
    private weak var insightsDrawerViewController: AnalysisInsightsViewController?

    @IBOutlet var anlysisTabHeightConstraint: NSLayoutConstraint!
    weak var delegate: AnalysisViewControllerDelegate?
    var disposeBag: DisposeBag = .init()

    typealias Reactor = AnalysisReactor
    var isCompareMode: Bool = false
    var isDrawerVisible = false
    let dateProvider: DateProvider = Resolver.resolve()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        analysisTabs.addShadow(top: true)
        fieldImage.delegate = self
        generateAccessibilityIdentifiers()
        setupDrawers()
    }

    // MARK: - Compare UI

    func toggleCompare(isCompare: Bool, isMain _: Bool) {
        isCompareMode = isCompare
        fieldImage.resetZoom()
        analysisTabs.toggleCompare(isCompare: isCompareMode)
        anlysisTabHeightConstraint.constant = isCompareMode ? 45 : 105
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        fieldImage.handleCompare(isCompare: isCompare)
        fieldImage.removeAllTagsLayers()
        hideDrawers()
        isDrawerVisible = false

        guard let reactor = reactor else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.fieldImage.removeAllTagsLayers()
            self?.setFieldImageViewUI(state: reactor.currentState, isCompare: self?.isCompareMode ?? false)
            self?.showTagsWith(insightsArray: reactor.currentState.insights)
        }
    }

    func hideDrawers() {
        layersDrawerViewController?.hideMySelf()
        datesDrawerViewController?.hideMySelf()
        insightsDrawerViewController?.hideMySelf()
    }

    func handleLegend(isCompare _: Bool) {}

    private func setupStaticColor() {
        viewBackground.backgroundColor = R.color.screenBg()!
    }

    private func setupInisghtsDrawer(insightsCount: Int) {
        insightsDrawerViewController = AnalysisInsightsViewController.instantiate(with: reactor)
        insightsDrawerViewController!.insightsCount = Double(insightsCount)

        setupChild(vc: insightsDrawerViewController!, at:
            CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: DatesFilterViewController.viewSize.height))

        insightsDrawerViewController?.closeBtn.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.isDrawerVisible = false
            })
            .disposed(by: disposeBag)
    }

    private func setupDrawers() {
        layersDrawerViewController = LayerFilterViewController.instantiate(with: reactor)
        setupChild(vc: layersDrawerViewController!, at:
            CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: LayerFilterViewController.viewSize.height))
        datesDrawerViewController = DatesFilterViewController.instantiate(with: reactor)
        setupChild(vc: datesDrawerViewController!, at:
            CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: DatesFilterViewController.viewSize.height))

        // Drawers Actions
        layersDrawerViewController?.closeBtn.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.isDrawerVisible = false
            })
            .disposed(by: disposeBag)

        datesDrawerViewController?.closeBtn.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.isDrawerVisible = false
            })
            .disposed(by: disposeBag)
    }

    private func setupChild(vc: UIViewController, at rect: CGRect) {
        view.addSubview(vc.view)
        vc.view.frame = rect
        addChild(vc)
        vc.didMove(toParent: self)
    }

    private func showLayersSelection() {
        guard isDrawerVisible == false else {
            return
        }
        isDrawerVisible = true
        UIView.animate(withDuration: 0.2) {
            self.layersDrawerViewController?.view.frame.origin.y = self.view.frame.height - LayerFilterViewController.viewSize.height
        }
    }

    private func showDateSelection() {
        guard isDrawerVisible == false else {
            return
        }
        isDrawerVisible = true
        UIView.animate(withDuration: 0.2) {
            self.datesDrawerViewController?.view.frame.origin.y = self.view.frame.height - DatesFilterViewController.viewSize.height
        }
    }

    private func showInsightSlection(insightsCount _: Int) {
        guard isDrawerVisible == false else {
            return
        }
        isDrawerVisible = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.insightsDrawerViewController?.view.frame.origin.y = self.view.frame.height - self.insightsDrawerViewController!.viewSize.height
        }
    }

    private func closeScreen() {
        navigationController?.popViewController(animated: true)
    }

    func bind(reactor: AnalysisReactor) {
        fieldImage.legendInfoView.rx.tapGesture().when(.recognized).observeOn(MainScheduler.instance).subscribe { [weak self] _ in
            guard let self = self else { return }
            guard let type = self.fieldImage.typeImage, let sourceType = self.fieldImage.sourceTypeImage else { return }
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.imageViewer, .imageLegendClicked, [EventParamKey.imageId: self.fieldImage.analyticsImageId, EventParamKey.imageLayer: type.rawValue]))
            let vc = LayerGuideViewController.instantiate()
            vc.imageType = type
            vc.imageSourceType = sourceType
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)

        // Action
        fieldImage.singleTap
            .subscribe { [weak self] _ in
                self?.isDrawerVisible = false
                self?.hideDrawers()
            }
            .disposed(by: disposeBag)

        layersDrawerViewController?.closeBtn.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.isDrawerVisible = false
            })
            .disposed(by: disposeBag)
        analysisTabs
            .rx
            .tapLayers
            .map { [weak self] _ in Reactor.Action.tappedLayers(navigationEffect: self?.showLayersSelection) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        analysisTabs
            .rx
            .tapDate
            .map { [weak self] _ in Reactor.Action.tappedDate(navigationEffect: self?.showDateSelection) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        analysisTabs
            .rx
            .tapInsights
            .map { [weak self] _ in Reactor.Action.tappedInsights(navigationEffect: self?.showInsightSlection) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State
        reactor.state
            .filter { state -> Bool in !state.isWrapperEmpty }
            .compactMap { $0.currentLayer }
            .map { $0.imageType.name() }
            .bind(to: analysisTabs.rx.layer)
            .disposed(by: disposeBag)

        Observable.combineLatest(reactor.state.filter { state -> Bool in !state.isWrapperEmpty }
            .compactMap { $0.currentDate }, reactor.state.compactMap { $0.field })
            .compactMap { [weak self] currentDate, field in
                guard let self = self else { return nil }
                return self.dateProvider.format(date: currentDate.date, region: field.region, format: .short)
            }
            .bind(to: analysisTabs.rx.date).disposed(by: disposeBag)

        reactor.state
            .filter { state -> Bool in !state.isWrapperEmpty }
            .map { $0.currentInsights }
            .bind(to: analysisTabs.rx.insights)
            .disposed(by: disposeBag)

        reactor.state
            .filter { state -> Bool in !state.isWrapperEmpty }.map { $0.selectedInsightsCount }.distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.fieldImage.showAllTags(show: true)
            })
            .disposed(by: disposeBag)

        reactor.state
            .filter { state -> Bool in !state.isWrapperEmpty }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.fieldImage.removeAllTagsLayers()
                self.setFieldImageViewUI(state: reactor.currentState, isCompare: self.isCompareMode)
            })
            .disposed(by: disposeBag)

        reactor.state
            .filter { state -> Bool in !state.isWrapperEmpty }
            .map { $0.insights }
            .subscribe(onNext: { [weak self] insights in
                guard let self = self else { return }
                self.showTagsWith(insightsArray: insights)
            })
            .disposed(by: disposeBag)

        reactor.state
            .filter { state -> Bool in !state.isWrapperEmpty }
            .map { $0.insights }
            .distinctUntilChanged()
            .take(1)
            .subscribe(onNext: { [weak self] insights in
                guard let self = self else { return }
                // happen here because we need insights count
                self.setupInisghtsDrawer(insightsCount: insights.count)
            })
            .disposed(by: disposeBag)
    }

    func showTagsWith(insightsArray: [IrrigationInsight]) {
        for insight in insightsArray {
            if insight.isSelected {
                fieldImage.showTag(id: insight.tag.id, data: insight.tag.tag, color: .white)
            } else {
                fieldImage.hideTag(id: insight.tag.id)
            }
        }
    }

    func setFieldImageViewUI(state: AnalysisReactor.State, isCompare _: Bool) {
        guard state.isWrapperEmpty == false else {
            return
        }
        fieldImage.toggleImageTypeLabel(show: true)
        fieldImage.moveCloudbutton()
        fieldImage.setConstraints(margin: 0)
        let lowResolutionImg = state.currentImages[0].url
        let highResolutionImg = state.currentImages[1].url
        let type = state.currentLayer.imageType
        let bounds = state.currentBounds
        let issue = state.currentIssue
        let sourceType = state.currentDate.sourceType
        fieldImage.display(image: (lowResolutionImg, highResolutionImg), imageId: state.currentImages[0].imageId, bounds: bounds, type: type, issue: issue, sourceType: sourceType)
    }

    @IBAction func compareAction(_: Any) {
        delegate?.compareClick()
    }
}

extension AnalysisViewController: FieldImageViewDelegate {
    func scrollViewDidTapZoom(scrollView: UIScrollView, toRect: CGRect) {
        delegate?.scrollViewDidTapZoom(scrollView: scrollView, toRect: toRect)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView: scrollView)
    }
}

extension AnalysisViewController {
    class func instantiate(with reactor: AnalysisReactor) -> AnalysisViewController {
        let vc = R.storyboard.analysisViewController.analysisViewController()!
        vc.reactor = reactor

        return vc
    }
}
