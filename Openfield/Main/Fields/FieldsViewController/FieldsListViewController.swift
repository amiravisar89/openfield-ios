//
//  FieldsListViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 15/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import ReactorKit
import Resolver
import RxCocoa
import RxDataSources
import RxSwift
import UIKit
import FSPagerView
import UIView_Shimmer
import NVActivityIndicatorView
import FirebaseAnalytics
import RxViewController

final class FieldsListViewController: UIViewController, StoryboardView {
    typealias Reactor = FieldsListReactor

    @IBOutlet private weak var fieldsTable: UITableView!
    @IBOutlet private weak var emptyStateLabel: UILabel!
        
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loader: NVActivityIndicatorView!
    @IBOutlet weak var loadingContainer: UIView!
    
    let sortingPopupHeight: CGFloat = 350
    let sortingPopupCornerRadius: CGFloat = 16
    var animationProvider: AnimationProvider!
    var disposeBag = DisposeBag()
    let highlightsCardsProvider : HighlightsCardsProvider = Resolver.resolve()
    weak var flowController: MainFlowController!
    
    lazy var endLoadingAnimation : Observable<Void> = {
        return animationProvider.animate(duration: 0.3, delay: .zero) { [weak self] in
            guard let self = self else {return}
            self.loadingContainer.alpha = .zero
        }
    }()
    
    lazy var dataSource = RxTableViewSectionedAnimatedDataSource<FieldsListSection>(
        animationConfiguration: AnimationConfiguration(insertAnimation: .fade,
                                                       reloadAnimation: .fade,
                                                       deleteAnimation: .fade),
        configureCell: { [weak self] _, tableView, indexPath, fieldElement in
            guard let self = self,
            let reactor = self.reactor else {return UITableViewCell()}
            return self.getFieldCell(tableView: tableView, indexPath: indexPath, fieldElement: fieldElement, reactor: reactor)
        })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupStaticColors()
        setupStaticText()
        loader.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PerformanceManager.shared.stopTrace(for: NavigationOrigin.app_launch.rawValue)
        // Screen View analytics
        let screenViewParams = [AnalyticsParameterScreenName: ScreenName.fieldsList, AnalyticsParameterScreenClass: String(describing: FieldsListViewController.self), EventParamKey.category: EventCategory.fieldsList]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
    }
    
    private func setupStaticColors() {
        mainStackView.backgroundColor = R.color.screenBg()
    }
    
    private func setupTable() {
        fieldsTable.register(UINib(resource: R.nib.fieldCellView), forCellReuseIdentifier: R.reuseIdentifier.fieldCellView.identifier)
        fieldsTable.register(UINib(resource: R.nib.fieldCellShimmerView), forCellReuseIdentifier: R.reuseIdentifier.fieldCellShimmerView.identifier)
        fieldsTable.register(UINib(resource: R.nib.highlightPagerTableCell), forCellReuseIdentifier: R.reuseIdentifier.highlightPagerTableCell.identifier)
        
        fieldsTable.register(UINib(resource: R.nib.fieldsSectionHeader), forHeaderFooterViewReuseIdentifier: R.reuseIdentifier.fieldsSectionHeader.identifier)
        fieldsTable.register(UINib(resource: R.nib.highlightSectionHeader), forHeaderFooterViewReuseIdentifier: R.reuseIdentifier.highlightSectionHeader.identifier)

        fieldsTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        fieldsTable.backgroundColor = R.color.screenBg()!
        fieldsTable.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setupStaticText() {
        emptyStateLabel.text = R.string.localizable.accountNoResultsFound()
        loadingLabel.text = R.string.localizable.feedLoadingFields()
    }

    private func navigateToField(field: Field) {
        if let container = parent as? ContainerViewController {
            container.containerHeaderView.setSearchActive(active: false)
        }
        let vc = FieldViewController.instantiate(fieldId: field.id, categoriesUiMapper: Resolver.resolve(), fieldImageryUiMapper: Resolver.resolve(), fieldIrrigationUiMapper: Resolver.resolve(), fieldSeasonsListUiMapper: Resolver.resolve(), flowController: flowController, animationProvider: Resolver.resolve())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToInsight(insight: Insight) {
        if insight is IrrigationInsight {
            flowController.goToIrrigationInsight(insightUid: insight.uid, origin: .highlights)
        } else {
            flowController.goToLocationInsight(insightUid: insight.uid, category: insight.category, subCategory: insight.subCategory, fieldId: insight.fieldId, cycleId: insight.cycleId, publicationYear: insight.publicationYear, origin: .highlights)
        }
    }

    func bind(reactor: FieldsListViewController.Reactor) {
       
        reactor.state.map{$0.presentedSections}
            .bind(to: fieldsTable.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        

        reactor.state
            .map { $0.fieldList.count == 0 }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] hide in
                if let container = self?.parent as? ContainerViewController {
                    container.containerHeaderView.hideSearch(hide: hide)
                }
            })
            .disposed(by: disposeBag)
        

        fieldsTable.rx.modelSelected(FieldElement.self)
            .map { [unowned self] element in Reactor.Action.clickedField(fieldItem: element, navigation: self.navigateToField(field:)) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        fieldsTable.rx.contentOffset.debounce(.seconds(1), scheduler: MainScheduler.instance).compactMap { [weak self] contentOffset in
            guard let self = self else {return nil}
            return Reactor.Action.analyticsScroll(reachesEnd: fieldsTable.scrollToBottom(contentOffset: contentOffset))
        }.bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(reactor.state
            .map { $0.fieldsLoading && $0.highlightsLoading}.distinctUntilChanged(),
                                 self.rx.viewDidAppear.distinctUntilChanged())
            .observeOn(MainScheduler.instance).subscribe { [weak self] isLoading, _ in
                guard let self = self else {return}
                if !isLoading {
                  _ = self.endLoadingAnimation.observeOn(MainScheduler.instance).subscribe().dispose()
                }
            }.disposed(by: disposeBag)
        

        if let container = parent as? ContainerViewController {
            
            container.containerHeaderView.searchBar.searchTF.rx.text
                .compactMap {$0}
                .distinctUntilChanged()
                .map { text in Reactor.Action.changeSearchTerm(text: text) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            
            container.containerHeaderView.searchBar.clearBtn.rx.tapGesture().when(.recognized)
                .map { text in Reactor.Action.changeSearchTerm(text: "") }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            
            container.containerHeaderView.searchActive
                .distinctUntilChanged()
                .map { active in Reactor.Action.setSearchActive(active: active) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            
            container.containerHeaderView.farmsSelectionListener.filter { $0 }.map { _ in
                    Reactor.Action.farmSelectionClicked
                }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            container.containerHeaderView.settingsButtonListener.filter { $0 }.map { _ in
                    Reactor.Action.settingsButtonClicked
                }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)

            container.containerHeaderView.farmsSelectedListener.filter { $0 }.map { _ in
                    Reactor.Action.farmsSelected
                }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
    
    private func getFieldCell(tableView: UITableView, indexPath: IndexPath, fieldElement: FieldElement, reactor: FieldsListReactor) -> UITableViewCell {
        switch fieldElement.type {
            
        case .fieldCellContent(let fieldContent):
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fieldCellView.identifier, for: indexPath) as! FieldCellView
            cell.bind(to: fieldContent)
            return cell
            
        case .fieldHighlightContent(let fieldHighlightContent):
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.highlightPagerTableCell.identifier, for: indexPath) as! HighlightPagerTableCell
            cell.bind(to: fieldHighlightContent)
            
            cell.itemSelected
                .map { index in Reactor.Action.clickInsight(index: index, navigation: self.navigateToInsight(insight:)) }
                .bind(to: reactor.action)
                .disposed(by: cell.disposeBag)
            
            return cell
            
        case .loadingCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fieldCellShimmerView.identifier, for: indexPath)
            return cell
        }
    }
    
    private func showFieldsListSortingPopUpWithParams(sortingType: FieldListSortingType) {
        let width = UIScreen.main.bounds.width
        showFieldSortingPopup(sortingType: sortingType, size: CGSize(width: width, height: sortingPopupHeight), cornerRadius: sortingPopupCornerRadius, style: .bottomSheet)
    }
    
}

extension FieldsListViewController {
    class func instantiate(flowContorller : MainFlowController, animationProvider: AnimationProvider) -> FieldsListViewController {
        let vc = R.storyboard.fieldsListViewController.fieldsListViewController()!
        vc.reactor = Resolver.optional()
        vc.flowController = flowContorller
        vc.animationProvider = animationProvider
        return vc
    }
}

extension FieldsListViewController: HasFieldSortingPickerPopup {
    func selectSorting(sortingType: FieldListSortingType) {
        Observable
            .just(sortingType)
            .map { _ in Reactor.Action.setSorting(sortingType: sortingType) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
}

extension FieldsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionElement = dataSource.sectionModels[section]
        guard let reactor = reactor,
              let header = sectionElement.header else {return nil}
        
        switch sectionElement.type {
        case .fields:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.reuseIdentifier.fieldsSectionHeader.identifier) as? FieldsSectionHeader else {return nil}
            headerView.listTitle.text = header.leftTitle
            headerView.fieldSelectedSortingName.text = header.rightTitle
            headerView.fieldListSortingSelectionContainer.rx.tapGesture()
                .when(.recognized)
                .map{ [unowned self] _ in Reactor.Action.navigateSorting(navigation: self.showFieldsListSortingPopUpWithParams(sortingType:)) }
                .bind(to: reactor.action)
                .disposed(by: headerView.disposeBag)
            
            return headerView
            
        case .highlights:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.reuseIdentifier.highlightSectionHeader.identifier) as? HighlightSectionHeader else {return nil}
            headerView.leftTitle.text = header.leftTitle
            headerView.rightTitle.text = header.rightTitle
            
            headerView.rightTitle.rx.tapGesture()
                .when(.recognized)
                .map { [unowned self] _ in Reactor.Action.navigateHighlights(navigation: self.flowController.navigateToHighlights)}
                .bind(to: reactor.action)
                .disposed(by: headerView.disposeBag)
            
            return headerView
        }
    }
    
    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionElement = dataSource.sectionModels[section]
        guard sectionElement.header != nil else {return .zero}
        switch sectionElement.type {
        case .fields:
            return FieldsSectionHeader.height
            
        case .highlights:
            return HighlightSectionHeader.height
        }
        
    }
  
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let shimmerCell = cell as? FieldCellShimmerView {
            shimmerCell.stopShimmer()
        }
    }
    
}
