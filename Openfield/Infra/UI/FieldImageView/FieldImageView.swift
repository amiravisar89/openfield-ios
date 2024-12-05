//
//  FieldImageView.swift
//  Openfield
//
//  Created by amir avisar on 14/10/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import CoreLocation
import Foundation
import GEOSwift
import Kingfisher
import KingfisherWebP
import MapKit
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import UIKit

protocol FieldImageViewProtocol {
    func display(image: (String, String), imageId: Int, bounds: ImageBounds, type: AppImageType, issue: Issue?, sourceType: ImageSourceType)
    func showTag(id: Int, data: GeoJSON, color: UIColor)
    func hideTag(id: Int)
    func setConstraints(margin: CGFloat)
}

protocol FieldImageViewDelegate: AnyObject {
    func scrollViewDidScroll(scrollView: UIScrollView)
    func scrollViewDidTapZoom(scrollView: UIScrollView, toRect: CGRect)
}

class FieldImageView: UIView {
    // MARK: - Observables

    public var doubleTap: Observable<UITapGestureRecognizer>!
    public var singleTap: Observable<UITapGestureRecognizer>!

    // MARK: - Outlets

    @IBOutlet var northIcon: UIImageView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet var cloudButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var fieldImageView: UIView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var fieldImage: UIImageView!
    @IBOutlet var eyeButton: UIButton!
    @IBOutlet var layerNameLabel: UILabel!
    @IBOutlet var minLabel: UILabel!
    @IBOutlet var maxLabel: UILabel!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var compareLegendView: UIView!
    @IBOutlet var compareLegendMaxLabel: UILabel!
    @IBOutlet var compareLegendMinLabel: UILabel!
    @IBOutlet var compareGradientView: UIView!
    @IBOutlet var legendView: UIView!
    @IBOutlet var insightPageError: UIView!
    @IBOutlet var loadingTextLabel: UILabel!
    @IBOutlet var loadingIndicatorView: UIView!
    @IBOutlet var loadingIndicator: NVActivityIndicatorView!
    @IBOutlet var titleErrorLabel: UILabel!
    @IBOutlet var subtitleErrorLabel: UILabel!
    @IBOutlet var reloadButton: UIButton!
    @IBOutlet var errorView: UIView!
    @IBOutlet var compareLegendViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet var layerIcon: UIImageView!
    @IBOutlet var legendInfoView: UIView!
    @IBOutlet var legendViewBottomConstraint: NSLayoutConstraint?
    @IBOutlet var northIconTopConstraint: NSLayoutConstraint?
    @IBOutlet var legendViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet var eyeBottomConstraint: NSLayoutConstraint?
    @IBOutlet var cloudButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var imageTypeLabel: CaptionRegularPrimary!
    @IBOutlet var imageTypeImage: UIImageView!
    @IBOutlet var imagetypeView: UIView!

    // MARK: - Members

    private var toolTipManager = ToolTipManager()
    private var tooltipTimer: Timer = .init()
    private var isShowTags: Bool = true
    public weak var delegate: FieldImageViewDelegate?
    private var tagsDictionary = [Int: FieldImageTagData]()
    var typeImage: AppImageType?
    var sourceTypeImage: ImageSourceType?
    private var imageId: Int!
    private var currentZoomScale: CGFloat = 1
    private var largeImageUrl: URL?
    private var lowImageUrl: URL?
    private let layerGradient = CAGradientLayer()
    private let compareLayerGradient = CAGradientLayer()
    private var issue: Issue?
    private var didLoadLargeImage: Bool = false
    private var didReportZoom: Bool = false
    var analyticsImageId: String {
        return String(imageId ?? -1)
    }

    private var hasActiveTags: Bool {
        for tag in tagsDictionary.values {
            if !tag.hidden {
                return true
            }
        }
        return false
    }

    private var imageBounds: ImageBounds = .init(boundsLeft: 0, boundsBottom: 0, boundsRight: 0, boundsTop: 0)

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setUpStaticColor()
        setUpScrollView()
        setUpQA()
        setupUI()
        setupStaticText()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    // MARK: - Private

    private func setupView() {
        UINib(resource: R.nib.fieldImageView).instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        forQA()
    }

    private func forQA() {
        imageTypeLabel.accessibilityIdentifier = "image_type"
    }

    private func setUpStaticColor() {
        loadingIndicator.color = R.color.valleyBrand()!
        insightPageError.backgroundColor = R.color.screenBg()!
        compareLegendMaxLabel.textColor = R.color.secondary()
        compareLegendMaxLabel.textColor = R.color.secondary()
        loadingTextLabel.textColor = R.color.primary()
        maxLabel.textColor = R.color.secondary()
        minLabel.textColor = R.color.secondary()
        layerNameLabel.textColor = R.color.primary()
    }

    private func setupStaticText() {
        compareLegendMaxLabel.text = R.string.localizable.imageLayerDataThermalLegendEnd()
        compareLegendMinLabel.text = R.string.localizable.imageLayerDataThermalLegendEnd()
        loadingTextLabel.text = R.string.localizable.loading()
        titleErrorLabel.text = R.string.localizable.feedOops()
        subtitleErrorLabel.text = R.string.localizable.feedSomethingWrongTryReload()
        reloadButton.setTitle(R.string.localizable.feedReload(), for: .normal)
        loadingTextLabel.text = R.string.localizable.loading()
        cloudButton.setTitle(R.string.localizable.insightCloudy(), for: .normal)
    }

    private func setUpScrollView() {
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = FieldImageViewConstants.minimumZoomScale
        scrollView.maximumZoomScale = FieldImageViewConstants.maximumZoomScale
        scrollView.zoomScale = FieldImageViewConstants.zoomScale
        scrollView.bounces = false
        scrollView.bouncesZoom = false
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.canCancelContentTouches = true
        scrollView.isUserInteractionEnabled = true
        scrollView.isMultipleTouchEnabled = true
        scrollView.clipsToBounds = false
        scrollView.autoresizesSubviews = true
    }

    private func setUpQA() {
        legendView.accessibilityTraits = [.button]
        legendView.accessibilityIdentifier = "FieldImageLayerGuideButton" // QA
        compareLegendView.accessibilityTraits = [.button]
        compareLegendView.accessibilityIdentifier = "CompareFieldImageLayerGuideButton" // QA
    }

    private func setupUI() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageDoubleTapped(gestureRecognizer:)))
        let singleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.numberOfTapsRequired = 2
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.require(toFail: doubleTapGesture)
        fieldImageView.addGestureRecognizer(doubleTapGesture)
        fieldImageView.addGestureRecognizer(singleTapGesture)

        doubleTap = contentView
            .rx
            .gesture(doubleTapGesture)
            .when(.recognized)

        singleTap = contentView
            .rx
            .gesture(singleTapGesture)
            .when(.recognized)

        loadingIndicator.startAnimating()
        loadingIndicatorView.isHidden = false
    }

    private func drawColorMapGradient(colorArray: [CGColor]) {
        layerGradient.colors = colorArray
        layerGradient.startPoint = FieldImageViewConstants.layerGradientStartPoint
        layerGradient.endPoint = FieldImageViewConstants.layerGradientEndPoint
        layerGradient.cornerRadius = FieldImageViewConstants.layerGradientCornerRadius
        layerGradient.frame = gradientView.bounds
        gradientView.layer.addSublayer(layerGradient)
    }

    private func reloadLowResolutionImage() {
        showPageError(isShow: true)
        loadingIndicator.startAnimating()
        loadingIndicatorView.isHidden = false
        loadLowResolutionImage()
    }

    private func showPageError(isShow: Bool) {
        errorView.isHidden = isShow
    }

    private func setLowResolutionImage(image: UIImage) {
        didLoadLargeImage = false
        fieldImage.image = image
    }

    private func loadLowResolutionImage() {
        guard let lowImageUrl = lowImageUrl else {
            log.warning("Low image url is nil")
            return
        }
        let start = DispatchTime.now()
        KingfisherManager.shared.retrieveImage(with: lowImageUrl) { [weak self] result in
            switch result {
            case let .success(value):
                self?.insightPageError?.isHidden = true
                self?.loadingIndicator?.stopAnimating()
                self?.setLowResolutionImage(image: value.image)
                let end = DispatchTime.now()
                let elapsedTime = (end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000 // in ms
                EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.imageViewer, .smallImageLoaded, [EventParamKey.value: "\(elapsedTime)",
                                                                                                                          EventParamKey.imageId: self?.analyticsImageId ?? "0",
                                                                                                                          EventParamKey.imageUrl: self?.lowImageUrl?.absoluteString ?? "0"]))
            case let .failure(error):
                self?.insightPageError?.isHidden = false
                self?.showPageError(isShow: false)
                self?.loadingIndicator?.stopAnimating()
                self?.loadingIndicatorView?.isHidden = true
                EventTracker.track(event: AnalyticsEventFactory.buildErrorEvent(EventCategory.imageViewer,
                                                                                error.localizedDescription, [EventParamKey.imageId: self?.analyticsImageId ?? "0",
                                                                                                             EventParamKey.imageUrl: self?.lowImageUrl?.absoluteString ?? "0"]))
                log.error("KingFisher error: \(error)")
            }
        }
    }

    private func loadHighResolutionImage() {
        guard let largeImageUrl = largeImageUrl, !didLoadLargeImage else {
            log.warning("Large image url is nil")
            return
        }
        let start = DispatchTime.now()

        didLoadLargeImage = true

        KingfisherManager.shared.retrieveImage(with: largeImageUrl) { [weak self] result in
            switch result {
            case let .success(value):
                guard let self = self else { return }
                self.fieldImage?.image = value.image
                let end = DispatchTime.now()
                let elapsedTime = (end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000 // in ms
                EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.imageViewer,
                                                                           .bigImageLoaded,
                                                                           [EventParamKey.value: "\(elapsedTime)",
                                                                            EventParamKey.imageId: self.analyticsImageId,
                                                                            EventParamKey.imageUrl: self.lowImageUrl?.absoluteString ?? "0"]))
            case let .failure(error):
                log.error("KingFisher error: \(error)")
                self?.didLoadLargeImage = false
            }
        }
    }

    private func setupMap() {
        // Map is hidden
        mapView.alpha = 0

        // Get center of the field by four points
        let centerCoordinate = getFieldCenterCoordinateBy(top: imageBounds.boundsTop, right: imageBounds.boundsRight, bottom: imageBounds.boundsBottom, left: imageBounds.boundsLeft)

        // Setting the bounds of an MKMapView
        setMapBounds(lon: Double(centerCoordinate.longitude), lat: Double(centerCoordinate.latitude))
    }

    private func getFieldCenterCoordinateBy(top: Double, right: Double, bottom: Double, left: Double) -> CLLocationCoordinate2D {
        let longitude = (left + right) / 2
        let latitude = (top + bottom) / 2
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // MARK: - Map

    private func setMapBounds(lon: Double, lat: Double) {
        let initialLocation = CLLocation(latitude: lat, longitude: lon)
        centerMapOnLocation(location: initialLocation)
    }

    private func centerMapOnLocation(location: CLLocation) {
        // left buttom corner
        let bottomLeftCoordinate = CLLocation(latitude: imageBounds.boundsBottom, longitude: imageBounds.boundsLeft)

        // right buttom corner
        let bottomRightCoordinate = CLLocation(latitude: imageBounds.boundsBottom, longitude: imageBounds.boundsRight)

        // right buttom corner
        let topLeftCoordinate = CLLocation(latitude: imageBounds.boundsTop, longitude: imageBounds.boundsLeft)

        let sideDistance = bottomLeftCoordinate.distance(from: topLeftCoordinate)
        let bottomDistance = bottomLeftCoordinate.distance(from: bottomRightCoordinate)
        // A rectangular geographic region centered around a specific latitude and longitude.
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: sideDistance, longitudinalMeters: bottomDistance)

        // Changes the currently visible region and optionally animates the change
        mapView.setRegion(coordinateRegion, animated: false)
    }

    // MARK: - Polygon drawing

    private func drawGeoJson(geoJSON: GeoJSON, pathColor: UIColor) -> [CAShapeLayer] {
        var shapes = [CAShapeLayer]()
        switch geoJSON {
        case let .feature(feature):
            if let jsonType = feature.properties?["type"] {
                shapes += drawFeature(feature: feature, pathColor: pathColor, type: jsonType)
            }
        case let .featureCollection(featureCollection):
            for feature in featureCollection.features {
                if let jsonType = feature.properties?["type"] {
                    shapes += drawFeature(feature: feature, pathColor: pathColor, type: jsonType)
                }
            }
        default:
            break
        }
        return shapes
    }

    private func drawFeature(feature: Feature, pathColor: UIColor, type: JSON) -> [CAShapeLayer] {
        var shapes = [CAShapeLayer]()
        switch feature.geometry {
        case let .polygon(polygon):
            let extPoints = polygon.exterior.points
            let holes = polygon.holes
            let shape = drawPolygonByPoints(pointsArray: extPoints, pathColor: pathColor, type: type)
            shapes.append(shape)
            for hole in holes {
                let holePoints = hole.points
                let shape = drawPolygonByPoints(pointsArray: holePoints, pathColor: pathColor, type: type)
                shapes.append(shape)
            }
        default:
            break
        }
        return shapes
    }

    // Creation path of the line that renders in the view
    private func drawPolygonByPoints(pointsArray: [Point], pathColor: UIColor, type: JSON) -> CAShapeLayer {
        let shape = CAShapeLayer()
        fieldImage.layer.addSublayer(shape)
        setupShape(shape: shape, with: pathColor)

        let path = UIBezierPath()
        let firstPoint = pointsArray[0]
        move(path: path, to: firstPoint)
        for point in pointsArray {
            addLine(path: path, to: point)
        }
        if type == TypeOfPolygon.Circle.rawValue || type == TypeOfPolygon.Ring.rawValue {
            var copyPath = UIBezierPath()
            // Take the bounds from the real path polygon to draw a circle
            copyPath = UIBezierPath(ovalIn: path.bounds)
            copyPath.close()
            shape.path = copyPath.cgPath
        } else {
            path.close()
            shape.path = path.cgPath
        }
        return shape
    }

    private func setupShape(shape: CAShapeLayer, with pathColor: UIColor) {
        shape.opacity = FieldImageViewConstants.shapeOpacity
        shape.lineWidth = FieldImageViewConstants.shapeLineWidth
        shape.strokeColor = pathColor.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = FieldImageViewConstants.shapeLineWidth / CGFloat(scrollView.zoomScale)
    }

    private func convertGeoPointToViewPoint(point: Point) -> CGPoint {
        let coordinate = CLLocationCoordinate2D(latitude: point.y, longitude: point.x)
        let pointInImage: CGPoint = mapView.convert(coordinate, toPointTo: fieldImage)
        return pointInImage
    }

    private func move(path: UIBezierPath, to geoPoint: Point) {
        let point = convertGeoPointToViewPoint(point: geoPoint)
        path.move(to: point)
    }

    private func addLine(path: UIBezierPath, to geoPoint: Point) {
        let point = convertGeoPointToViewPoint(point: geoPoint)
        path.addLine(to: point)
    }

    private func setLegendViewDetails(type: AppImageType, sourceType: ImageSourceType) {
        // Fill legend details
        let didFitType = (issue?.issue == .clouds || issue?.issue == .shadow)
        let isCloudHidden = issue?.isHidden ?? true
        cloudButton.isHidden = !(isCloudHidden == false && didFitType == true)
        maxLabel.text = type.maxLabel()
        minLabel.text = type.minLabel()
        compareLegendMaxLabel.text = type.maxLabel()
        compareLegendMinLabel.text = type.minLabel()
        drawColorMapGradient(colorArray: type.colorMap())
        drawCompareColorMapGradient(colorArray: type.colorMap())
        gradientView.isHidden = type == .rgb
        compareGradientView.isHidden = type == .rgb
        legendView.isHidden = false
        legendView.isHidden = scrollView.zoomScale != FieldImageViewConstants.minimumZoomScale
        compareLegendView.isHidden = scrollView.zoomScale != FieldImageViewConstants.minimumZoomScale
        imagetypeView.isHidden = scrollView.zoomScale != FieldImageViewConstants.minimumZoomScale
        setLayerNameLabel(byImageSourceType: sourceType, withImageType: type)
        setLayerIcon(byImageSourceType: sourceType)
    }

    private func drawCompareColorMapGradient(colorArray: [CGColor]) {
        compareLayerGradient.colors = colorArray
        compareLayerGradient.startPoint = FieldImageViewConstants.compareLayerGradientStartPoint
        compareLayerGradient.endPoint = FieldImageViewConstants.compareLayerGradientEndPoint
        compareLayerGradient.cornerRadius = FieldImageViewConstants.compareLayerGradientCornerRadius
        compareLayerGradient.frame = compareGradientView.bounds
        compareGradientView.layer.addSublayer(compareLayerGradient)
    }

    private func handleNorthIcon(isCompare: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.northIcon?.alpha = isCompare ? 0 : 1
        }
    }

    public func showAllTags(show: Bool) {
        for tag in tagsDictionary.values {
            for shape in tag.shapes {
                if !tag.hidden {
                    shape.isHidden = !show
                }
            }
        }
        isShowTags = show
        eyeButton.setImage(show ? R.image.showTag() : R.image.hideTag(), for: .normal)
    }

    private func setLayerNameLabel(byImageSourceType sourceType: ImageSourceType, withImageType type: AppImageType) {
        layerNameLabel.text = "\(sourceType.name()) / \(type.name())"
        imageTypeLabel.text = "\(sourceType.name())"
    }

    private func setLayerIcon(byImageSourceType sourceType: ImageSourceType) {
        layerIcon.image = sourceType == ImageSourceType.satellite ? R.image.satelite_black() : R.image.airplane_black()
        imageTypeImage.image = sourceType == ImageSourceType.satellite ? R.image.satelite_black() : R.image.airplane_black()
    }

    // MARK: - Public

    public func getScrollView() -> UIScrollView {
        return scrollView
    }

    public func resetZoom() {
        DispatchQueue.main.async {
            self.scrollView.zoom(to: CGRect(origin: CGPoint(x: 0, y: 0), size: self.fieldImageView.frame.size), animated: true)
        }
    }

    public func handleCompare(isCompare: Bool) {
        handleNorthIcon(isCompare: isCompare)
        handleLegend(isCompare: isCompare)
        eyeBottomConstraint?.constant = isCompare ? 20 : 10
        legendViewHeightConstraint?.constant = isCompare ? 20 : 50
        compareLegendViewBottomConstraint?.constant = isCompare ? 0 : 400
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.layoutIfNeeded()
        }
    }

    private func handleLegend(isCompare: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.legendView.alpha = isCompare ? 0 : 1
            self?.compareLegendView.alpha = isCompare ? 1 : 0
            self?.imagetypeView.alpha = isCompare ? 1 : 0
        }
    }

    @objc func hideFieldToolTip() {
        toolTipManager.dismissAllTipViews()
    }

    // MARK: - Actions

    @IBAction func reloadAction(_: Any) {
        EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.imageViewer, "image_error_reload"))
        reloadLowResolutionImage()
    }

    @IBAction func cloudAction(_: Any) {
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.cloudIndication, .cloudIndicationButtonClick))
        toolTipManager.openTipView(text: R.string.localizable.insightCloudTipText(), forView: cloudButton, superView: self)
        tooltipTimer.invalidate()
        tooltipTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hideFieldToolTip), userInfo: nil, repeats: false)
    }

    @IBAction func eyeAction(_: Any) {
        EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.imageViewer, "image_tags_toggle", [EventParamKey.toggleAction: !isShowTags ? "on" : "off",
                                                                                                                         EventParamKey.tagsCount: "\(tagsDictionary.count)"]))
        showAllTags(show: !isShowTags)
    }
}

extension FieldImageView: FieldImageViewProtocol {
    /*
     * This method must be called before calling display() to position the image correctly within the containing view.
     **/
    public func setConstraints(margin: CGFloat) {
        legendViewBottomConstraint?.constant = margin + 10
        eyeBottomConstraint?.constant = margin + 10
        layoutIfNeeded()
    }

    public func toggleImageTypeLabel(show: Bool) {
        imagetypeView.isHidden = !show
    }

    public func moveCloudbutton() {
        cloudButtonLeadingConstraint.priority = .defaultLow
        layoutIfNeeded()
    }

    public func display(image: (String, String), imageId: Int, bounds: ImageBounds, type: AppImageType, issue: Issue?, sourceType: ImageSourceType) {
        lowImageUrl = URL(string: image.0)
        largeImageUrl = URL(string: image.1)
        self.issue = issue
        self.imageId = imageId
        loadLowResolutionImage()
        imageBounds = bounds
        typeImage = type
        sourceTypeImage = sourceType
        setupMap()
        setLegendViewDetails(type: type, sourceType: sourceType)
        computeEyeButtonVisibility()
    }

    public func removeAllTagsLayers() {
        tagsDictionary = [Int: FieldImageTagData]()
        fieldImage.layer.sublayers?.forEach { layer in
            if layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        }
    }

    public func showTag(id: Int, data: GeoJSON, color: UIColor) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let tag = self.tagsDictionary[id] {
                for shape in tag.shapes {
                    self.fieldImage.layer.addSublayer(shape)
                    shape.isHidden = false
                }
                self.tagsDictionary[id] = tag
            } else {
                let shapes = self.drawGeoJson(geoJSON: data, pathColor: color)
                let tag = FieldImageTagData(tagId: id, hidden: false, data: data, color: color, shapes: shapes)
                self.tagsDictionary[id] = tag
            }
            self.showAllTags(show: self.isShowTags)
            self.computeEyeButtonVisibility()
        }
    }

    private func computeEyeButtonVisibility() {
        if !hasActiveTags {
            eyeButton.isHidden = true
        } else {
            eyeButton.isHidden = false
        }
    }

    public func hideTag(id: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if var tag = self.tagsDictionary[id] {
                tag.hidden = true
                for shape in tag.shapes {
                    shape.isHidden = true
                }
                self.tagsDictionary[id] = tag
            }
            self.computeEyeButtonVisibility()
        }
    }
}

extension FieldImageView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView: scrollView)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let zoomScale: CGFloat = scrollView.zoomScale
        let lineWidth: CGFloat = calculatePolygonLineWidth()

        if zoomScale == 1 && zoomScale != currentZoomScale {
            didReportZoom = false
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.imageViewer,
                                                                       .imageZoomReset, [EventParamKey.imageId: analyticsImageId]))
        }

        shouldShowNorthIndicationAndLegendView(shouldShow: zoomScale <= 1)

        if zoomScale > 1 {
            loadHighResolutionImage()
        }

        updateTagsLineWidth(lineWidth: lineWidth)

        if !didReportZoom && zoomScale > 1 {
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.imageViewer,
                                                                       .imageZoom, [EventParamKey.imageId: analyticsImageId]))
            didReportZoom = true
        }
        delegate?.scrollViewDidScroll(scrollView: scrollView)
        currentZoomScale = zoomScale
    }

    private func updateTagsLineWidth(lineWidth: CGFloat) {
        for tag in tagsDictionary.values {
            for shape in tag.shapes {
                shape.lineWidth = lineWidth
            }
        }
    }

    func viewForZooming(in _: UIScrollView) -> UIView? {
        return fieldImageView
    }

    private func calculatePolygonLineWidth() -> CGFloat {
        let zoomScale = Int(round(scrollView.zoomScale))
        let lineWidth: CGFloat = FieldImageViewConstants.shapeLineWidth / CGFloat(zoomScale)
        return lineWidth
    }

    private func shouldShowNorthIndicationAndLegendView(shouldShow: Bool) {
        legendView.isHidden = !shouldShow
        compareLegendView.isHidden = !shouldShow
        imagetypeView.isHidden = !shouldShow
        northIcon.isHidden = !shouldShow
    }

    @objc func imageDoubleTapped(gestureRecognizer: UITapGestureRecognizer) {
        let scale = FieldImageViewConstants.doubleTapZoom

        var trackZoom = ""
        if scrollView.zoomScale == FieldImageViewConstants.minimumZoomScale || scrollView.zoomScale < FieldImageViewConstants.doubleTapZoom {
            if scale != scrollView.zoomScale {
                let point = gestureRecognizer.location(in: fieldImageView)

                let scrollSize = scrollView.frame.size
                let size = CGSize(width: scrollSize.width / scale,
                                  height: scrollSize.height / scale)
                let origin = CGPoint(x: point.x - size.width / 2,
                                     y: point.y - size.height / 2)
                delegate?.scrollViewDidTapZoom(scrollView: scrollView, toRect: CGRect(origin: origin, size: size))
                scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
                trackZoom = "in"
            }
        } else {
            delegate?.scrollViewDidTapZoom(scrollView: scrollView, toRect: CGRect(origin: CGPoint(x: 0, y: 0), size: fieldImageView.frame.size))
            scrollView.zoom(to: CGRect(origin: CGPoint(x: 0, y: 0), size: fieldImageView.frame.size), animated: true)
            trackZoom = "out"
        }
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.imageViewer,
                                                                   .imageDoubleTapped, [EventParamKey.imageId: analyticsImageId,
                                                                                        EventParamKey.zoom: trackZoom]))
    }
}
