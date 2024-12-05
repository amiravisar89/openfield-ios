//
//  TagsImagesViewController.swift
//  Openfield
//
//  Created by amir avisar on 12/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import AVKit
import EasyTipView
import FirebaseAnalytics
import Foundation
import GEOSwift
import Resolver
import RxSwift
import SwiftDate
import UIKit

class TagsImagesViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pinchLabel: BodyRegularWhite!
    @IBOutlet var subtitleLabel: BodyRegularWhite!
    @IBOutlet var leftArrow: UIButton!
    @IBOutlet var rightArrow: UIButton!
    @IBOutlet var navigateToLocationBtn: UIButton!
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet weak var nightStack: UIStackView!
    @IBOutlet weak var nightLabel: Title10RegularWhite!
    
    // MARK: Constraints

    @IBOutlet var pinchTopCons: NSLayoutConstraint!

    // MARK: Members

    var indexSelected: Int!
    var onceOnly = false
    var data: TagedImagesViewModel!

    let disposeBag = DisposeBag()
    var imageWillDisplayAtIndex: BehaviorSubject<Int>? = nil
    let tooltipManager: ToolTipManager = Resolver.resolve()
    let dateProvider: DateProvider = Resolver.resolve()
    var tooltipDidAppear = false
    var imageZoom: BehaviorSubject<(zoomScale: CGFloat, imageIndex: Int)?> = BehaviorSubject(value: nil)
    var imageNavigation: BehaviorSubject<Int?> = BehaviorSubject(value: nil)

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if data.showNavigationTip && !tooltipDidAppear {
            showNavigateTooltip()
            tooltipDidAppear = true
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Private

    private func setupUI() {
        pinchLabel.text = R.string.localizable.insightPinchToZoom()
        nightLabel.text = R.string.localizable.nightImage()
        navigateToLocationBtn.setTitle(R.string.localizable.insightNavigateToLocation(), for: .normal)
        navigateToLocationBtn.backgroundColor = R.color.valleyBrand()
        setupArrows(forIndex: indexSelected)
        setAccesabilties()
    }

    private func setAccesabilties() {
        pinchLabel.accessibilityIdentifier = "pinch"
        subtitleLabel.accessibilityIdentifier = "subtitle"
        leftArrow.accessibilityIdentifier = "left_arrow"
        rightArrow.accessibilityIdentifier = "right_arrow"
        navigateToLocationBtn.accessibilityIdentifier = "navigate_location_btn"
        closeBtn.accessibilityIdentifier = "close_btn"
    }

    private func showNavigateTooltip() {
        tooltipManager.openTipView(text: R.string.localizable.insightNavigationToImageLocation(), forView: navigateToLocationBtn, superView: view)
    }

    private func setDateLabel(date: DateInRegion) {
        subtitleLabel.text = dateProvider.format(date: date.date, region: date.region, format: .shortHourTimeZone)
    }

    private func initCollectionView() {
        collectionView.register(UINib(nibName: R.nib.issueTagImageViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.issueTagImageViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func alignPinchAndStackView(imageSize: CGSize) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            let actualImageSize = CGSize(width: imageSize.width, height: imageSize.height)
            let innerImageRect = AVMakeRect(aspectRatio: actualImageSize, insideRect: self.collectionView.bounds)
            self.pinchTopCons.constant = innerImageRect.maxY + FieldImageViewerConstants.locationImagePopupPinchMarginTop
            self.view.layoutIfNeeded()
        }
    }

    private func setupArrows(forIndex index: Int) {
        guard data.tagedImagesViewModel.count > 1 else {
            leftArrow.isHidden = true
            rightArrow.isHidden = true
            return
        }
        // hide right arrow if we reached the end of gallery
        rightArrow.isHidden = index == data.tagedImagesViewModel.count - 1
        // hide left arrow if we reached the start of the gallery
        leftArrow.isHidden = index == 0
    }

    // MARK: - Actions

    @IBAction private func closeAction(_: Any) {
        dismiss(animated: true)
    }

    @IBAction func rightArrowAction(_: Any) {
        guard data.tagedImagesViewModel.indices.contains(indexSelected + 1) == true else {
            log.warning("Index out of bounds")
            return
        }
        collectionView.scrollToItem(at: IndexPath(row: indexSelected + 1, section: 0), at: .right, animated: true)
    }

    @IBAction private func leftArrowAction(_: Any) {
        guard data.tagedImagesViewModel.indices.contains(indexSelected - 1) == true else {
            log.warning("Index out of bounds")
            return
        }
        collectionView.scrollToItem(at: IndexPath(row: indexSelected - 1, section: 0), at: .right, animated: true)
    }

    @IBAction private func navigationAction(_: Any) {
        guard data.insight?.uid != WelcomeInsightsIds.locationInsight.rawValue else {
            showNavigateTooltip()
            return
        }
        imageNavigation.onNext(indexSelected)
        guard let url = data.tagedImagesViewModel[indexSelected].onClickUrl else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - CollectionView

extension TagsImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return data.tagedImagesViewModel.count
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
            collectionView.scrollToItem(at: IndexPath(row: indexSelected, section: 0), at: .right, animated: false)
            onceOnly = true
        }
        indexSelected = indexPath.row
        pinchLabel.alpha = 1
        setDateLabel(date: data.tagedImagesViewModel[indexPath.row].date)
        (cell as! TagImageViewCell).tagImage.imageDidZoom.subscribe { [unowned self] zoomScale in
            guard let scale = zoomScale.element else { return }
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.pinchLabel.alpha = scale > FieldImageViewerConstants.minimumZoomScale ? 0 : 1
            }
            imageZoom.onNext((zoomScale: scale, imageIndex: indexSelected))
        }.disposed(by: disposeBag)

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {
                return
            }
            self.alignPinchAndStackView(imageSize: (cell as! TagImageViewCell).tagImage.imageSize)
        }
        nightStack.isHidden = !data.tagedImagesViewModel[indexPath.row].isNightImage
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.issueTagImageViewCell.identifier, for: indexPath as IndexPath) as! TagImageViewCell
        cell.accessibilityIdentifier = "tags_image_cell\(indexPath.row)"
        cell.bind(images: data.tagedImagesViewModel[indexPath.row].images, color: data.issueColor, tags: data.tagedImagesViewModel[indexPath.row].tags, showMore: false, isNightImage: false)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    // Executed after scrolling triggered by clicking on arrows ends
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        onScrollingEnd(scrollView)
    }

    // Executed after scrolling triggered by swiping ends
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        onScrollingEnd(scrollView)
    }

    fileprivate func onScrollingEnd(_: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) {
            imageWillDisplayAtIndex?.onNext(visibleIndexPath.row)
            setupArrows(forIndex: visibleIndexPath.row)
            navigateToLocationBtn.isHidden = !(data.tagedImagesViewModel[visibleIndexPath.row].onClickUrl != nil)
        }
    }
}

// MARK: - Instantiate

extension TagsImagesViewController {
    class func instantiate(data: TagedImagesViewModel) -> TagsImagesViewController {
        let vc = R.storyboard.tagsImagesViewController.tagsImagesViewController()!
        vc.data = data
        vc.indexSelected = data.initialIndex
        vc.imageWillDisplayAtIndex = BehaviorSubject(value: data.initialIndex)
        
        let tagedImageViewModel = data.tagedImagesViewModel[data.initialIndex]
        // Analytics Screen View
        let screenViewParams = [AnalyticsParameterScreenName: ScreenName.imageViewer,
                                AnalyticsParameterScreenClass: String(describing: TagsImagesViewController.self),
                                EventParamKey.category: EventCategory.field,
                                EventParamKey.fieldId: tagedImageViewModel.fieldId,
                                EventParamKey.farmId: tagedImageViewModel.farmId as Any,
                                EventParamKey.cycleId: tagedImageViewModel.cycleId as Any,
                                EventParamKey.imageId: tagedImageViewModel.imageId,

        ] as [String : Any]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
        return vc
    }
}

struct TagedImagesViewModel {
    let issueColor: UIColor
    let name: String
    let insight: LocationInsight?
    let initialIndex: Int
    let tagedImagesViewModel: [TagedImageViewModel]
    let showNavigationTip: Bool
}

struct TagedImageViewModel {
    let fieldId: Int
    let farmId: Int?
    let cycleId: Int?
    let imageId: Int
    let context: String
    let issueId: Int
    let images: [AppImage]
    let onClickUrl: URL?
    let date: DateInRegion
    let tags: [LocationTag]
    let isNightImage : Bool
}
