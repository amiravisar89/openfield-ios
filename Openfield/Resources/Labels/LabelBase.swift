//
//  LabelBase.swift
//  Openfield
//
//  Created by Daniel Kochavi on 26/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

open class SGLabelStyleBase: SGStyleableLabel {
    private var internalAlignment: NSTextAlignment = .center

    @IBInspectable open var alignment: String = "left" {
        didSet {
            if alignment == "center" {
                internalAlignment = .center
            } else if alignment == "left" {
                internalAlignment = .left
            } else if alignment == "right" {
                internalAlignment = .right
            } else if alignment == "natural" {
                internalAlignment = .natural
            }
            applyTextStyle()
        }
    }

    override open var text: String? {
        didSet {
            applyTextStyle()
        }
    }

    @IBInspectable open var customLineSpacing: CGFloat = 0 {
        didSet {
            applyTextStyle()
        }
    }

    override open func setupStyle() {
        super.setupStyle()
        textAlignment = internalAlignment
        baselineAdjustment = .alignCenters
        applyTextStyle()
    }

    open func linkAttributedString(text: String, defaultColor: UIColor, colorTarget: UIColor, textTarget: String) {
        guard let font = font else { return }

        let mutableAttributedString = NSMutableAttributedString()

        let stringArray = separateString(text: text, target: textTarget)

        // first Array
        let attributedStrArrayFirst = getAttributedStringArray(color: defaultColor, font: font, UnderLine: 0)
        let attributedStrFirst = getAttributedString(string: stringArray[linkPosition.firstText.rawValue], attributedStrArray: attributedStrArrayFirst)

        // target Array
        let attributedStrArrayTarget = getAttributedStringArray(color: colorTarget, font: font, UnderLine: NSUnderlineStyle.single.rawValue)
        let attributedStrTarget = getAttributedString(string: stringArray[linkPosition.targetText.rawValue], attributedStrArray: attributedStrArrayTarget)

        // second Array
        let attributedStrArrayLast = getAttributedStringArray(color: defaultColor, font: font, UnderLine: 0)
        let attributedStrLast = getAttributedString(string: stringArray[linkPosition.lastText.rawValue], attributedStrArray: attributedStrArrayLast)

        mutableAttributedString.append(attributedStrFirst)
        mutableAttributedString.append(attributedStrTarget)
        mutableAttributedString.append(attributedStrLast)

        attributedText = mutableAttributedString
    }

    private func getAttributedStringArray(color: UIColor, font: UIFont, UnderLine: Int) -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font, NSAttributedString.Key.underlineStyle: UnderLine] as [NSAttributedString.Key: Any]
    }

    private func getAttributedString(string: String, attributedStrArray: [NSAttributedString.Key: Any]) -> (NSAttributedString) {
        return NSAttributedString(string: string, attributes: attributedStrArray)
    }

    private func separateString(text: String, target: String) -> [String] {
        let textArray = text.components(separatedBy: target)
        guard textArray.count >= 2 else {
            return []
        }
        let textArrayFirst = textArray[0]
        let textArraySecond = textArray[1]
        var stringArray: [String] = []
        stringArray.append(textArrayFirst)
        stringArray.append(target)
        stringArray.append(textArraySecond)
        return stringArray
    }

    public enum linkPosition: Int {
        case firstText = 0
        case targetText = 1
        case lastText = 2
    }

    open func didTapAttributedTextInLabel(locationOfTouchInLabel: CGPoint, targetText: String) -> Bool {
        guard let text = text else { return false }

        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        let labelSize = bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, (text as NSString).range(of: targetText))
    }

    private func applyTextStyle() {
        guard let font = font, let text = text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = customLineSpacing
        paragraphStyle.alignment = internalAlignment
        paragraphStyle.lineBreakMode = lineBreakMode

        let attributedString = NSMutableAttributedString(string: text)

        let selfRange = (text as NSString).range(of: text)

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: selfRange)

        attributedString.addAttribute(NSAttributedString.Key.font,
                                      value: font,
                                      range: selfRange)

        attributedText = attributedString
    }
}

@IBDesignable
open class SGStyleableLabel: UILabel {
    @IBInspectable var localisedKey: String? {
        didSet {
            guard let key = localisedKey else { return }
            text = NSLocalizedString(key, comment: "")
        }
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        #if TARGET_INTERFACE_BUILDER
            setupStyle()
        #endif
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        #if !TARGET_INTERFACE_BUILDER
            setupStyle()
        #endif
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
    }

    open func setupStyle() {}
}
