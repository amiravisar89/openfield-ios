//
//  GeoJSONImageViewer.swift
//  Openfield
//
//  Created by Yoni Luz on 19/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import AVKit
import Foundation
import Kingfisher
import KingfisherWebP
import UIKit
import GEOSwift
import RxSwift

class GeoJSONImageViewer : ImageViewer {
    
    var enabledColor: UIColor = R.color.white()!
    var disabledColor: UIColor = (R.color.white()!).withAlphaComponent(0.0)
    var selectedColor: UIColor = R.color.primaryGreen()!
    
    var enabledColorBackground = UIColor.clear
    var disabledColorBackground = R.color.lightGreyOpacity()!
    var selectedColorBackground = (R.color.primaryGreen()!).withAlphaComponent(0.4)
    
    var enabledShapeLineWidth: CGFloat = 2
    var disabledShapeLineWidth: CGFloat = 2

    private let disabledZOrder: CGFloat = 0
    private let enabledZOrder: CGFloat = 1
    private let selectedZOrder: CGFloat = 2

    // publish cellId clicked
    let cellSelected : PublishSubject<Int> = PublishSubject()

    private let enabledPropery = "enabled"
    private let cellIdPropery = "cellId"

    let disposeBag = DisposeBag()
    
    public func drawGeoJson(geoJson: GeoJSON, bounds: ImageBounds) {
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.drawGeoJsonInternal(geoJson: geoJson, bounds: bounds)
        }
    }
    
    public func focus(zoomScale: CGFloat = 2,  animation: Bool) {
        guard !images.isEmpty else { return }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else {
                return
            }
            self.scrollView.setZoomScale(zoomScale, animated: animation)
        }
    }
    
    public func focus(point: CGPoint, scale: CGFloat, animation: Bool = true) {
        let scrollSize = scrollView.frame.size
        let size = CGSize(width: scrollSize.width / scale, height: scrollSize.height / scale)
        let origin = CGPoint(x: point.x - size.width / 2, y: point.y - size.height / 2)
        scrollView.zoom(to: CGRect(origin: origin, size: size), animated: animation)
    }
    
    public func resetSelectedCell() {
        guard !images.isEmpty else { return }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else {
                return
            }
            guard let subLayers = fieldImageView.layer.sublayers else {
                log.warning("There are no sublayers")
                return
            }
            if let selectedShape = subLayers.first(where: { ($0 as! CAShapeLayer).selected}) as? CAShapeLayer {
                setupShape(shape: selectedShape, cellState: .enabled)
            }
        }
    }
    
    private func drawGeoJsonInternal(geoJson: GeoJSON, bounds: ImageBounds) {
        fieldImageView.layer.sublayers?.removeAll()
        let shapes = createShapes(from: geoJson, bounds: bounds)
        for shape in shapes {
            fieldImageView.layer.addSublayer(shape)
        }
    }
    
    public func updateSelectedCellColor(by point: CGPoint) {
        guard let subLayers = fieldImageView.layer.sublayers else {
            log.warning("There are no sublayers")
            return
        }
        let clickedShape = subLayers.compactMap { $0 as? CAShapeLayer }.first { $0.enabled && isPointInsideShapeLayer(point: point, shapeLayer: $0) }
        if let clickedShape = clickedShape, !clickedShape.selected {
            if let selectedShape = subLayers.first(where: { ($0 as! CAShapeLayer).selected}) as? CAShapeLayer {
                setupShape(shape: selectedShape, cellState: .enabled)
            }
            setupShape(shape: clickedShape, cellState: .selected)
            if let cellId = clickedShape.id {
                cellSelected.onNext(cellId)
            }
            focus(point: point, scale: FieldImageViewConstants.focusCellTapZoom)
        }
    }
    
    private func createShapes(from geoJson: GeoJSON,  bounds: ImageBounds) -> [CAShapeLayer] {
        var shapes = [CAShapeLayer]()
        switch geoJson {
        case let .feature(feature):
            let jsonType = feature.properties?["type"]
            shapes += createShape(from: feature, bounds: bounds, type: jsonType)
            
        case let .featureCollection(featureCollection):
            for feature in featureCollection.features {
                let jsonType = feature.properties?["type"]
                shapes += createShape(from: feature, bounds: bounds, type: jsonType)
            }
        default:
            break
        }
        return shapes
    }
    
    private func createShape(from feature: Feature, bounds: ImageBounds, type: JSON?) -> [CAShapeLayer] {
        
        let actualImageSize = CGSize(width: imageSize.width, height: imageSize.height)
        let innerImageRect = AVMakeRect(aspectRatio: actualImageSize, insideRect: fieldImageView.bounds)

        let enabled = feature.properties?[enabledPropery]?.untypedValue as? Bool ?? true
        var cellId: Int? = nil
        if let id = feature.properties?[cellIdPropery]?.untypedValue as? Double {
            cellId = Int(id)
        }
        var shapes = [CAShapeLayer]()
        switch feature.geometry {
        case let .polygon(polygon):
            let extPoints = [polygon.exterior.points]
            let holesPoints = polygon.holes.map { $0.points }
            let polygonsPoints = extPoints + holesPoints
            shapes = polygonsPoints.map { points in
                let shape = createPolygon(by: points, type: type, bounds: bounds, innerImageRect: innerImageRect)
                setupShape(shape: shape, cellState: enabled ? .enabled : .disabled)
                shape.id = cellId
                return shape
            }
        default:
            break
        }
        return shapes
    }
    
    private func createPolygon(by pointsArray: [Point], type: JSON?, bounds: ImageBounds, innerImageRect: CGRect) -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        let path = UIBezierPath()
        
        for (index, point) in pointsArray.enumerated() {
            let normalizedPoint = normalizePoint(geoPoint: point, bounds: bounds, innerImageRect: innerImageRect)
            if index == 0 {
                path.move(to: normalizedPoint)
            } else {
                path.addLine(to: normalizedPoint)
            }
        }
        if type == TypeOfPolygon.Circle.rawValue || type == TypeOfPolygon.Ring.rawValue {
            var copyPath = UIBezierPath()
            copyPath = UIBezierPath(ovalIn: path.bounds)
            copyPath.close()
            shape.path = copyPath.cgPath
        } else {
            path.close()
            shape.path = path.cgPath
        }
        return shape
    }
    
    private func normalizePoint(geoPoint: Point, bounds: ImageBounds, innerImageRect: CGRect)  -> CGPoint{
        
        let vScale = Double(innerImageRect.height) / Double(bounds.boundsTop - bounds.boundsBottom)
        let hScale = Double(innerImageRect.width) / Double(bounds.boundsRight - bounds.boundsLeft)
        
        let x = Double((geoPoint.x - bounds.boundsLeft) * hScale)
        let y = Double((bounds.boundsTop - geoPoint.y) * vScale)
        let point = CGPoint(x: x, y: y)
        
        let pointByViewCoord = sourceToViewCoord(point: point, innerImageRect: innerImageRect)
        return pointByViewCoord
    }
    
    private func sourceToViewCoord(point: CGPoint, innerImageRect: CGRect) -> CGPoint {
        let vpX = Double(innerImageRect.minX) + Double(point.x)
        let vpY = Double(innerImageRect.minY) + Double(point.y)
        return CGPoint(x: vpX, y: vpY)
    }
    
    private func isPointInsideShapeLayer(point: CGPoint, shapeLayer: CAShapeLayer) -> Bool {
        guard let path = shapeLayer.path else {
            return false
        }
        let bezierPath = UIBezierPath(cgPath: path)
        return bezierPath.contains(point)
    }
    
    private func setupShape(shape: CAShapeLayer, cellState: CellState) {
        switch cellState {
        case .disabled:
            shape.lineWidth = disabledShapeLineWidth
            shape.strokeColor = disabledColor.cgColor
            shape.fillColor = disabledColorBackground.cgColor
            shape.zPosition = disabledZOrder
            shape.enabled = false
            break
        case .enabled:
            shape.lineWidth = enabledShapeLineWidth
            shape.strokeColor = enabledColor.cgColor
            shape.fillColor = enabledColorBackground.cgColor
            shape.zPosition = enabledZOrder
            shape.enabled = true
            shape.selected = false
            break
        case .selected:
            shape.strokeColor = selectedColor.cgColor
            shape.fillColor = selectedColorBackground.cgColor
            shape.zPosition = selectedZOrder
            shape.enabled = true
            shape.selected = true
            break
        }
    }

}

enum CellState {
    case disabled
    case enabled
    case selected
}

