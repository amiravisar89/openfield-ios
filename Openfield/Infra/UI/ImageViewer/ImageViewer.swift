//
//  ImageViewer.swift
//  Openfield
//
//  Created by amir avisar on 06/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import AVKit
import Foundation
import Kingfisher
import KingfisherWebP
import RxCocoa
import RxGesture
import RxSwift
import UIKit

class ImageViewer: UIView {
    // MARK: - Observables

    public var doubleTap: Observable<UITapGestureRecognizer>!
    public var singleTap: Observable<UITapGestureRecognizer>!
    public var imageDidZoom: BehaviorSubject<CGFloat>!

    // MARK: - Outlets

    @IBOutlet var contentView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var fieldImageView: UIImageView!

    // MARK: - ImageViewConstraints

    @IBOutlet var imageRightConst: NSLayoutConstraint!
    @IBOutlet var imageBottomConst: NSLayoutConstraint!
    @IBOutlet var imageLeftConst: NSLayoutConstraint!
    @IBOutlet var imageTopConst: NSLayoutConstraint!

    // MARK: - Statics

    static let maxRetryCount = 3
    static let imageDownloadRetryInterval: TimeInterval = 3

    // MARK: - Inspectable

    @IBInspectable var fitContentInset: Bool = false

    @IBInspectable var imageContentMode: UIView.ContentMode = .scaleAspectFit {
        didSet {
            fieldImageView.contentMode = imageContentMode
        }
    }


    // MARK: - Members

    private let disposeBag = DisposeBag()
    let dispatchGroup = DispatchGroup()
    var imageBounds: ImageBounds?
    var didSwitchImages = false
    var images: [AppImage] = []
    var imageSize: CGSize {
        if images.count == 1 {
            return images[0].imageSize
        }
        return images.last?.imageSize ?? .zero
    }

    var shoulSwitchImages = true

    var reportZoomEvent = true

    // MARK: - override

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    public func setImage(image: UIImage?) {
        fieldImageView.image = image
    }

    // MARK: - Public

    public func setMargins(right: CGFloat = 0, left: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        imageRightConst.constant = right
        imageBottomConst.constant = bottom
        imageLeftConst.constant = left
        imageTopConst.constant = top
        layoutIfNeeded()
    }

    public func cancelDownloadTask() {
        fieldImageView.kf.cancelDownloadTask()
    }
    
    public func disableZoom() {
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1
    }

    public func display(images: [AppImage], imageTransition: ImageTransition = ImageTransition.fade(1), placeholder: Placeholder? = nil, completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        guard !images.isEmpty, let firstImage = images.first, let lastImage = images.last else {
            completionHandler?(.failure(KingfisherError.imageSettingError(reason: .emptySource)))
            return
        }
        self.images = images.sorted { $0.width < $1.width }
        imageBounds = (lastImage as? SpatialImage)?.bounds

        guard let imageUrl = URL(string: firstImage.url) else {
            completionHandler?(.failure(KingfisherError.imageSettingError(reason: .emptySource)))
            return
        }
        fieldImageView.kf.setImage(maxRetry: ImageViewer.maxRetryCount, retryInterval: ImageViewer.imageDownloadRetryInterval, with: imageUrl, placeholder: placeholder, options: [.transition(imageTransition)],  completionHandler: { result in
            guard let completionHandler = completionHandler else { return }
            completionHandler(result)
        })
    }

    public func displayWithObserver(images: [AppImage], imageTransition: ImageTransition = ImageTransition.fade(1), placeholder: Placeholder? = nil) -> Observable<Result<RetrieveImageResult, KingfisherError>> {
        return Observable.create { [weak self] observer in
            self?.display(images: images, imageTransition: imageTransition, placeholder: placeholder) { result in
                switch result {
                case .success:
                    observer.onNext(result)
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    // MARK: Private

    private func setupView() {
        UINib(resource:
            R.nib.imageViewer).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        setUpScrollView()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageDoubleTapped(gestureRecognizer:)))
        let singleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.numberOfTapsRequired = 2
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.require(toFail: doubleTapGesture)
        contentView.addGestureRecognizer(doubleTapGesture)
        contentView.addGestureRecognizer(singleTapGesture)

        imageDidZoom = BehaviorSubject(value: scrollView.zoomScale)

        doubleTap = contentView
            .rx
            .gesture(doubleTapGesture)
            .when(.recognized)

        singleTap = contentView
            .rx
            .gesture(singleTapGesture)
            .when(.recognized)
    }

    private func setupUI() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageDoubleTapped(gestureRecognizer:)))
        tapRecognizer.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(tapRecognizer)
    }

    private func setUpScrollView() {
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = FieldImageViewConstants.minimumZoomScale
        scrollView.maximumZoomScale = FieldImageViewConstants.maximumZoomScale
        scrollView.zoomScale = FieldImageViewConstants.zoomScale
        scrollView.canCancelContentTouches = true

        scrollView.rx.didZoom.throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).subscribe { _ in
            if self.reportZoomEvent {
                EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.insight, .insightZoomed, [:]))
            }
        }.disposed(by: disposeBag)
    }

    func onViewDidZoom(zoomScale _: CGFloat) {}

    @objc func imageDoubleTapped(gestureRecognizer: UITapGestureRecognizer) {
        let scale = FieldImageViewConstants.doubleTapZoom
        if scrollView.zoomScale == FieldImageViewConstants.minimumZoomScale || scrollView.zoomScale < FieldImageViewConstants.doubleTapZoom {
            if scale != scrollView.zoomScale {
                let point = gestureRecognizer.location(in: fieldImageView)
                // Create the actual image rect size
                let innerImageRect = AVMakeRect(aspectRatio: imageSize, insideRect: fieldImageView.bounds)
                // verify user touch the actual image and not outside the image bounds
                guard innerImageRect.contains(point) else { return }
                let scrollSize = scrollView.frame.size
                let size = CGSize(width: scrollSize.width / scale, height: scrollSize.height / scale)
                let origin = CGPoint(x: point.x - size.width / 2, y: point.y - size.height / 2)
                scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
            }
        } else {
            scrollView.zoom(to: CGRect(origin: CGPoint(x: 0, y: 0), size: fieldImageView.frame.size), animated: true)
        }
    }
}

extension ImageViewer: UIScrollViewDelegate {
    // MARK: - Internal

    func viewForZooming(in _: UIScrollView) -> UIView? {
        return fieldImageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        onViewDidZoom(zoomScale: scrollView.zoomScale)
        imageDidZoom?.onNext(scrollView.zoomScale)
        if fitContentInset { adjustZoom(scrollView: scrollView, imageView: fieldImageView) }
        if !shoulSwitchImages || didSwitchImages || images.count == 1 { return }
        didSwitchImages = true

        guard let imageUrl = URL(string: images.last!.url) else {
            return
        }

        KingfisherManager.shared.retrieveImage(with: imageUrl) { [weak self] result in
            switch result {
            case let .success(value):
                self?.fieldImageView.image = value.image
            case let .failure(error):
                log.error("KingFisher error: \(error)")
            }
        }
    }
}

extension ImageViewer {
    private func adjustZoom(scrollView: UIScrollView, imageView: UIImageView) {
        guard scrollView.zoomScale > 1 else {
            scrollView.contentInset = .zero
            return
        }

        guard let image = imageView.image else { return }

        let ratioW = imageView.frame.width / image.size.width
        let ratioH = imageView.frame.height / image.size.height

        let ratio = ratioW < ratioH ? ratioW : ratioH

        let newWidth = image.size.width * ratio
        let newHeight = image.size.height * ratio

        let left = 0.5 * (newWidth * scrollView.zoomScale > imageView.frame.width ? (newWidth - imageView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
        let top = 0.5 * (newHeight * scrollView.zoomScale > imageView.frame.height ? (newHeight - imageView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))

        scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
    }
}
