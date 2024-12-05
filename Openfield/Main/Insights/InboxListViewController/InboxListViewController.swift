//
//  InboxListViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 15/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import DatadogLogs
import FirebaseAnalytics
import NVActivityIndicatorView
import ReactorKit
import Resolver
import RxCocoa
import RxDataSources
import RxSwift
import RxViewController
import STPopup
import SwiftyUserDefaults
import UIKit

final class InboxListViewController: UIViewController, View, StoryboardView, HasImageryPopup {
    typealias Reactor = InboxListReactor

    @IBOutlet var loadingIndicator: NVActivityIndicatorView!
    @IBOutlet var footer: UIView!
    @IBOutlet var unreadTitle: BodySemiBoldBlack!
    @IBOutlet var unreadTitleContainer: UIView!
    @IBOutlet var inboxTableView: UITableView!
    @IBOutlet var emptyUnreadView: UIView!
    @IBOutlet var emptyFilterView: UIView!
    @IBOutlet var emptyStateTitle: UILabel!
    @IBOutlet var emptyStateSubtitle: SGLabelStyleBase!
    @IBOutlet var errorView: UIView!
    @IBOutlet var errorViewTitle: UILabel!
    @IBOutlet var errorViewSubtitle: UILabel!
    @IBOutlet var reloadButton: SGButton!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var loadingTitle: UILabel!
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var resetFilterBtn: UIButton!
    @IBOutlet var emptyFilterLabel: UILabel!

    var disposeBag = DisposeBag()
    weak var flowController: MainFlowController!
    var userSettings: UserSettings!
    var rolePopUpType: RolePopUpType = .popUp1

    private var needToShowRoleDialog = false
    private var needToShowSubscribePopup = false

    private let getSubscriptionPopupDataUseCase: GetSubscriptionPopupDataUseCase = Resolver.resolve()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionInboxItem>(configureCell: { _, tableView, indexPath, inboxItem in
        switch inboxItem.type {
        case let .insight(insight):
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.insightViewCell.identifier, for: indexPath) as! InsightViewCell
            cell.bind(to: insight)
            cell.backgroundColor = cell.contentView.backgroundColor
            cell.accessibilityIdentifier = "inbox_item_\(indexPath.row) uid: \(insight.uid)" // QA
            return cell
        case let .imagery(imagery):
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.imageryViewCell.identifier, for: indexPath) as! ImageryViewCell
            cell.bind(to: imagery)
            cell.backgroundColor = cell.contentView.backgroundColor
            cell.accessibilityIdentifier = "inbox_item_\(indexPath.row)" // QA
            return cell
        case let .locationInsight(locationInsight):
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.insightViewCell.identifier, for: indexPath) as! InsightViewCell
            cell.bind(to: locationInsight)
            cell.backgroundColor = cell.contentView.backgroundColor
            cell.accessibilityIdentifier = "location_item_\(indexPath.row) uid: \(locationInsight.uid)" // QA
            return cell
        }
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupStaticText()
        setupStaticColor()
        loadingIndicator.startAnimating()
        forQA()
    }

    func forQA() {
        resetFilterBtn.accessibilityIdentifier = "reset_farm_button"
        emptyStateTitle.accessibilityIdentifier = "empty_view_title"
        errorViewTitle.accessibilityIdentifier = "error_view_title"
        errorViewSubtitle.accessibilityIdentifier = "error_state_title"
        reloadButton.accessibilityIdentifier = "reload_button"
        loadingTitle.accessibilityIdentifier = "loading_title"
        emptyFilterLabel.accessibilityIdentifier = "empty_filter_label"
    }

    private func setupStaticColor() {
        viewBackground.backgroundColor = R.color.screenBg()!
        emptyUnreadView.backgroundColor = R.color.screenBg()!
        errorView.backgroundColor = R.color.screenBg()!
        loadingView.backgroundColor = R.color.screenBg()!
        loadingIndicator.color = R.color.valleyBrand()!
        loadingIndicator.type = .circleStrokeSpin
        emptyStateSubtitle.text = R.string.localizable.feedUnreadEmptyStateSubtitle()
        inboxTableView.backgroundColor = R.color.screenBg()!
    }

    func setupTable() {
        inboxTableView.register(UINib(resource: R.nib.insightViewCell), forCellReuseIdentifier: R.reuseIdentifier.insightViewCell.identifier)
        inboxTableView.register(UINib(resource: R.nib.imageryViewCell), forCellReuseIdentifier: R.reuseIdentifier.imageryViewCell.identifier)
        inboxTableView.backgroundColor = R.color.screenBg()!
    }

    func setupStaticText() {
        emptyStateTitle.text = R.string.localizable.feedNoUnreadInsights()
        errorViewTitle.text = R.string.localizable.feedOops()
        errorViewSubtitle.text = R.string.localizable.feedErrorInsightsSubtitle()
        reloadButton.titleString = R.string.localizable.feedReload()
        loadingTitle.text = R.string.localizable.feedLoadingInsights()
        emptyFilterLabel.text = R.string.localizable.feedEmptyNoInsightToShow()
        resetFilterBtn.setTitle(R.string.localizable.feedEmptyResetAllFarmFilter(), for: .normal)
        resetFilterBtn.backgroundColor = R.color.valleyBrand()
        unreadTitle.text = R.string.localizable.feedUnreadTitle()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        inboxTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: inboxTableView.frame.size.width, height: 1))

        // Analytics
        let screenViewParams = [AnalyticsParameterScreenName: ScreenName.feed, AnalyticsParameterScreenClass: String(describing: InboxListViewController.self), EventParamKey.category: EventCategory.feed]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
      
      guard reactor == nil else { // this VC require a-lot of CPU, we init the reactor only when this VC is shown until we will remove this VC completly
        return
      }
      let reactor: InboxListReactor = Resolver.resolve()
      self.reactor = reactor
    }


    func showSubscribePopup() {
        flowController.showSubscriptionPopUp(vc: self)
        Observable
            .just(())
            .map { _ in Reactor.Action.updateUserSawSubscribePopup }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }

    func updateUserSeenFieldTooltip() {
        Observable
            .just(())
            .map { _ in Reactor.Action.updateUserSeenFieldTooltip }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }

    func navigateToItem(item: InboxItem, forceRefresh: Bool = false) {
        switch item.type {
        case let .insight(insight):
            PerformanceManager.shared.startTrace(origin: .insights_list, target: .irrigation_insight)
            flowController.goToIrrigationInsight(insightUid: insight.uid, origin: .feed)
        case let .locationInsight(locationInsight):
            PerformanceManager.shared.startTrace(origin: .insights_list, target: .location_insight)
            flowController.goToLocationInsight(insightUid: locationInsight.uid, category: locationInsight.category, subCategory: locationInsight.subCategory, fieldId: locationInsight.fieldId, cycleId: locationInsight.cycleId, publicationYear: locationInsight.publicationYear, origin: .feed)
        case let .imagery(imagery):
            PerformanceManager.shared.startTrace(origin: .insights_list, target: .imagery_popup)
            flowController.goToImageryPopup(imageryDate: imagery.date, forceRefresh: forceRefresh, animated: true, origin: .feed)
        }
    }

    @objc private func backgroundViewDidTap() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }

    func bind(reactor: InboxListReactor) {
        reloadButton.rx.tapGesture()
            .when(.recognized)
            .map { _ in Reactor.Action.reloadList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        resetFilterBtn.rx.tapGesture()
            .when(.recognized)
            .map { _ in Reactor.Action.resetFarmFilter }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        inboxTableView.rx.itemSelected.observeOn(MainScheduler.instance)
            .compactMap { [weak self] indexPath in
                guard let self = self else { return nil }
                self.navigateToItem(item: self.dataSource[indexPath], forceRefresh: false)
                return Reactor.Action.clickOnItem(inboxItem: self.dataSource[indexPath])
            }

            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.presentedInboxItems.count }
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.inboxTableView.scrollToTop()
            }).disposed(by: disposeBag)

        if let container = parent as? ContainerViewController {
            container
                .containerHeaderView
                .tapUnreadFilter?
                .map { _ in
                    .clickToggleShowUnreadAll
                }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)

            reactor.state
                .map { $0.displayingUnread }
                .bind(to: container.containerHeaderView.rx.isUnreadState)
                .disposed(by: disposeBag)
        }

        // State
        reactor.state.map { $0.presentedItems }
            .do(onNext: { [weak self] _ in
              guard let self = self else {return}
              self.inboxTableView.rx.setDelegate(self).disposed(by: disposeBag)
            })
            .bind(to: inboxTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)


        reactor.state.map { !$0.showFilterEmptyState }
            .bind(to: emptyFilterView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { !$0.showUnreadEmptyState }
            .bind(to: emptyUnreadView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { !$0.showError }
            .bind(to: errorView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.map { !$0.isLoading }
            .bind(to: loadingView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.compactMap { ($0.user?.tracking) }
            .take(1)
            .subscribe(onNext: { [weak self] tracking in
                guard let self = self else { return }
                guard tracking.tsSawSubscribePopUp == nil,
                      let minDate = DateFormatter.iso8601DateOnly.date(from: self.getSubscriptionPopupDataUseCase.minDate()),
                      let maxDate = DateFormatter.iso8601DateOnly.date(from: self.getSubscriptionPopupDataUseCase.maxDate())
                else {
                    return
                }
                guard minDate.dateAtStartOf(.day) < Date(), maxDate.dateAtEndOf(.day) > Date() else {
                    return
                }
                if Defaults.finishAppwalkThrew.contains(Defaults.userId) {
                    self.showSubscribePopup()
                } else {
                    self.needToShowSubscribePopup = true
                }

            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { ($0.user?.settings) }.take(1)
            .subscribe(onNext: { [weak self] settings in
                guard let self = self else { return }
                self.userSettings = settings

                guard settings.userRole == nil else { return }
                guard settings.seenRolePopUp == nil else { return }

                if Defaults.finishAppwalkThrew.contains(Defaults.userId) {
                    self.flowController.showRollPopUp(vc: self, type: .popUp2, setting: settings)
                } else {
                    self.rolePopUpType = .popUp1
                    self.needToShowRoleDialog = true
                }
            })
            .disposed(by: disposeBag)

        reactor.state.map { !$0.displayingUnread }
            .bind(to: unreadTitleContainer.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

extension InboxListViewController {
    class func instantiate(flowController: MainFlowController) -> InboxListViewController {
        let vc = R.storyboard.inboxListViewController.inboxListViewController()!
        vc.flowController = flowController
        return vc
    }
}

extension InboxListViewController: AppWalkthroughViewControllerDelegate {
    func AppWalkthroughViewControllerDismissed() {
        if needToShowRoleDialog && userSettings.seenRolePopUp == nil {
            flowController.showRollPopUp(vc: self, type: rolePopUpType, setting: userSettings)
        }
        if needToShowSubscribePopup {
            showSubscribePopup()
        }
    }
}

extension InboxListViewController: RoleSelectionDelegate {
    func roleSelected(role: UserRole) {
        Observable
            .just(())
            .map { _ in Reactor.Action.updateUserRole(role: role) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)

        Observable
            .just(())
            .map { _ in Reactor.Action.updateUserSeenRole }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
}

extension InboxListViewController: SubscribePopupViewControllerDelegate {
    func mainBtnClicked() {
        Observable
            .just(())
            .map { _ in Reactor.Action.updateUserClickedSubscribePopup }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
}

extension InboxListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = FeedSectionHeaderView.instanceFromNib(rect: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: FeedSectionHeaderView.height))
        header.title = dataSource.sectionModels[section].sectionTitle
        return header
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return FeedSectionHeaderView.height
    }
}
