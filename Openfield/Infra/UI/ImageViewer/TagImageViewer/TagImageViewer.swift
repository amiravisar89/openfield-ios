//
//  TagImageViewer.swift
//  Openfield
//
//  Created by amir avisar on 11/01/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import AVKit
import Foundation
import Kingfisher
import KingfisherWebP
import UIKit

class TagImageViewer: ImageViewer {
    // MARK: Public

    public func drawTags(tags: [LocationTag], color: UIColor) {
        guard !tags.isEmpty else { return }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.DrawTags(tags: tags, color: color)
        }
    }

    public func focus(animation: Bool) {
        guard !images.isEmpty else { return }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else {
                return
            }
            self.scrollView.setZoomScale(2, animated: animation)
        }
    }

    public func clearTags() {
        fieldImageView.layer.sublayers?.removeAll()
    }

    // MARK: Private

    private func DrawTags(tags: [LocationTag], color: UIColor) {
        dispatchGroup.enter()
        let imagesSize = imageSize

        let actualImageSize = CGSize(width: imagesSize.width, height: imagesSize.height)
        let innerImageRect = AVMakeRect(aspectRatio: actualImageSize, insideRect: fieldImageView.bounds)

        let imageVScale = Double(imagesSize.height) / Double(innerImageRect.height)
        let imageHScale = Double(imagesSize.width) / Double(innerImageRect.width)

        tags.forEach { tag in
            guard !tag.points.isEmpty else {
                log.warning("Tag is empty")
                return
            }
            let shape = CAShapeLayer()
            shape.opacity = FieldImageViewConstants.shapeOpacity
            shape.lineWidth = FieldImageViewConstants.shapeLineWidth
            shape.lineJoin = CAShapeLayerLineJoin.miter
            shape.strokeColor = color.cgColor
            shape.fillColor = UIColor.clear.cgColor
            let path = UIBezierPath()
            guard let firstPoint = tag.points[0] else { return }
            let firstPointVpX = Double(innerImageRect.minX) + Double(firstPoint.x) / imageHScale
            let firstPointVpY = Double(innerImageRect.minY) + Double(firstPoint.y) / imageVScale
            path.move(to: CGPoint(x: firstPointVpX, y: firstPointVpY))
            tag.points.forEach { point in
                guard let tagPoint = point else { return }
                let vpX = Double(innerImageRect.minX) + Double(tagPoint.x) / imageHScale
                let vpY = Double(innerImageRect.minY) + Double(tagPoint.y) / imageVScale
                path.addLine(to: CGPoint(x: vpX, y: vpY))
            }
            path.close()
            shape.path = path.cgPath
            fieldImageView.layer.addSublayer(shape)
        }
        dispatchGroup.leave()
    }

    private func calculatePolygonLineWidth(zoomScale: CGFloat) -> CGFloat {
        let lineWidth: CGFloat = FieldImageViewConstants.shapeLineWidth / zoomScale
        return lineWidth
    }

    private func updateTagsLineWidth(lineWidth: CGFloat) {
        guard let subLayers = fieldImageView.layer.sublayers else {
            log.warning("Threre are no tags")
            return
        }
        for shape in subLayers {
            if shape is CAShapeLayer {
                (shape as! CAShapeLayer).lineWidth = lineWidth
            }
        }
    }

    override func onViewDidZoom(zoomScale: CGFloat) {
        updateTagsLineWidth(lineWidth: calculatePolygonLineWidth(zoomScale: zoomScale))
    }
}
