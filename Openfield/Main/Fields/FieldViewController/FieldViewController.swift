//
//  FieldViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 15/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import NVActivityIndicatorView
import ReactorKit
import Resolver
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

final class FieldViewController: UIViewController, StoryboardView {
  typealias Reactor = FieldViewReactor

  @IBOutlet private weak var cycleDropDownContainer: UIStackView!
  @IBOutlet private weak var cycleBtn: Title6RegularGray8!
  @IBOutlet private weak var dropDownArrow: UIImageView!
  @IBOutlet private weak var fieldName: Title7Regular!
  @IBOutlet private weak var fieldImage: ImageViewer!
  @IBOutlet private weak var insightsTable: UITableView!
  @IBOutlet private weak var backButton: UIButton!
  @IBOutlet private weak var emptyStateContainer: UIView!
  @IBOutlet private weak var loadingContainer: UIView!
  @IBOutlet private weak var emptyStateTitle: UILabel!
  @IBOutlet private weak var emptyStateContent: UILabel!
  @IBOutlet private weak var loader: NVActivityIndicatorView!
  @IBOutlet private weak var virtualScoutingContainer: UIView!
  @IBOutlet private weak var virtualScoutingButton: UIView!
  @IBOutlet private weak var virtualScoutingButtonImage: UIImageView!
  @IBOutlet private weak var virtualScoutingNew: UIImageView!
  @IBOutlet private weak var virtualScoutingTitle: BodyRegular!
  @IBOutlet private weak var tableLoadigContainer: UIView!
  @IBOutlet private weak var tableLoader: NVActivityIndicatorView!
  var categoriesUiMapper: CategoriesUiMapper!
  var fieldImageryUiMapper: FieldImageryUiMapper!
  var fieldIrrigationUiMapper: FieldIrrigationUiMapper!
  var fieldSeasonsListUiMapper: FieldSeasonsListUiMapper!
  weak var flowController: MainFlowController!
  var animationProvider: AnimationProvider!
  let popupHeight: CGFloat = 350
  let popupCornerRadius: CGFloat = 16
  
  var disposeBag = DisposeBag()

  lazy var endLoadingAnimation: Observable<Void> = animationProvider.animate(duration: 0.3, delay: .zero) { [weak self] in
    guard let self = self else { return }
    self.loader.stopAnimating()
    self.loadingContainer.alpha = .zero
  }
  
  lazy var startTableLoading: Observable<Void> = animationProvider.animate(duration: 0.3, delay: .zero) { [weak self] in
    guard let self = self else { return }
    self.tableLoader.startAnimating()
    self.tableLoadigContainer.alpha = 1
  }
  
  lazy var endTableLoading: Observable<Void> = animationProvider.animate(duration: 0.3, delay: .zero) { [weak self] in
    guard let self = self else { return }
    self.tableLoader.stopAnimating()
    self.tableLoadigContainer.alpha = .zero
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTable()
    setupColors()
    fieldName.lineBreakMode = .byTruncatingMiddle
    loader.startAnimating()
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
    PerformanceManager.shared.stopTrace(for: .field)
  }

  func back() {
    flowController.pop()
  }

  private func setupColors() {
    backButton.layer.zPosition = 1000
    emptyStateContainer.backgroundColor = R.color.screenBg()!
    view.backgroundColor = R.color.screenBg()!
  }

  private func setNoInsightsText() {
    emptyStateTitle.text = R.string.localizable.feedNoInsights()
    emptyStateContent.text = R.string.localizable.fieldViewImagesOnAnalyze()
  }

  private func setNoImageryText() {
    emptyStateTitle.text = R.string.localizable.fieldEmptyText()
    emptyStateContent.text = R.string.localizable.fieldNoDataAvailableForThisField()
  }

  private func setupTable() {
    insightsTable.register(UINib(resource: R.nib.requestReportCell), forCellReuseIdentifier: R.reuseIdentifier.requestReportCell.identifier)
    insightsTable.register(UINib(resource: R.nib.fieldIrrigationCell), forCellReuseIdentifier: R.reuseIdentifier.fieldIrrigationCell.identifier)
    insightsTable.register(UINib(resource: R.nib.fieldCategoryCell), forCellReuseIdentifier: R.reuseIdentifier.fieldCategoryCell.identifier)
    insightsTable.register(UINib(resource: R.nib.fieldImageryCell), forCellReuseIdentifier: R.reuseIdentifier.fieldImageryCell.identifier)
    insightsTable.separatorColor = R.color.screenBg()!
    insightsTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: insightsTable.frame.size.width, height: 20))
    insightsTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: insightsTable.frame.size.width, height: 8))
  }

  private func navigateToLocationInsight(insight: Insight) {
    guard insight is LocationInsight else { return }
    flowController.goToLocationInsight(insightUid: insight.uid, category: insight.category, subCategory: insight.subCategory, fieldId: insight.fieldId, cycleId: insight.cycleId, publicationYear: insight.publicationYear, origin: .field)
  }

  private func navigateIrrigationInsight(irrigationInsight: IrrigationInsight) {
    flowController.goToIrrigationInsight(insightUid: irrigationInsight.uid, origin: .field)
  }

  private func navigateToAnalysis(field: Field) {
    guard let latestImageGroup = field.latestAvailableLayerFieldImageGroup() else { return }
    let vc = AnalysisHolderViewController.instantiate(with: AnalysisParams(fieldId: field.id, initialDate: latestImageGroup.date, initialLayer: latestImageGroup.imageryMainType, field: field, insight: nil, initialInsights: nil, origin: "my_fields"))
    navigationController?.present(vc, animated: true)
  }

  private func navigateToVirtualScouting(field: Field, cycleId: Int) {
    let vc = VirtualScoutingViewController.instantiate(field: field, cycleId: cycleId, flowController: flowController, animationProvider: Resolver.resolve())
    navigationController?.pushViewController(vc, animated: true)
  }

  private func getFieldCell(tableView: UITableView, indexPath: IndexPath, fieldCell: FieldReportItem, reactor: FieldViewReactor) -> UITableViewCell {
    switch fieldCell.type {
    case let .category(category):
      let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fieldCategoryCell.identifier, for: indexPath) as! FieldCategoryCell
      guard let category = categoriesUiMapper.cell(insightCategory: category) else { return UITableViewCell() }
      cell.bind(to: category)
      cell.accessibilityIdentifier = "field_category_cell_\(category.insightUid)"
      return cell

    case let .fieldImage(fieldImage):
      let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fieldImageryCell.identifier, for: indexPath) as! FieldImageryCell
      let image = fieldImageryUiMapper.image(fieldImage: fieldImage)
      cell.bind(uiElement: image)
      cell.accessibilityIdentifier = "field_imagery_cell_\(fieldImage.imageId)"
      return cell
    case let .irrigation(irrigation: irrigation):
      let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fieldIrrigationCell.identifier, for: indexPath) as! FieldIrrigationCell
      let irrigation = fieldIrrigationUiMapper.irrigation(fieldIrrigation: irrigation)
      cell.bind(uiElement: irrigation)
      cell.accessibilityIdentifier = "field_Irrigation_cell"

      cell.insightsTable.rx.itemSelected.map { indexPath in
        FieldViewReactor.Action.navigateIrrigation(index: indexPath.row, irrigationNavigation: self.navigateIrrigationInsight)
      }.bind(to: reactor.action)
        .disposed(by: cell.disposeBag)

      cell.buttonTitle.rx.tapGesture().when(.recognized).map { _ in
        FieldViewReactor.Action.navigateHighlights(navigation: self.flowController.navigateToHighlights(fieldId:categoryId:))
      }.bind(to: reactor.action)
        .disposed(by: cell.disposeBag)

      return cell
    case .requestReport:
      let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.requestReportCell.identifier, for: indexPath) as! RequestReportCell
      cell.accessibilityIdentifier = "request_Report_cell"
      return cell
    }
  }

  func bind(reactor: FieldViewReactor) {
    backButton.rx.tapGesture().when(.recognized)
      .map { _ in FieldViewReactor.Action.navigateBack(navigation: self.back) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    reactor.state
      .map { state -> DropDownState in
        if state.selectedSeason == nil || state.seasons.count == 0 {
          return DropDownState(isContainerHidden: true, isArrowHidden: true, isContainerEnabled: false)
        } else if state.selectedSeason != nil && state.seasons.count == 1 {
          return DropDownState(isContainerHidden: false, isArrowHidden: true, isContainerEnabled: false)
        } else { // state.selectedSeason != nil && state.seasons.count > 1
          return DropDownState(isContainerHidden: false, isArrowHidden: false, isContainerEnabled: true)
        }
      }
      .distinctUntilChanged()
      .subscribe(onNext: { state in
        self.cycleDropDownContainer.isHidden = state.isContainerHidden
        self.dropDownArrow.isHidden = state.isArrowHidden
        self.cycleDropDownContainer.isUserInteractionEnabled = state.isContainerEnabled
      })
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.selectedSeason?.name }
      .distinctUntilChanged()
      .bind(to: cycleBtn.rx.text)
      .disposed(by: disposeBag)
    reactor.state
      .map { $0.virtualScoutingState }
      .distinctUntilChanged().subscribe { state in
        self.updateVirtualScoutingState(state: state)
      }.disposed(by: disposeBag)

    virtualScoutingButton.rx.tapGesture().when(.recognized)
      .map { _ in FieldViewReactor.Action.navigateScoutingButton(navigation: self.navigateToVirtualScouting(field: cycleId:)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    cycleDropDownContainer.rx.tapGesture().when(.recognized)
      .map { _ in FieldViewReactor.Action.seasonSelectionClicked }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    cycleDropDownContainer.rx.tapGesture().when(.recognized)
      .flatMapLatest { [weak reactor] _ -> Observable<([Season], Season?)> in
        guard let reactor = reactor else { return .empty() }
        return reactor.state.map { ($0.seasons, $0.selectedSeason) }
          .take(1)
      }
      .subscribe(onNext: { [weak self] seasons, selectedSeason in
        guard let self = self else { return }
        let uiElements = fieldSeasonsListUiMapper.mapToUiElement(seasons: seasons, selectedSeason: selectedSeason)
        self.showPickerPopUpWithParams(itemsList: uiElements)
      })
      .disposed(by: disposeBag)

    reactor.state.map { $0.cells }
      .bind(to: insightsTable.rx.items) { [weak self] tableView, row, fieldCell in
        guard let self = self else { return UITableViewCell() }
        return self.getFieldCell(tableView: tableView, indexPath: IndexPath(row: row, section: 0), fieldCell: fieldCell, reactor: reactor)
      }
      .disposed(by: disposeBag)
      
    reactor.state.map{$0.seasonLoading}
      .observeOn(MainScheduler.instance)
      .subscribe { [weak self] isLoading in
        _ = isLoading ? self?.startTableLoading.subscribe().dispose() : self?.endTableLoading.subscribe().dispose()
      }.disposed(by: disposeBag)

    reactor.state
      .map { !($0.cells.count == 0 && !$0.isLoading) }
      .bind(to: emptyStateContainer.rx.isHidden)
      .disposed(by: disposeBag)

    reactor.state
      .compactMap { $0.field?.name.capitalize() }
      .bind(to: fieldName.rx.text)
      .disposed(by: disposeBag)

    reactor.state
      .compactMap { $0.field?.coverImage }
      .distinctUntilChanged()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] image in
        guard let self = self else { return }
        self.fieldImage.display(images: [image])
      })
      .disposed(by: disposeBag)
      Observable.combineLatest(rx.viewDidAppear, reactor.state.compactMap { $0.field }.distinctUntilChanged())
          .map { _ in FieldViewReactor.Action.reportScreenView }
          .bind(to: reactor.action)
          .disposed(by: disposeBag)
    Observable.combineLatest(reactor.state
      .compactMap { $0.virtualScoutingButtonShouldGlow }, rx.viewDidAppear)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] shouldGlow, _ in
        guard let self = self else { return }
        shouldGlow ? self.virtualScoutingButton.startGlowing(color: R.color.darkMint()!)
          : self.virtualScoutingButton.stopGlowing(borderColor: R.color.grey3()!)
      })
      .disposed(by: disposeBag)
      
      Observable.combineLatest(reactor.state.map { $0.isLoading }.filter{!$0}.distinctUntilChanged(),
                             rx.viewDidAppear.distinctUntilChanged())
      .observeOn(MainScheduler.instance).subscribe { [weak self] _, _ in
        guard let self = self else { return }
        _ = self.endLoadingAnimation.observeOn(MainScheduler.instance).subscribe().dispose()
      }.disposed(by: disposeBag)

    reactor.state
      .map { $0.showNoInsights }
      .subscribe(onNext: { [weak self] show in
        if show {
          self?.setNoInsightsText()
        }
      })
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.showNoImagery }
      .subscribe(onNext: { [weak self] show in
        if show {
          self?.setNoImageryText()
        }
      })
      .disposed(by: disposeBag)

    insightsTable.rx.contentOffset.debounce(.seconds(1), scheduler: MainScheduler.instance).compactMap { [weak self] contentOffset in
      guard let self = self else { return nil }
      return FieldViewReactor.Action.analyticsScroll(reachesEnd: insightsTable.scrollToBottom(contentOffset: contentOffset))
    }.bind(to: reactor.action)
      .disposed(by: disposeBag)

    insightsTable.rx.itemSelected.map { indexPath in
      FieldViewReactor.Action.navigate(index: indexPath.row, locationInsightsNavigation: self.navigateToLocationInsight(insight:), imageryNavigation: self.navigateToAnalysis(field:), requestReport: self.requestReportConfirmation(link:))
    }.bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func showPickerPopUpWithParams(itemsList: [PickerPopupCellUiElement]) {
    let width = UIScreen.main.bounds.width
    let titleLabel = R.string.localizable.farmChooseSeason()
    let buttonLabel = R.string.localizable.done()
    guard let selectedElement = itemsList.first(where: { $0.isSelected }) else {
      return
    }
    showPopup(itemsList: itemsList, initialItemId: selectedElement.id, titleLabel: titleLabel, buttonLabel: buttonLabel, size: CGSize(width: width, height: popupHeight), cornerRadius: popupCornerRadius, style: .bottomSheet)
  }

  private func updateVirtualScoutingState(state: VirtualScoutingState) {
    virtualScoutingTitle.text = R.string.localizable.virtualScoutingVirtualScoutingButton()
    switch state {
    case .hidden:
      virtualScoutingContainer.isHidden = true
    case .enabled:
      virtualScoutingContainer.isHidden = false
      virtualScoutingButton.isUserInteractionEnabled = true
      virtualScoutingNew.isHidden = false
      virtualScoutingButtonImage.image = R.image.binoculars()
      virtualScoutingTitle.textColor = .black
    case .disabled:
      virtualScoutingContainer.isHidden = false
      virtualScoutingButton.isUserInteractionEnabled = false
      virtualScoutingNew.isHidden = true
      virtualScoutingButtonImage.image = R.image.binoculargrey()
      virtualScoutingTitle.textColor = R.color.gray7()
    }
  }
}

extension FieldViewController: PickerPopup {
  func selectItem(itemId: Int) {
    Observable
      .just(itemId)
      .map { _ in Reactor.Action.selectSeason(selectedSeasonOrder: itemId) }
      .bind(to: reactor!.action)
      .disposed(by: disposeBag)
  }
}

extension FieldViewController: HasBasicPopup {
  func basicPopupPositiveClicked(type: PopupType) {
    dismissPopup()
    guard let reactor = reactor else { return }
    if case let .requestReport(link) = type {
      Observable.just(FieldViewReactor.Action.requestReportClicked(link: link))
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
  }

  func basicPopupNegativeClicked(type: PopupType) {
    dismissPopup()
    guard let reactor = reactor else { return }
    if case let .requestReport(link) = type {
      Observable.just(FieldViewReactor.Action.requestReportDismissed)
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
  }

  func basicPopupDismissed(type _: PopupType) {}

  private func requestReportConfirmation(link: URL) {
    showBasicPopup(data: BasicPopupData(title: R.string.localizable.fieldRequestReportTitle(),
                                        subtitle: R.string.localizable.fieldRequestReportDialogDescription(),
                                        okButton: R.string.localizable.continue(),
                                        cancelButton: R.string.localizable.cancel(),
                                        type: .requestReport(link: link)))
  }
}

extension FieldViewController {
  class func instantiate(fieldId: Int, categoriesUiMapper: CategoriesUiMapper, fieldImageryUiMapper: FieldImageryUiMapper, fieldIrrigationUiMapper: FieldIrrigationUiMapper, fieldSeasonsListUiMapper: FieldSeasonsListUiMapper, flowController: MainFlowController, animationProvider: AnimationProvider) -> FieldViewController {
    let vc = R.storyboard.fieldViewController.fieldViewController()!
    vc.categoriesUiMapper = categoriesUiMapper
    vc.fieldImageryUiMapper = fieldImageryUiMapper
    vc.fieldIrrigationUiMapper = fieldIrrigationUiMapper
    vc.fieldSeasonsListUiMapper = fieldSeasonsListUiMapper
    vc.flowController = flowController
    vc.animationProvider = animationProvider
    vc.reactor = Resolver.optional(args: [fieldId])
    return vc
  }
}

struct DropDownState: Equatable {
  let isContainerHidden: Bool
  let isArrowHidden: Bool
  let isContainerEnabled: Bool
}
