//
//  LocationsImageViewer.swift
//  Openfield
//
//  Created by amir avisar on 10/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import AVKit
import Foundation
import Kingfisher
import KingfisherWebP
import UIKit

class LocationsImageViewer: ImageViewer {
    // MARK: - Members

    var locationsDic = [Int: CAShapeLayer]()
    var pinImage = UIImageView()
    var pinLocationId: Int?
    private var maskLayer: CALayer?
    
    @IBInspectable var dotWidth: CGFloat = 8


    // MARK: Override

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpPinImage()
    }

    // MARK: Public

    public func drawLocations(locations: [LocationCoordinateViewModel]) {
        clearDots()
        drawPoints(coordinatesArray: locations)
    }

    // MARK: Public Pin related

    public func hidePin() {
        pinImage.isHidden = true
    }

    public func showPin() {
        pinImage.isHidden = false
    }

    public func addBlackMaskLayer() {
        guard maskLayer == nil else { return }
        pinImage.removeFromSuperview()
        maskLayer = CALayer()
        maskLayer?.backgroundColor = R.color.black60()!.cgColor
        fieldImageView.layer.addSublayer(maskLayer!)
        layoutIfNeeded()
        maskLayer?.frame = bounds
        setUpPinImage()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        maskLayer?.frame = bounds
    }

    public func removeBlackMaskLayer() {
        maskLayer?.removeFromSuperlayer()
    }

    public func movePin(to locationId: Int, animation: Bool) {
        pinLocationId = locationId
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else {
                return
            }
            guard let pinDestinationLayer = self.locationsDic[locationId] else {
                log.warning("Location dictionary is empty")
                return
            }
            guard let path = pinDestinationLayer.path else {
                log.warning("Location path is nil")
                return
            }
            self.fieldImageView.bringSubviewToFront(self.pinImage)
            UIView.animate(withDuration: animation ? 0.3 : 0) { [weak self] in
                guard let self = self else {
                    return
                }
                let locationLayerFrame = self.fieldImageView.convert(path.boundingBox, to: self.fieldImageView)
                self.pinImage.center.x = locationLayerFrame.center.x
                self.pinImage.frame.origin.y = locationLayerFrame.minY - self.pinImage.bounds.height
            }
        }
    }

    // MARK: Override

    override func onViewDidZoom(zoomScale: CGFloat) {
        updateDotSize(dotSize: calculateDotWidth(zoomScale: zoomScale))
        guard let locationSelected = pinLocationId else {
            return
        }
        pinImage.frame.size = calculatePinSize()
        movePin(to: locationSelected, animation: false)
    }

    // MARK: Private

    func clearDots() {
        locationsDic.values.forEach { $0.removeFromSuperlayer() }
        locationsDic = [Int: CAShapeLayer]()
    }

    private func drawPoints(coordinatesArray: [LocationCoordinateViewModel]) {
        dispatchGroup.enter()
        coordinatesArray.forEach { coordinate in
            guard let point = getCoordinatePoint(latitude: coordinate.latitude, longitude: coordinate.longitude) else {
                return
            }
            let dotWidth = calculateDotWidth(zoomScale: self.scrollView.zoomScale)
            let dotPath = UIBezierPath(ovalIn: CGRect(x: Double(point.x - (dotWidth / 2)), y: Double(point.y - (dotWidth / 2)), width: Double(dotWidth), height: Double(dotWidth)))
            let layer = CAShapeLayer()
            layer.path = dotPath.cgPath
            layer.fillColor = coordinate.color.cgColor
            layer.lineWidth = calculateStrokeSize(zoomScale: self.scrollView.zoomScale)
            locationsDic[coordinate.id] = layer
            fieldImageView.layer.addSublayer(layer)
        }
        dispatchGroup.leave()
    }

    private func getCoordinatePoint(latitude: Double, longitude: Double) -> CGPoint? {
        guard let bounds = imageBounds else {
            return nil
        }

        let innerImageRect = AVMakeRect(aspectRatio: imageSize, insideRect: fieldImageView.bounds)
        let vScale = Double(imageSize.height) / (bounds.boundsTop - bounds.boundsBottom)
        let hScale = Double(imageSize.width) / (bounds.boundsRight - bounds.boundsLeft)

        let imageVScale = Double(imageSize.height) / Double(innerImageRect.height)
        let imageHScale = Double(imageSize.width) / Double(innerImageRect.width)

        let vpX = (longitude - bounds.boundsLeft) * hScale / imageHScale + Double(innerImageRect.minX)
        let vpY = (bounds.boundsTop - latitude) * vScale / imageVScale + Double(innerImageRect.minY)

        return CGPoint(x: vpX, y: vpY)
    }

    private func setUpPinImage() {
        pinImage.image = R.image.locationPinIcon()!
        pinImage.isHidden = true
        pinImage.contentMode = .scaleAspectFit
        pinImage.frame.size = CGSize(width: FieldImageViewConstants.locationPinImageWidth, height: FieldImageViewConstants.locationPinImageHeight)
        fieldImageView.addSubview(pinImage)
        // Set clipsToBounds to false to prevent from the pinImage to be cropped if its on the egde.
        fieldImageView.clipsToBounds = false
    }

    private func updateDotSize(dotSize: CGFloat) {
        guard let subLayers = fieldImageView.layer.sublayers else {
            log.warning("Threre are no tags")
            return
        }

        subLayers.forEach {
            guard let layer = $0 as? CAShapeLayer,
                  let path = layer.path else { return }

            let dotPath = UIBezierPath(ovalIn: CGRect(origin: path.boundingBox.origin, size: CGSize(width: dotSize, height: dotSize)))
            layer.path = dotPath.cgPath
            layer.lineWidth = calculateStrokeSize(zoomScale: self.scrollView.zoomScale)
        }
    }

    private func calculatePinSize() -> CGSize {
        return CGSize(width: FieldImageViewConstants.locationPinImageWidth / scrollView.zoomScale, height: FieldImageViewConstants.locationPinImageHeight / scrollView.zoomScale)
    }

    private func calculateDotWidth(zoomScale: CGFloat) -> CGFloat {
        let dotWidth: CGFloat = dotWidth / zoomScale
        return dotWidth
    }

    private func calculateStrokeSize(zoomScale: CGFloat) -> CGFloat {
        let dotWidth: CGFloat = FieldImageViewConstants.dotStrokeSize / zoomScale
        return dotWidth
    }
}
