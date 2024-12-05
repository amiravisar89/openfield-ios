//
//  LocationInsightViewController.swift
//  Openfield
//
//  Created by Itay Kaplan on 31/12/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import FirebaseAnalytics
import FSPagerView
import NVActivityIndicatorView
import ReactorKit
import Resolver
import RxCocoa
import RxSwift
import UIKit

class LocationInsightViewController: UIViewController, StoryboardView, ShareableVC {
    // MARK: - Outlets

    @IBOutlet var issuesCarusel: FSPagerView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var pageControl: FSPageControl!
    @IBOutlet var fieldImage: LocationsImageViewer!
    @IBOutlet var singleIssue: SingleIssue!
    @IBOutlet var singleIssueTopConstraint: NSLayoutConstraint!
    @IBOutlet var northIcon: UIImageView!
    @IBOutlet var loader: NVActivityIndicatorView!
    @IBOutlet var errorView: UIView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var welcomeMaskViews: [UIView]!
    @IBOutlet var welcomeDisabledInteractionViews: [UIView]!
    @IBOutlet var issueCarruselHeightConstraint: NSLayoutConstraint!
    @IBOutlet var hideGalleryView: UIView!

    // MARK: - Members

    typealias Reactor = LocationInsightReactor
    var disposeBag: DisposeBag = .init()
    private let dateProvider: DateProvider = Resolver.resolve()
    private var singleIssueGalleryImages = [LocationImageMeatadata]()
    private var toolTipManager: WelcomeLocationTooltipScheduler = Resolver.resolve()
    private let feebackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let locationInsightCardProvider: LocationInsightCardProvider = Resolver.resolve()
    private let locationInsightCoordinateProvider: LocationInsightCoordinatesProvider = Resolver.resolve()

    var infoClick: PublishSubject<ControlEvent<UITapGestureRecognizer>.Element?> = PublishSubject()
    var singleIssueImageSelected: PublishSubject<Int> = PublishSubject()
    weak var flowController: MainFlowController?
    
    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    // MARK: - Private

    private func initView() {
        // general
        backgroundView.backgroundColor = R.color.screenBg()!
        loader.startAnimating()
        loader.color = R.color.valleyBrand()!

        // nibs
        issuesCarusel.register(UINib(resource: R.nib.overviewCell), forCellWithReuseIdentifier: R.reuseIdentifier.overviewCell.identifier)
        issuesCarusel.register(UINib(resource: R.nib.singleLocationOverviewCell), forCellWithReuseIdentifier: R.reuseIdentifier.singleLocationOverviewCell.identifier)
        issuesCarusel.register(UINib(resource: R.nib.issueLocationOverviewCell), forCellWithReuseIdentifier: R.reuseIdentifier.issueLocationOverviewCell.identifier)
        issuesCarusel.register(UINib(resource: R.nib.rangedLocationOverviewCell), forCellWithReuseIdentifier: R.reuseIdentifier.rangedLocationOverviewCell.identifier)
        issuesCarusel.register(UINib(resource: R.nib.emptyLocationOverviewCell), forCellWithReuseIdentifier: R.reuseIdentifier.emptyLocationOverviewCell.identifier)
        issuesCarusel.register(UINib(resource: R.nib.enhanceLocationCell), forCellWithReuseIdentifier: R.reuseIdentifier.enhanceLocationCell.identifier)

        issuesCarusel.register(UINib(resource: R.nib.issueCard), forCellWithReuseIdentifier: R.reuseIdentifier.issueCard.identifier)

        // page control
        pageControl.contentHorizontalAlignment = .center
        pageControl.setStrokeColor(R.color.primary(), for: .normal)
        pageControl.setStrokeColor(R.color.primary(), for: .selected)
        pageControl.setFillColor(R.color.primary(), for: .selected)
        issuesCarusel.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.85, height: EnhanceLocationCell.height)
    }

    private func hideLoadingView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.loadingView.alpha = 0
        }
    }

    private func navigateToLocation(url: URL) {
        UIApplication.shared.open(url)
    }

    private func showSingleIssueView() {
        feebackGenerator.impactOccurred()
        animateSingleIssueView(true)
    }

    private func showPin() {
        fieldImage.showPin()
    }

    private func hidePin() {
        fieldImage.hidePin()
    }

    private func hideSingleIssueView() {
        animateSingleIssueView(false)
    }

    private func animateSingleIssueView(_ show: Bool) {
        singleIssue.isHidden = false
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3,
                           animations: { [weak self] in
                               guard let self = self else { return }
                               self.issuesCarusel.alpha = show ? 0 : 1
                               self.pageControl.alpha = show ? 0 : 1
                               self.singleIssueTopConstraint.constant = show ? -self.singleIssue.frame.height : 0
                               self.view.layoutIfNeeded()
                           }) { _ in
                self.singleIssue.isHidden = !show
                guard let reactor = self.reactor,
                      reactor.currentState.showWalkThrough,
                      self.toolTipManager.currentTipStepIndex == 2 else { return }
                self.toolTipManager.showNextTip()
            }
        }
    }

    private func getIssueCell(for pagerView: FSPagerView, at index: Int, with issue: LocationInsightCard) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: issue.getCellIdentifier(), at: index)

        if let overviewCell = cell as? OverviewCell,
           let overviewCard = issue as? OverviewCard
        {
            overviewCell.bind(card: overviewCard, onClick: infoClick)
            overviewCell.accessibilityIdentifier = "overview_cell_\(index)"

            if let emptyOverviewCell = cell as? EmptyLocationOverviewCell,
               let reactor = reactor
            {
                overviewCell.accessibilityIdentifier = "empty_cell_\(index)"
                emptyOverviewCell.button?.rx.tapGesture()
                    .when(.recognized)
                    .map { _ in Reactor.Action.openLocationIssueGallery(imageIndex: 0, sideEffect: self.showSingleIssueView, showPin: self.showPin) }
                    .bind(to: reactor.action)
                    .disposed(by: overviewCell.disposeBag)
            } else if let singleLocationOverviewCell = cell as? SingleLocationOverviewCell {
                singleLocationOverviewCell.accessibilityIdentifier = "empty_cell_\(index)"
                singleLocationOverviewCell.setImageClick(imageSelected: singleIssueImageSelected)
            }
            return overviewCell

        } else if let locationCell = cell as? IssueCard,
                  let enhanceImageCard = issue as? EnhanceLocationImageCard,
                  let reactor = reactor
        {
            locationCell.bind(title: enhanceImageCard.title, info: enhanceImageCard.info, description: "", dotColor: enhanceImageCard.color, image: enhanceImageCard.image, tags: enhanceImageCard.tags, showLoader: enhanceImageCard.showImageLoader, isNightImage: enhanceImageCard.isNightImage)
            locationCell.accessibilityIdentifier = "enhance_image_cell_\(index)"
            locationCell.rx.tapGesture()
                .when(.recognized)
                .map { [weak self] _ in Reactor.Action.openLocationIssueGallery(imageIndex: 0, sideEffect: self?.showSingleIssueView, showPin: self?.hidePin) }
                .bind(to: reactor.action)
                .disposed(by: locationCell.disposeBag)
            return locationCell

        } else if let enhanceCell = cell as? EnhanceLocationCell,
                  let enhanceCard = issue as? EnhanceLocationCard
        {
            enhanceCell.initCell(card: enhanceCard, infoClick: infoClick, imageSelected: singleIssueImageSelected)
            enhanceCell.accessibilityIdentifier = "enhance_cell_\(index)"
            return enhanceCell

        } else if let locationCell = cell as? IssueCard,
                  let locationCard = issue as? IssueLocationCard
        {
            locationCell.bind(title: locationCard.title, info: locationCard.info, description: locationCard.description, dotColor: locationCard.color, image: locationCard.image, tags: locationCard.tags, showLoader: locationCard.showImageLoader, isNightImage: locationCard.isNightImage)
            locationCell.accessibilityIdentifier = "issue_cell_\(index)"
            return locationCell

        } else {
            return FSPagerViewCell()
        }
    }

    private func navigateToTagsImagesViewController(data: TagedImagesViewModel) {
        let vc = TagsImagesViewController.instantiate(data: data)
        if let reactor = reactor {
            vc.imageWillDisplayAtIndex?
                .do { [weak self] index in
                    self?.singleIssue.imagesGallery.goToIndex(index: index)
                }
                .flatMap { index in Observable.concat([
                    Observable.just(Reactor.Action.selectIssueImage(index: index, navigationEffect: nil)),
                    Observable.just(Reactor.Action.analyticsViewLocationImage(imageId: data.tagedImagesViewModel[index].imageId, issueId: data.tagedImagesViewModel[index].issueId, imageIndex: index)),
                ]) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)

            vc.imageZoom.compactMap { $0 }
                .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
                .map { Reactor.Action.analyticsZoomOnLocationImage(imageId: data.tagedImagesViewModel[$0.imageIndex].imageId, issueId: data.tagedImagesViewModel[$0.imageIndex].issueId, imageIndex: $0.imageIndex) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)

            vc.imageNavigation.compactMap { $0 }
                .distinctUntilChanged()
                .map { Reactor.Action.analyticsNavigationToImageLocation(imageId: data.tagedImagesViewModel[$0].imageId, issueId: data.tagedImagesViewModel[$0].issueId, imageIndex: $0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
        flowController?.present(vc, animated: true)
    }

    private func openOverviewInformation(header: String, infoData: [OverviewInformationView.InfoDataElement]) {
        let infoView = OverviewInformationView(frame: view.bounds)
        infoView.bind(header: header, infoData: infoData)
        infoView.alpha = 0
        view.addSubview(infoView)
        UIView.animate(withDuration: 0.3) {
            infoView.alpha = 1
        }
    }

    // MARK: - Bind

    func bind(reactor: LocationInsightReactor) {

        reactor.state.compactMap { $0.locationInsight }.take(1).observeOn(MainScheduler.instance)
            .subscribe { [weak self] insight in
                guard let self = self else { return }
                guard let insight = insight.element else { return }
                if insight is EmptyLocationInsight {
                    self.issuesCarusel.itemSize = CGSize(width: 300, height: EmptyLocationOverviewCell.height)
                    self.issueCarruselHeightConstraint.constant = EmptyLocationOverviewCell.height
                } else if insight is EnhancedLocationInsight || insight is SingleLocationInsight {
                    self.issuesCarusel.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.85, height: EnhanceLocationCell.height)
                    self.issueCarruselHeightConstraint.constant = EnhanceLocationCell.height
                } else {
                    self.issueCarruselHeightConstraint.constant = 200
                    self.issuesCarusel.itemSize = CGSize(width: 300, height: 200)
                }
                self.view.layoutIfNeeded()
            }.disposed(by: disposeBag)

        // MARK: - State
        reactor.state
            .compactMap { $0.locationInsight }
            .take(1)
            .subscribe { [weak self] locationInsight in
                guard let self = self else { return }
                guard let locationInsight = locationInsight.element else { return }
                self.generateAccessibilityIdentifiers(id: locationInsight.uid)
            }.disposed(by: disposeBag)
        Observable.combineLatest(issuesCarusel.rx.didEndDisplayingCell.filter { $0.at == 1 }.delay(.seconds(1), scheduler: MainScheduler.instance).take(1), reactor.state
            .map { $0.showWalkThrough }
            .distinctUntilChanged())
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] _, showWalkThrough in
            self?.welcomeDisabledInteractionViews.forEach {
                $0.isUserInteractionEnabled = !showWalkThrough
            }
            self?.showMasksViews(showWalkThrough)
            if showWalkThrough {
                self?.initWalkthrough()
            }
        }).disposed(by: disposeBag)
        
        reactor.state /* Builds the gallery view for each card */
            .compactMap { ($0.selectedSingleIssueImageIndex, $0.singleIssueGalleryImages, $0.selectedLocationCardIndex, $0.locationInsight, $0.selectedIssueItemIndex) }
            .filter { _, _, selectedLocationCardIndex, locationInsight, _ in
                reactor.singleIssueCardProvider.shouldBuildImagesGallery(forIssueIndex: selectedLocationCardIndex, forInsight: locationInsight)
            }
            .compactMap { selectedIndex, images, cardIndex, locationInsight, issueIndex -> [AppImageGalleyElement]? in
                return reactor.singleIssueCardProvider.provide(forInsight: locationInsight, selectedIndex: selectedIndex, images: images, cardIndex: cardIndex, tagColor: reactor.colorProvider?.getColor(forItemAtIndex: cardIndex - 1, forInsight: locationInsight, locationSelected: nil) ?? R.color.valleyBrand()!, issueIndex: issueIndex)
            }.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] elements in
                self?.singleIssue.bind(imagesElements: elements)
            }).disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.selectedLocation }
            .bind { [weak self] location in
                guard let self = self else { return }
                self.fieldImage.movePin(to: location.id, animation: true)
            }.disposed(by: disposeBag)

        Observable.combineLatest(
            reactor.state.compactMap { $0.pinAlwaysOn }.filter { $0 },
            reactor.state.compactMap { $0.selectedLocation }
        ).observeOn(MainScheduler.instance).subscribe { [weak self] (_,location) in
            self?.showPin()
            self?.fieldImage.movePin(to: location.id, animation: false)
        }.disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.locationInsight }
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] insight in
                guard let self = self else { return }
                self.fieldImage.display(images: insight.coverImage) { [weak self] result in
                    guard let self = self else { return }
                    self.loader.stopAnimating()
                    self.hideLoadingView()
                    switch result {
                    case .success:
                        self.hideLoadingView()
                    case .failure:
                        self.errorView.isHidden = false
                    }
                }
            }).disposed(by: disposeBag)

        reactor.state
            .map { $0.singleIssueGalleryImages }
            .bind { [weak self] gallery in
                self?.singleIssueGalleryImages = gallery
            }.disposed(by: disposeBag)

        // init issuesCarusel
        reactor.state
            .map { (insight: $0.locationInsight, locations: $0.allLocations, isFieldOwner: $0.isFieldOwner) }
            .distinctUntilChanged({ $0 }, comparer: { $0.locations?.count == $1.locations?.count })
            .map { [weak self] insight, locations, isFieldOwner -> [LocationInsightCard] in
                guard let self = self else { return [] }
                return self.locationInsightCardProvider.provide(locationInsight: insight, locations: locations, isFieldOwner: isFieldOwner)
            }
            .do { [weak self] cards in
                self?.pageControl.numberOfPages = cards.count
                self?.pageControl.isHidden = cards.count == 1
            }
            .bind(to: issuesCarusel.rx.items) { [weak self] pagerView, index, card in
                guard let self = self else { return FSPagerViewCell() }
                return self.getIssueCell(for: pagerView, at: index, with: card)
            }.disposed(by: disposeBag)

        // init singleIssue every time selectedLocationIssueIndex changes
        reactor.state
            .map { ($0.locationInsight, $0.selectedIssueItemIndex, $0.selectedLocation) }
            .map { locationInsight, itemIndex, selectedLocation -> SingleIssueViewModel? in
                let singleIssueColor = reactor.colorProvider?.getColor(forItemAtIndex: itemIndex, forInsight: locationInsight, locationSelected: selectedLocation) ?? R.color.valleyBrand()
                return reactor.singleIssueCardProvider.provide(forInsight: locationInsight, locationSelected: selectedLocation, forItemIndex: itemIndex, withColor: singleIssueColor!)
            }
            .compactMap { $0 }
            .observeOn(MainScheduler.instance)
            .bind { [weak self] singleIssue in
                guard let self = self else { return }
                if let _ = singleIssue as? SingleLocationIssueViewModel {
                    self.singleIssue.shouldFocuseOntitle = false
                } else if let _ = singleIssue as? SingleLocationEnhancedViewModel {
                    self.singleIssue.shouldFocuseOntitle = true
                }
                self.singleIssue.title.text = singleIssue.title
                self.singleIssue.info.text = singleIssue.info
                self.singleIssue.dotView.backgroundColor = singleIssue.color
            }
            .disposed(by: disposeBag)

        // dots on map
        reactor.state
            .map { ($0.locationInsight, $0.allLocations, $0.selectedLocationCardIndex) }
            .compactMap {  self.locationInsightCoordinateProvider.provide(locationInsight: $0, locations: $1, index: $2)
            }
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] locations in
                guard let self = self,
                let cardLocations = locations.element else { return }
                self.fieldImage.drawLocations(locations: cardLocations)
            }.disposed(by: disposeBag)

        singleIssue.imagesGallery.indexSelected.observeOn(MainScheduler.instance)
            .do { [weak self] index in self?.singleIssue.imagesGallery.goToIndex(index: index, animated: true) }
            .map { [weak self] index in
                LocationInsightReactor.Action.selectIssueImage(index: index, navigationEffect: self?.navigateToTagsImagesViewController)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        singleIssue.imagesGallery.didEndDecelerating
            .map {
                LocationInsightReactor.Action.selectIssueImage(index: $0, navigationEffect: nil)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        singleIssue.backButton.rx.tapGesture()
            .when(.recognized)
            .do { [weak self] _ in
                guard let self = self, self.singleIssueGalleryImages.count > 0 else { return }
                self.singleIssue.imagesGallery.goToIndex(index: 0, animated: false)
            }
            .map { [weak self] _ in Reactor.Action.closeLocationIssueGallery(sideEffect: self?.hideSingleIssueView, hidePin: self?.hidePin) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        issuesCarusel.rx.itemSelected
            .filter { index in index != .zero } // without OverviewCell
            .map { [weak self] _ in Reactor.Action.openLocationIssueGallery(imageIndex: 0, sideEffect: self?.showSingleIssueView, showPin: self?.showPin) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        singleIssueImageSelected
            .map { [weak self] index in Reactor.Action.openLocationIssueGallery(imageIndex: index, sideEffect: self?.showSingleIssueView, showPin: self?.showPin) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        singleIssueImageSelected.observeOn(MainScheduler.instance).subscribe { [weak self] index in
            self?.singleIssue.imagesGallery.goToIndex(index: index, animated: false)
        }.disposed(by: disposeBag)

        issuesCarusel.rx.willEndDragging
            .flatMap { Observable.concat([
                Observable.just(Reactor.Action.selectCard(index: $0)),
                Observable.just(Reactor.Action.analyticsClickIssueCard(issueIndex: $0)),
            ]) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        issuesCarusel.rx.willEndDragging
            .bind { [weak self] index in self?.pageControl.currentPage = index }
            .disposed(by: disposeBag)

        // Actions
        fieldImage.imageDidZoom.subscribe { [weak self] zoomScale in
            guard let self = self else { return }
            guard let scale = zoomScale.element else { return }
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.northIcon.alpha = scale > FieldImageViewerConstants.minimumZoomScale ? 0 : 1
            }
        }.disposed(by: disposeBag)

        hideGalleryView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.hideSingleIssueView()
            }).disposed(by: disposeBag)

        fieldImage.singleTap
            .subscribe { [weak self] _ in
                self?.hideSingleIssueView()
            }.disposed(by: disposeBag)

        infoClick.map { [weak self] _ in Reactor.Action.openOverviewInfo(sideEffect: self?.openOverviewInformation) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Walkthrough functions

extension LocationInsightViewController {
    private func showMasksViews(_ show: Bool) {
        welcomeMaskViews.forEach {
            $0.backgroundColor = R.color.black60()!
            $0.isHidden = !show
        }
        if show {
            fieldImage.addBlackMaskLayer()
        } else {
            fieldImage.removeBlackMaskLayer()
        }
    }

    private func initWalkthrough() {
        guard let firstItemCell = issuesCarusel.cellForItem(at: 1) as? IssueCard else { return }
        toolTipManager.initWalkthrough(withSteps: [
            WelcomeLocationTooltipScheduler.Tip(text: R.string.localizable.insightWelcomeReportOverviewShows(), view: issuesCarusel),
            WelcomeLocationTooltipScheduler.Tip(text: R.string.localizable.insightWelcomeScrollBetweenCards(), view: firstItemCell.dot),
            WelcomeLocationTooltipScheduler.Tip(text: R.string.localizable.insightWelcomeClickOnCardShowSampleImagery(), view: issuesCarusel),
            WelcomeLocationTooltipScheduler.Tip(text: R.string.localizable.insightWelcomeImageGalleryTooltipSelectImageToViewtFullScreen(), view: singleIssue.imagesGallery),
        ])
        toolTipManager.showNextTip()
        guard let reactor = reactor else { return }
        // observe when tip did number 0 or 1 did hide
        toolTipManager.state
            .map { $0.stepDidHideAtIndex }
            .distinctUntilChanged()
            .filter { $0 == 0 || $0 == 1 }
            .bind { [weak self] _ in self?.toolTipManager.showNextTip() }
            .disposed(by: disposeBag)

        // observe when tip number 2 did hide
        toolTipManager.state
            .map { $0.stepDidHideAtIndex }
            .distinctUntilChanged()
            .filter { $0 == 2 }
            .map { [weak self] _ in Reactor.Action.openLocationIssueGallery(imageIndex: 0, sideEffect: self?.showSingleIssueView, showPin: self?.showPin) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // observe when tip number 3 did hide
        toolTipManager.state
            .map { $0.stepDidHideAtIndex }
            .distinctUntilChanged()
            .filter { $0 == 3 }
            .map { [weak self] _ in Reactor.Action.selectIssueImage(index: 0, navigationEffect: self?.navigateToTagsImagesViewController) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // observe when tip number 2 will appear
        toolTipManager.state
            .map { $0.stepWillBeDisplayAtIndex }
            .distinctUntilChanged()
            .filter { $0 == 2 }
            .do { [weak self] _ in self?.issuesCarusel.scrollToItem(at: 1, animated: true) }
            .map { _ in Reactor.Action.selectCard(index: 1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
