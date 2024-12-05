//
//  LayerGuideViewController.swift
//  Openfield
//
//  Created by Itay Kaplan on 07/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import FSPagerView
import RxCocoa
import RxSwift
import UIKit

class LayerGuideViewController: UIViewController {
    @IBOutlet var pagerView: FSPagerView!
    @IBOutlet var gotItButton: SGButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var pageControl: FSPageControl!
    @IBOutlet var viewBackground: UIView!

    private var pagerSize: CGSize = .init(width: 0, height: 0)
    private let layerGuideCellMargin: CGFloat = 36
    private var imageTypes: [AppImageType] = [AppImageType.thermal, AppImageType.ndvi, AppImageType.rgb]
    private var disposeBag = DisposeBag()
    private var indexPage = 0
    private var firstSetup = false
    public var imageType: AppImageType!
    public var imageSourceType: ImageSourceType!
    private let url = URL(string: "https://www.valleyirrigation.com/insights/faq")

    override func viewDidLoad() {
        super.viewDidLoad()
        setImagesTypes(byImageSourceType: imageSourceType)
        setupPageControl()
        setupPagerView()
        setupView()
        setupStaticColor()
        EventTracker.track(event: AnalyticsEventFactory.buildDialogEvent(EventCategory.layersWalkthrough, "layers_walkthrough_dialog", true))
    }

    private func setImagesTypes(byImageSourceType sourceType: ImageSourceType) {
        imageTypes = sourceType == .satellite ? [AppImageType.ndvi, AppImageType.rgb] :
            [AppImageType.thermal, AppImageType.ndvi, AppImageType.rgb]
    }

    private func setupStaticColor() {
        viewBackground.backgroundColor = R.color.screenBg()!
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let currentSize = pagerView.bounds.size
        if currentSize != pagerSize {
            let height = Int(pagerView.frame.size.height)
            let width = Int(pagerView.frame.width - (2 * layerGuideCellMargin))
            pagerView.itemSize = CGSize(
                width: width,
                height: height
            )
            pagerSize = currentSize
        }
    }

    private func onGotItClick(_: UITapGestureRecognizer? = nil) {
        dismiss(animated: true)
    }

    private func setupView() {
        gotItButton.titleString = R.string.localizable.thanksGotIt()
        gotItButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                EventTracker.track(event: AnalyticsEventFactory.buildDialogEvent(EventCategory.layersWalkthrough, "layers_walkthrough_dialog", false, [EventParamKey.origin: "button"]))
                self.onGotItClick()
            })
            .disposed(by: disposeBag)
    }

    private func setupPagerView() {
        pagerView.register(UINib(resource: R.nib.layerGuideCell), forCellWithReuseIdentifier: R.reuseIdentifier.layerGuideCell.identifier)

        pagerView.dataSource = self
        pagerView.delegate = self
    }

    private func setupPageControl() {
        pageControl.setStrokeColor(R.color.primary(), for: .normal)
        pageControl.setStrokeColor(R.color.primary(), for: .selected)
        pageControl.setFillColor(R.color.primary(), for: .selected)

        pageControl.numberOfPages = imageTypes.count
        pageControl.contentHorizontalAlignment = .center
    }

    private func getIndexPageByType(type: AppImageType) -> Int {
        for (index, element) in imageTypes.enumerated() {
            if type == element {
                pageControl.currentPage = index
                return index
            }
        }
        // default
        return 0
    }
}

extension LayerGuideViewController: FSPagerViewDataSource {
    func numberOfItems(in _: FSPagerView) -> Int {
        return imageTypes.count
    }

    func pagerView(_: FSPagerView, willDisplay _: FSPagerViewCell, forItemAt _: Int) {
        guard !firstSetup else { return }
        pagerView.scrollToItem(at: getIndexPageByType(type: imageType), animated: false)
        firstSetup = true
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.layerGuideCell.identifier, at: index) as! LayerGuideCell

        let layerGuideCellInput: LayerGuideCellInput = getLayerGuideCell(imageType: imageTypes[index])
        cell.setLayerGuideCell(layerGuideCellInput: layerGuideCellInput)
        cell.learnMore.addTapGestureRecognizer {
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.layersWalkthrough, .textLinkClick, [EventParamKey.itemId: "layers_walkthrough_learn_more"]))
            self.openLink()
        }

        return cell
    }

    private func getLayerGuideCell(imageType: AppImageType) -> LayerGuideCellInput {
        switch imageType {
        case .thermal:
            return LayerGuideCellInput(layerImage: R.image.layer_guide_thermal()!,
                                       layerName: AppImageType.thermal.name(),
                                       colorMapImage: R.image.layer_guide_thermal_color_map()!,
                                       colorMapLowValue: AppImageType.thermal.minLabel(),
                                       colorMapHighValue: AppImageType.thermal.maxLabel(),
                                       layerExplanation: R.string.localizable.imageLayerDataThermalInfo2Lines(),
                                       learnMore: R.string.localizable.learnMore())

        case .ndvi:
            return LayerGuideCellInput(layerImage: R.image.layer_guide_ndvi()!,
                                       layerName: AppImageType.ndvi.name(),
                                       colorMapImage: R.image.layer_guide_ndvi_color_map()!,
                                       colorMapLowValue: AppImageType.ndvi.minLabel(),
                                       colorMapHighValue: AppImageType.ndvi.maxLabel(),
                                       layerExplanation: R.string.localizable.imageLayerDataNdviInfo2Lines(),
                                       learnMore: R.string.localizable.learnMore())

        case .rgb:
            return LayerGuideCellInput(layerImage: R.image.layer_guide_rgb()!,
                                       layerName: AppImageType.rgb.name(),
                                       layerExplanation: R.string.localizable.imageLayerDataRgbInfo2Lines(),
                                       learnMore: R.string.localizable.learnMore())
        }
    }

    private func openLink() {
        if let url = url {
            UIApplication.shared.open(url)
        }
    }
}

extension LayerGuideViewController: FSPagerViewDelegate {
    func pagerViewWillEndDragging(_: FSPagerView, targetIndex: Int) {
        guard pageControl.currentPage != targetIndex else { return }
        let direction: String = targetIndex > pageControl.currentPage ? "right" : "left"
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.layersWalkthrough, .carouselMove, [EventParamKey.direction: direction]))
        pageControl.currentPage = targetIndex
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.layersWalkthrough, .carouselItemShown, [EventParamKey.carouselItem: "\(imageTypes[targetIndex])"]))
    }
}

extension LayerGuideViewController {
    class func instantiate() -> LayerGuideViewController {
        return R.storyboard.layerGuideViewController.layerGuideViewController()!
    }
}
