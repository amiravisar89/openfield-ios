//
//  FieldImageViewConstants.swift
//  Openfield
//
//  Created by Omer Cohen on 1/5/20.
//  Copyright © 2020 Prospera. All rights reserved.
//

import GEOSwift
import UIKit

enum FieldImageViewConstants {
    // scrollV
    static let minimumZoomScale: CGFloat = 1.0
    static let maximumZoomScale: CGFloat = 10.0
    static let zoomScale: CGFloat = 1
    static let doubleTapZoom: CGFloat = 5.0
    static let focusCellTapZoom: CGFloat = 3.0

    // cloudIcon
    static let cloudButtonWidth: CGFloat = 90
    static let cloudButtonHeight: CGFloat = 23
    static let cloudButtonOffsetTop: CGFloat = 20
    static let cloudButtonOffsetRight: CGFloat = -17

    // northIcon
    static let northIconWidth: CGFloat = 24
    static let northIconHeight: CGFloat = 24
    static let northIconOffsetTop: CGFloat = 20

    // imageFieldV
    static let imageFieldViewOffsetLeftAndRight = 40

    // eyeIconView
    static let eyeIconViewWidth = 50
    static let eyeIconViewHeight = 50
    static let eyeIconViewOffsetRight = 20
    static let eyeIconViewOffsetBottom: CGFloat = 24

    // eyeIconImage
    static let eyeIconImageWidth = 24
    static let eyeIconImageHeight = 24

    // colorBarView
    static let colorBarViewWidth = 240
    static let colorBarViewHeight: CGFloat = 60
    static let colorBarViewOffsetTop = 45
    static let colorBarViewOffsetLeft = 24

    // compareLegendViewVisible
    static let compareLegendViewVisibleOffsetLeft: CGFloat = 10
    static let compareLegendViewVisibleOffsetBottom: CGFloat = 100
    static let compareLegendViewVisibleOffsetTop: CGFloat = 100
    static let compareLegendViewVisibleWidth: CGFloat = 60

    // legendViewVisible
    static let legendViewVisibleOffsetTop: CGFloat = 24
    static let legendViewVisibleOffsetBottom: CGFloat = 22

    // layerName
    static let layerNameOffsetTop: CGFloat = 8

    // questionMarkIcon
    static let questionMarkIconWidth: CGFloat = 23
    static let questionMarkIconHeight: CGFloat = 23
    static let questionMarkIconOffsetTop: CGFloat = 5
    static let questionMarkIconOffsetLeft: CGFloat = 2

    // colorScaleBarView
    static let colorScaleBarViewHeight = 6
    static let colorScaleBarViewOffsetTop = 6

    // compareMinimumLabel
    static let compareMinimumLabelOffsetTop = 4

    // minimumLabel
    static let minimumLabelOffsetTop = 4

    // maxsimumLabel
    static let maxsimumLabelOffsetTop = 4

    // calculationFieldImageView
    static let minimumBottomConstraintInitialStickyPointOffset: CGFloat = 160
    static let minimumIphone8ScreenHeight: CGFloat = 667

    // layerGradient
    static let layerGradientCornerRadius: CGFloat = 3.5
    static let layerGradientStartPoint: CGPoint = .init(x: 0, y: 0.5)
    static let layerGradientEndPoint: CGPoint = .init(x: 1, y: 0.5)

    // compareLayerGradient
    static let compareLayerGradientCornerRadius: CGFloat = 3.5
    static let compareLayerGradientStartPoint: CGPoint = .init(x: 0.5, y: 1)
    static let compareLayerGradientEndPoint: CGPoint = .init(x: 0.5, y: 0)

    // shapeLineWidth
    static let shapeLineWidth: CGFloat = 1.2

    // pinImage
    static let locationPinImageWidth: CGFloat = 20
    static let locationPinImageHeight: CGFloat = 26

    static let dotStrokeSize: CGFloat = 1.2

    // shapeOpacity
    static let shapeOpacity: Float = 1

    // insightPageError
    static let titleErrorInsetRightAndLeft: CGFloat = 71
    static let titleErrorInsetTop: CGFloat = 229
    static let contentErrorInsetRightAndLeft: CGFloat = 71
    static let contentErrorInsetTop: CGFloat = 7
    static let reloadErrorButtonWidth: CGFloat = 158
    static let reloadErrorButtonHeight: CGFloat = 50
    static let reloadErrorButtonInsertRightAndLeft: CGFloat = 108
    static let reloadErrorButtonInsertTop: CGFloat = 14
    static let reloadErrorButtonCornerRadius: CGFloat = 2.0
    static let reloadErrorButtonBorderWidth: CGFloat = 1
    static let loadingIndicatorErrorWidthAndHeight: CGFloat = 20
    static let loadingIndicatorErrorTop: CGFloat = 9

    // This variable affects the size and location on the image of the polygon. Actually it’s a location radius of the field. And when we increase number - polygon region radius will be smaller, and when decrease number - polygon region radius will be bigger.
    // Reference from Apple documentation: A distance measurement (measured in meters) from an existing location
    // Reference StackOverflow:  https://stackoverflow.com/a/41640054/7030696
    static let regionRadius: Double = 900
}

enum TypeOfPolygon: JSON {
    case Polygon = "Polygon"
    case Ring = "Ring"
    case Circle = "Circle"
    case Box = "Box"
    case FreeHand = "FreeHand"
    case Geometry = "geometry"
}
