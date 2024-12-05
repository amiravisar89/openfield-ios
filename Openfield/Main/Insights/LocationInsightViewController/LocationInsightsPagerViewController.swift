//
//  LocationInsightsPagerViewController.swift
//  Openfield
//
//  Created by Yoni Luz on 13/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import FSPagerView
import ReactorKit
import Resolver
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class LocationInsightsPagerViewController: UIViewController, StoryboardView, ShareableVC {
  @IBOutlet var locationInsightsPager: FSPagerView!
  @IBOutlet var backButton: UIButton!
  @IBOutlet var insightSubjectLabel: UILabel!
  @IBOutlet var fieldNameButton: UIButton!
  @IBOutlet var shareButton: UIButton!
  @IBOutlet var navigationPrev: UIButton!
  @IBOutlet var navigationNext: UIButton!
  @IBOutlet var dataLable: UILabel!

  private let dateProvider: DateProvider = Resolver.resolve()
  private var origin: NavigationOrigin?
  private weak var flowController: MainFlowController!

  var disposeBag = DisposeBag()
  typealias Reactor = LocationInsightsPagerReactor

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLocationInsightsPager()
    // header
    fieldNameButton.setTitleColor(R.color.valleyBrand(), for: .normal)
    fieldNameButton.setTitleColor(R.color.primary(), for: .disabled)
    navigationPrev.setImage(R.image.left_arrow_24pt(), for: .normal)
    navigationPrev.setImage(R.image.left_arrow_disabled_24pt(), for: .disabled)
    navigationNext.setImage(R.image.right_arrow_24pt(), for: .normal)
    navigationNext.setImage(R.image.right_arrow_disabled_24pt(), for: .disabled)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    flowController.setStatusBarStyle(style: .lightContent)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    flowController.setStatusBarStyle(style: .darkContent)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    PerformanceManager.shared.stopTrace(for: .location_insight)
  }

  private func navigateBack() {
    flowController.pop()
  }

  private func setupLocationInsightsPager() {
    locationInsightsPager.isScrollEnabled = false
    locationInsightsPager.isInfinite = false
    locationInsightsPager.register(UINib(resource: R.nib.locationInsightPage), forCellWithReuseIdentifier: R.reuseIdentifier.locationInsightPage.identifier)
  }

  func bind(reactor: LocationInsightsPagerReactor) {
    reactor.state
      .map { $0.showBadge }
      .distinctUntilChanged()
      .observeOn(MainScheduler.instance)
      .bind { [weak self] showBadge in
        if showBadge {
          self?.shareButton.addBadge(title: R.string.localizable.new(), position: CGPoint(x: 0, y: 0),
                                     fontSize: 12, cornerRadius: 4)
        } else {
          self?.shareButton.removeBadge()
        }
      }
      .disposed(by: disposeBag)

    reactor.state.map { $0.insights }
      .distinctUntilChanged().bind(to: locationInsightsPager.rx.items(cellIdentifier: R.reuseIdentifier.locationInsightPage.identifier, cellType: LocationInsightPage.self)) { _, item, cell in
        cell.bind(insight: item, origin: self.origin ?? .field, flowController: self.flowController)
      }.disposed(by: disposeBag)

    reactor.state
      .map { $0.isFieldOwner }
      .distinctUntilChanged()
      .observeOn(MainScheduler.instance)
      .bind { [weak self] isFieldOwner in self?.fieldNameButton.isEnabled = isFieldOwner }
      .disposed(by: disposeBag)

    reactor.state
      .compactMap { $0.currentLocationInsight }
      .observeOn(MainScheduler.instance)
      .distinctUntilChanged()
      .map { [weak self] insight -> String in
        self?.getPageDate(insight: insight) ?? ""
      }
      .bind(to: dataLable.rx.text)
      .disposed(by: disposeBag)
    reactor.state
      .compactMap { $0.currentLocationInsight?.subject }
      .distinctUntilChanged()
      .bind(to: insightSubjectLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.state
      .compactMap { $0.currentLocationInsight?.fieldName }
      .distinctUntilChanged()
      .bind(to: fieldNameButton.rx.title())
      .disposed(by: disposeBag)
    let originalInsight = Observable.combineLatest(reactor.state.map { $0.insights }, reactor.state.map { $0.originalLocationInsightId }) { insights, insightUid in
          insights.first { $0.uid == insightUid}
    }.compactMap { $0 }.distinctUntilChanged()

    let currentIndexithPrevious = reactor.state
      .map { $0.currentIndex }
      .scan((nil, nil)) { previous, current in
        (current, previous.0)
      }
      .map { current, previous -> (Int?, Bool) in
        let wasPreviousNil = previous == nil
        return (current, wasPreviousNil)
      }
    Observable.combineLatest(currentIndexithPrevious.distinctUntilChanged { $0.0 == $1.0 }, locationInsightsPager.rx.willDisplayCell.take(1)).observeOn(MainScheduler.instance).subscribe {
      [weak self] currentIndexithPrevious, _ in
      guard let self = self else { return }
      let index = currentIndexithPrevious.0
      guard let index = index else { return }
      self.shareButton.isHidden = false
      self.updatePagerArrows(index: index)
      if self.locationInsightsPager.currentIndex != index {
        let wasPreviousNil = currentIndexithPrevious.1
        self.move(index: index, animated: !wasPreviousNil)
      }
    }.disposed(by: disposeBag)

    // - MARK: user actions

    locationInsightsPager.rx.willEndDragging
      .map { index in
        Reactor.Action.setCurrentIndex(index: index)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    backButton.rx.tapGesture()
      .when(.recognized)
      .map { [weak self] _ in
        Reactor.Action.clickBack(navigationEffect: self?.navigateBack)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    Observable.combineLatest(
      shareButton.rx.tapGesture().when(.recognized),
      reactor.state.map { $0.shareActions }.distinctUntilChanged()
    )
    .map { $1 }
    .do(onNext: { [weak self] element in
      guard let self = self else { return }
      let shareActions = self.shareActions(strategies: element)
      self.showSharePopup(actions: shareActions)
    })
    .map { _ in Reactor.Action.shareClicked }
    .bind(to: reactor.action)
    .disposed(by: disposeBag)

    fieldNameButton.rx.tapGesture()
      .when(.recognized)
      .map { [weak self] _ in Reactor.Action.navigateToField(navigationEffect: self?.navigateToField(fieldId:)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    navigationPrev.rx.tapGesture()
      .when(.recognized)
      .map { _ in Reactor.Action.showPrevPage }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    navigationNext.rx.tapGesture()
      .when(.recognized)
      .map { _ in Reactor.Action.showNextPage }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    Observable.combineLatest(reactor.state
      .compactMap { $0.shouldShowPrevButtonGlow }, rx.viewDidAppear)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] shouldGlow, _ in
        guard let self = self else { return }
        self.navigationPrev.imageView?.backgroundColor = R.color.white()!
        self.navigationPrev.imageView?.glowingAnimationCornerRadius = (self.navigationPrev.imageView?.bounds.width ?? .zero) / 2
        shouldGlow ? self.navigationPrev.imageView?.startGlowing(color: R.color.darkMint()!)
          : self.navigationPrev.imageView?.stopGlowing(borderColor: UIColor.clear)
      })
      .disposed(by: disposeBag)
      Observable.combineLatest(rx.viewDidAppear, originalInsight).map { _, insight in Reactor.Action.reportScreenView(insight: insight) }
          .bind(to: reactor.action)
          .disposed(by: disposeBag)
  }

  private func shareActions(strategies: [ShareStrategy]) -> [UIAlertAction] {
    var actions: [UIAlertAction] = strategies.map { strategy in
      switch strategy {
      case .shapeFile:
        return UIAlertAction(title: R.string.localizable.insightRequestAShapeFile(), style: .default, handler: self.requestShapeFile)
      case .share:
        return UIAlertAction(title: R.string.localizable.insightShareReport(), style: .default, handler: self.shareInsight)
      }
    }
    let cancellAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)
    actions.append(cancellAction)
    return actions
  }

  private func shareInsight(alert _: UIAlertAction) {
    guard let reactor = reactor else { return }
    Observable
      .just(())
      .map { [weak self] _ in Reactor.Action.shareInsight(shareEffect: self?.share, view: self?.shareButton) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func getPageDate(insight: LocationInsight) -> String {
    let startDate = dateProvider.format(date: insight.startDate, region: insight.dateRegion, format: .short)
    let endDate = dateProvider.format(date: insight.endDate, region: insight.dateRegion, format: .short)
    return "\(startDate)-\(endDate)"
  }

  private func updatePagerArrows(index: Int) {
    navigationPrev.isEnabled = index > .zero && index < (reactor?.currentState.insights.count ?? .zero)
    navigationNext.isEnabled = index >= .zero && index < (reactor?.currentState.insights.count ?? .zero) - 1
  }

  private func move(index: Int, animated: Bool) {
    locationInsightsPager.scrollToItem(at: index, animated: animated)
  }

  private func navigateToField(fieldId: Int) {
    let vc = FieldViewController.instantiate(fieldId: fieldId, categoriesUiMapper: Resolver.resolve(), fieldImageryUiMapper: Resolver.resolve(), fieldIrrigationUiMapper: Resolver.resolve(), fieldSeasonsListUiMapper: Resolver.resolve(), flowController: flowController, animationProvider: Resolver.resolve())
    navigationController?.pushViewController(vc, animated: true)
  }
}

extension LocationInsightsPagerViewController {
  class func instantiate(insightUid: String, category: String, subCategory: String, fieldId: Int?, cycleId: Int? = nil, publicationYear: Int? = nil, origin: NavigationOrigin, flowController: MainFlowController) -> LocationInsightsPagerViewController {
    let vc = R.storyboard.locationInsightsPagerViewController.locationInsightsPagerViewController()!
    let reactor: LocationInsightsPagerReactor = Resolver.resolve(args: [insightUid, category, subCategory, fieldId as Any, cycleId, publicationYear, origin.rawValue])
    vc.reactor = reactor
    vc.origin = origin
    vc.flowController = flowController
    return vc
  }
}

extension LocationInsightsPagerViewController: HasBasicPopup {
  func basicPopupPositiveClicked(type: PopupType) {
    dismissPopup()
    reportRedirectToFormAnalytics(didContinute: true, type: type)
  }

  func basicPopupNegativeClicked(type: PopupType) {
    dismissPopup()
    reportRedirectToFormAnalytics(didContinute: false, type: type)
  }

  func basicPopupDismissed(type: PopupType) {
    reportRedirectToFormAnalytics(didContinute: false, type: type)
  }

  private func showSharePopup(actions: [UIAlertAction]) {
    let alertController = AppAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alertController.addButtons(actions: actions)
    present(alertController, animated: true)
  }

  private func reportRedirectToFormAnalytics(didContinute: Bool, type: PopupType) {
    guard let reactor = reactor else { return }
    if case .shapeFile = type {
      Observable
        .just(())
        .map { _ in Reactor.Action.shapeFileRedirectToFormClicked(didContinue: didContinute) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
  }

  private func requestShapeFile(alert _: UIAlertAction) {
    guard let reactor = reactor else { return }
    Observable
      .just(())
      .map { _ in Reactor.Action.shareShapeFileClicked }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    showBasicPopup(data: BasicPopupData(title: R.string.localizable.insightRequestAShapeFile(),
                                        subtitle: R.string.localizable.insightShareSapeFileDescription(),
                                        okButton: R.string.localizable.continue(),
                                        cancelButton: R.string.localizable.cancel(),
                                        type: .shapeFile))
  }
}
