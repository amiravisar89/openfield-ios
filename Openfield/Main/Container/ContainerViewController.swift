//
//  ContainerViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 21/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import NVActivityIndicatorView
import ReactorKit
import Resolver
import RxSwift
import Smartlook
import StoreKit
import SwiftDate
import SwiftyUserDefaults
import UIKit

final class ContainerViewController: UIViewController, View, StoryboardView, ShowsNotificationPermission {
    typealias Reactor = ContainerViewReactor

    // MARK: - Compute Members

    private var selectedViewController: UIViewController? {
        guard let viewControllers = viewControllers else { return nil }
        return viewControllers[selectedIndex.rawValue]
    }

    lazy var startLoadingAnimation: Observable<Void> = animationProvider.animate(duration: 0.3, delay: 0) { [weak self] in
        guard let self = self else { return }
        self.loader?.startAnimating()
        self.loadingView?.alpha = 1
    }

    lazy var endLoadingAnimation: Observable<Void> = animationProvider.animate(duration: 0.3, delay: 0) { [weak self] in
        guard let self = self else { return }
        self.loader?.stopAnimating()
        self.loadingView?.alpha = 0
    }

    // MARK: - Members

    private var remoteConfigRepository: RemoteConfigRepository = Resolver.resolve()
    private var storeProductViewController = SKStoreProductViewController()
    private var selectedIndex: CustomTabBar.TabItem = .fields
    private var viewControllers: [UIViewController]!
    var contractProvider: TermsOfUseProviderProtocol!
    private var toolTipManager = ToolTipManager()
    let appleID = 1_497_154_674
    var didFieldToolTipOpen = false
    let authInteractor: AuthInteractor = Resolver.resolve()
    let updateUserParamsUsecase: UpdateUserParamsUsecase = Resolver.resolve()
    let getVersionsLimitUseCase: GetVersionsLimitUseCase = Resolver.resolve()
    let userUseCase: UserStreamUsecase = Resolver.resolve()
    let getOptionalPopUpDaysTimeIntervalUseCase : GetOptionalPopUpDaysTimeIntervalUseCase = Resolver.resolve()
    weak var flowController: MainFlowController!
    var animationProvider: AnimationProvider!
    var disposeBag = DisposeBag()

    // MARK: - Outlets

    @IBOutlet var containerHeaderView: ContainerHeader!
    @IBOutlet private var actionBar: UIView!
    @IBOutlet private var container: UIView!
    @IBOutlet var tabBar: CustomTabBar!
    @IBOutlet var viewBackground: UIView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var loader: NVActivityIndicatorView!
    @IBOutlet weak var impersonationLabel: UILabel!
    @IBOutlet weak var imperonationContainer: UIView!

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildren()
        initRootViewController(childAtIndex: selectedIndex)
        tabBar.delegate = self
        storeProductViewController.delegate = self
        tabBar.setupTabs(initialTab: selectedIndex)
        setupStaticColor()
        handleMinSoftwareVersion()
        validateUser()
        observerNotifications()
        impersonationBadge()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setStatusBarColor(color: R.color.valleyDarkBrand()!)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setStatusBarColor(color: .clear)
    }

    func showLoader() {
        _ = startLoadingAnimation.observeOn(MainScheduler.instance).subscribe()
    }

    func hideLoader() {
        _ = endLoadingAnimation.observeOn(MainScheduler.instance).subscribe()
    }

    func observerNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func appMovedToForeground() {
        Observable.just(())
            .map { _ in Reactor.Action.checkNotificationPermissionState(askPermissionDialog: self.checkPermission) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }

    // MARK: - Private func

    private func setupStaticColor() {
        actionBar.backgroundColor = R.color.valleyDarkBrand()!
        container.backgroundColor = R.color.screenBg()!
        viewBackground.backgroundColor = .white
        loader.color = R.color.valleyBrand()!
        loadingView.backgroundColor = R.color.screenBg()!
    }

    private func impersonationBadge() {
        if Defaults.impersonatorId != nil {
            imperonationContainer.isHidden = false
            impersonationLabel.text = "\(R.string.localizable.impersonationBadge()) \(Defaults.extUser?.phone ?? "")" //Entrando como
        } else {
            imperonationContainer.isHidden = true
        }
    }

    func bind(reactor: ContainerViewReactor) {
        containerHeaderView.settingBtn.rx.tapGesture().when(.recognized).observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            PerformanceManager.shared.startTrace(origin: .insights_list, target: .account_settings)
            containerHeaderView.settingsButtonListener.onNext(true)
            self.flowController.goToAccount()
        }).disposed(by: disposeBag)

        containerHeaderView.farmBtn.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            PerformanceManager.shared.startTrace(origin: .insights_list, target: .farm_selection)
            let vc = FarmSelectionViewController.getVc()
            vc.farmsSelectedListener = containerHeaderView.farmsSelectedListener
            self.setStatusBarColor(color: .clear)
            self.present(vc, animated: false, completion: nil)
            containerHeaderView.farmsSelectionListener.onNext(true)
        }).disposed(by: disposeBag)

        reactor.state
            .compactMap { ($0.user?.settings) }
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] settings in
                if settings.notificationsEnabled, settings.notificationsPush {
                    self?.checkPermission()
                }
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.farms }
            .observeOn(MainScheduler.instance)
            .map { $0.count != 1 }
            .bind(to: containerHeaderView.farmBtn.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)

        reactor.state.map { $0.farms }
            .observeOn(MainScheduler.instance)
            .map { $0.count < 2 }
            .bind(to: containerHeaderView.farmFromArrow.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state.filter { !$0.farms.isEmpty }.map { $0.farmFilters }
            .observeOn(MainScheduler.instance).compactMap { [weak self] farms in
                guard let self = self else { return nil }
                return self.handleFarmBtnTitle(farms: farms)
            }.catchError { _ in .empty() }
            .bind(to: containerHeaderView.farmBtntitle.rx.text)
            .disposed(by: disposeBag)

        contractProvider.shouldSign().distinctUntilChanged().observeOn(MainScheduler.instance)
            .filter { _ in Defaults.seenAppwalkthrough.contains(Defaults.userId) }.subscribe { [weak self] shouldSign in
                guard let self = self else { return }
                guard let shouldsign = shouldSign.element else { return }
                if shouldsign {
                    self.flowController.navigateToSignContractScreen()
                }
            }.disposed(by: disposeBag)
    }

    private func handleFarmBtnTitle(farms: [FilteredFarm]) -> String? {
        let farmsSelected = farms.filter { $0.isSelected }
        if farms.count == 1 {
            return farms.first?.name
        } else if farmsSelected.count == farms.count {
            return R.string.localizable.farmAllFarms()
        } else if farmsSelected.count == 1 {
            return farmsSelected.first?.name
        } else {
            return " \(farmsSelected.count) " + R.string.localizable.farmFarmSelected()
        }
    }

    private func checkPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            guard error == nil else {
                self.showCustomPermissionDialog()
                return
            }
            if success {
                log.info("User approved notifications")
            } else {
                self.showCustomPermissionDialog()
            }
        }
    }

    private func addChildren() {
        viewControllers?.forEach { viewController in
            addChild(viewController)
        }
        self.view.bringSubviewToFront(actionBar)
    }

    private func validateUser() {
        userUseCase.userStream()
            .map { $0.isSubscribed() }
            .distinctUntilChanged()
            // The 5 sec delay in because Persistence data from firebase cause to first user emit not to be from server but from cache
            .debounce(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
            .filter { !$0 }
            .do { _ in log.info("Logging out because user has no subscriptions") }
            .flatMap { [weak self] _ -> Observable<Void> in return self?.updateUserParamsUsecase.clearUser() ?? Observable.empty() }
            .flatMap { [weak self] _ -> Observable<Bool> in return self?.authInteractor.logoutFormFirebase() ?? Observable.empty() }
            .subscribe(
                onNext: { [weak self] _ in
                  self?.flowController.restart()
                },
                onError: { log.error("Error while logging out because user has no subscriptions - \($0)") }
            )
            .disposed(by: disposeBag)
    }

    func goToAppStore() {
        // Create a product dictionary using the App Store's iTunes identifer.
        let parametersDict = [SKStoreProductParameterITunesItemIdentifier: appleID]

        /* Attempt to load it, present the store product view controller if success
         and print an error message, otherwise. */
        storeProductViewController.loadProduct(withParameters: parametersDict, completionBlock: { [weak self] (status: Bool, error: Error?) in
          guard let self = self else {return}
            if status {
                self.present(self.storeProductViewController, animated: true, completion: nil)
            } else {
                log.error("Error opening app store: \(error?.localizedDescription ?? "No error provided")")
            }
        })
    }

    func initRootViewController(childAtIndex: CustomTabBar.TabItem) {
        guard let viewControllers = viewControllers else { return }
        let child = viewControllers[childAtIndex.rawValue]
        container.addSubview(child.view)
        child.didMove(toParent: self)
        let childView = child.view
        childView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        childView?.frame = container.bounds
        selectedIndex = childAtIndex
    }

    func handleMinSoftwareVersion() {
        let nowTime = Date().in(region: Region.local)
        if Defaults.optionalPopUpLastSeen != nil {
            guard let lastSeenDate = Defaults.optionalPopUpLastSeen!.toISODate() else {
                return
            }
            let timeSinceLastSeenOptionalPopUpByseconds = nowTime.timeIntervalSince(lastSeenDate)
            let timeSinceLastSeenOptionalPopUpByDays = CGFloat(timeSinceLastSeenOptionalPopUpByseconds / 86400)
            let optionalPopUpDaysTimeInterval = CGFloat(getOptionalPopUpDaysTimeIntervalUseCase.interval())

            // Check Whether its the right time to show the popup
            guard optionalPopUpDaysTimeInterval < timeSinceLastSeenOptionalPopUpByDays else {
                log.info("Time since last seen is smaller than requaired")
                return
            }
        }

        let minSoftwareVersion = getVersionsLimitUseCase.soft()
        let appBundleVersion = ConfigEnvironment.appBundleVersion

        // check whether its the minimum version to show the popup
        guard minSoftwareVersion > appBundleVersion else {
            log.debug("Version is correct")
            return
        }

        // writing to default the last seen popup date
        Defaults.optionalPopUpLastSeen = nowTime.toISO()
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.optionalUpdate, .optionalUpdate))
        showBasicPopup(data: BasicPopupData(
            title: R.string.localizable.updateNewVersionAvailable(),
            subtitle: R.string.localizable.updatePleaseUpdateYourApp(),
            okButton: R.string.localizable.updateUpdateNow(),
            cancelButton: R.string.localizable.dimiss(), type: .optionaUpdate
        ))
    }

    func canceledPermissionDialog() {
        Observable
            .just(())
            .map { _ in Reactor.Action.changedNotificationType }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
}

extension ContainerViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension ContainerViewController: CustomTabBarDelegate {
    func didSelect(tab: CustomTabBar.TabItem) {
        animatePageChange(tab: tab)
        containerHeaderView.setTab(by: tab)
    }

    public func externalPageChange(tab: CustomTabBar.TabItem) {
        guard let tabBar = tabBar else { return }
        tabBar.externalSelectTab(tabItem: tab)
    }

    private func animatePageChange(tab: CustomTabBar.TabItem) {
        animateTabChange(toTab: tab)
    }

    func animateTabChange(toTab: CustomTabBar.TabItem) {
        guard let viewControllers = viewControllers else { return }

        let viewController = viewControllers[toTab.rawValue]
        if let fromView = selectedViewController?.view,
           let toView = viewController.view, fromView != toView,
           let controllerIndex = self.viewControllers?.firstIndex(of: viewController)
        {
            let viewSize = fromView.frame
            let scrollRight = controllerIndex > selectedIndex.rawValue

            // Avoid UI issues when switching tabs fast
            if fromView.superview?.subviews.contains(toView) == true { return }

            fromView.superview?.addSubview(toView)
            fromView.removeFromSuperview()
            if let controllerIndexTabItem = CustomTabBar.TabItem(rawValue: controllerIndex) {
                selectedIndex = controllerIndexTabItem
            }

            let screenWidth = UIScreen.main.bounds.size.width
            toView.frame = CGRect(x: scrollRight ? screenWidth : -screenWidth, y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)

            UIView.animate(withDuration: 0.25, delay: TimeInterval(0.0), options: [.curveEaseOut, .preferredFramesPerSecond60], animations: {
                fromView.frame = CGRect(x: scrollRight ? -screenWidth : screenWidth, y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)
                toView.frame = CGRect(x: 0, y: viewSize.origin.y, width: screenWidth, height: viewSize.size.height)
            }, completion: nil)
        }
    }

    // MARK: - Class func

    class func instantiate(withViewControllers: [UIViewController], selectedIndex: CustomTabBar.TabItem, contractProvider: TermsOfUseProviderProtocol, flowController: MainFlowController, animationProvider: AnimationProvider, reactor: ContainerViewReactor) -> ContainerViewController {
        let vc = R.storyboard.containerViewController.containerViewController()!
        vc.viewControllers = withViewControllers
        vc.selectedIndex = selectedIndex
        vc.contractProvider = contractProvider
        vc.flowController = flowController
        vc.animationProvider = animationProvider
        vc.reactor = reactor
        return vc
    }
}

extension ContainerViewController {
    @objc func showFieldTooltip(notification _: Notification) {
        if !didFieldToolTipOpen {
            didFieldToolTipOpen = true
            tabBar.presentFeedBtnToolTip(superView: self)
        }
    }
}

extension ContainerViewController: HasBasicPopup {
    func basicPopupDismissed(type _: PopupType) {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }

    func basicPopupPositiveClicked(type _: PopupType) {
        presentedViewController?.dismiss(animated: true, completion: {
            self.goToAppStore()
        })
    }

    func basicPopupNegativeClicked(type _: PopupType) {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
