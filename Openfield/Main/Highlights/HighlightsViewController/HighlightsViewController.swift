//
//  HighlightsviewController.swift
//  Openfield
//
//  Created by amir avisar on 14/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import ReactorKit
import Resolver
import RxCocoa
import RxDataSources
import RxSwift
import RxViewController
import STPopup
import SwiftyUserDefaults
import UIKit
import NVActivityIndicatorView
import FirebaseAnalytics

class HighlightsViewController: UIViewController , StoryboardView {
    
    typealias Reactor = HighlightsReactor
    
    @IBOutlet weak var topHeader: UIView!
    @IBOutlet weak var headerTitle: Title2RegularWhiteBold!
    @IBOutlet weak var highlightsTable: UITableView!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var loader: NVActivityIndicatorView!
    @IBOutlet weak var loadingContainer: UIView!
    
    weak var flowController: MainFlowController!
    var disposeBag = DisposeBag()
    var highlightsCardsProvider : HighlightsCardsProvider!
    var animationProvider : AnimationProvider!
    
    lazy var endLoadingAnimation : Observable<Void> = {
        return animationProvider.animate(duration: 0.3, delay: .zero) { [weak self] in
            guard let self = self else {return}
            self.loader.stopAnimating()
            self.loadingContainer.alpha = .zero
        }
    }()
    
    lazy var dataSource = RxTableViewSectionedAnimatedDataSource<SectionHighlightItem>(animationConfiguration: AnimationConfiguration(insertAnimation: .fade,
                                                                                                                                      reloadAnimation: .fade,
                                                                                                                                      deleteAnimation: .bottom),
                                                                                       configureCell: { _, tableView, indexPath, highlightItem in
        return self.getHighlightCell(tableView: tableView, indexPath: indexPath, item: highlightItem)
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStaticColor()
        setupTable()
        loader.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let screenViewParams = [AnalyticsParameterScreenName: ScreenName.highlights, AnalyticsParameterScreenClass: String(describing: HighlightsViewController.self), EventParamKey.category: EventCategory.highlights]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
        PerformanceManager.shared.stopTrace(for: .highlights_list)
    }
    
    private func setupStaticColor() {
        view.backgroundColor = R.color.screenBg()!
        topHeader.backgroundColor = R.color.valleyDarkBrand()!
    }
    
    private func setupTable() {
        highlightsTable.rx.setDelegate(self).disposed(by: disposeBag)
        highlightsTable.register(UINib(resource: R.nib.highlightsTableCell), forCellReuseIdentifier: R.reuseIdentifier.highlightsTableCell.identifier)
    }
    
    func navigateToItem(item: HighlightItem) {
        switch item.type {
        case let .insight(insight, _):
            if insight is IrrigationInsight {
                flowController.goToIrrigationInsight(insightUid: insight.uid, origin: .highlights_list)
            } else {
                flowController.goToLocationInsight(insightUid: insight.uid, category: insight.category, subCategory: insight.subCategory, fieldId: insight.fieldId, cycleId: insight.cycleId, publicationYear: insight.publicationYear, origin: .highlights_list)
            }
        default:
            break
        }
    }
    
    private func getHighlightCell(tableView: UITableView, indexPath: IndexPath, item: HighlightItem) -> UITableViewCell {
        guard let cardData = self.highlightsCardsProvider.card(highlight: item) else {
            return UITableViewCell()
        }
        switch cardData.type {
        case .cardData(let data):
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.highlightsTableCell.identifier, for: indexPath) as! HighlightsTableCell
            cell.bind(cardData: data)
            cell.accessibilityIdentifier = "highlight_item_\(indexPath.row) uid: \(item.identity)"
            return cell
        case .empty(_):
            return UITableViewCell()
        }
    }
    
    func bind(reactor: HighlightsReactor) {

        
        reactor.state.map{$0.highlights}
            .observeOn(MainScheduler.instance)
            .bind(to: highlightsTable.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        backBtn.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.flowController.pop()
            })
            .disposed(by: disposeBag)
        
        highlightsTable.rx.itemSelected.map { indexPath in
            Reactor.Action.clickOnItem(index: indexPath.row, highlightItem: self.dataSource[indexPath], navigation: self.navigateToItem)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.loading }
            .filter{!$0}
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance).subscribe { [weak self] isLoading in
                guard let self = self else {return}
              _ = self.endLoadingAnimation.observeOn(MainScheduler.instance).subscribe()
            }.disposed(by: disposeBag)
        
        reactor.state
            .compactMap{$0.pageTitle}
            .bind(to: headerTitle.rx.text)
            .disposed(by: disposeBag)
        
        highlightsTable.rx.contentOffset.debounce(.seconds(1), scheduler: MainScheduler.instance).compactMap { [weak self] contentOffset in
            guard let self = self else {return nil}
            return Reactor.Action.analyticsScroll(reachesEnd: highlightsTable.scrollToBottom(contentOffset: contentOffset))
        }.bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension HighlightsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HighlightHeaderView.instanceFromNib(rect: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: HighlightHeaderView.height))
        header.title = dataSource.sectionModels[section].sectionTitle
        return header
    }
    
    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return HighlightHeaderView.height
    }
}

extension HighlightsViewController {
    class func instantiate(flowContorller : MainFlowController, highlightsCardsProvider : HighlightsCardsProvider, animationProvider: AnimationProvider, fieldId : Int? = nil, categoryId : String? = nil) -> HighlightsViewController {
        let vc = R.storyboard.highlightsViewController.highlightsViewController()!
        let reactor : HighlightsReactor = Resolver.resolve(args: [fieldId as Any, categoryId as Any])
        vc.reactor = reactor
        vc.flowController = flowContorller
        vc.highlightsCardsProvider = highlightsCardsProvider
        vc.animationProvider = animationProvider
        return vc
    }
}
