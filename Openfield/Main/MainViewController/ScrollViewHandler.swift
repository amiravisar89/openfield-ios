//
//  ScrollViewHandler.swift
//  Openfield
//
//  Created by Daniel Kochavi on 22/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//
//  Influenced by: https://stackoverflow.com/a/38359313
//  And: https://medium.com/@Mos6yCanSwift/swift-ios-determine-scroll-direction-d48a2327a004

import UIKit

private var ContentOffsetKVO = 0
private var ContentSizeKVO = 0
private let contentOffsetLabel: String = "contentOffset"
private let contentSizeLabel: String = "contentSize"

public enum ScrollDirection {
    case scrollDown
    case scrollUp
}

public protocol ScrollViewDelegate: AnyObject {
    func scrollViewDidScroll(delta: CGFloat, scrollDirection: ScrollDirection)
}

public class ScrollViewHandler: NSObject {
    public weak var scrollViewDelegate: ScrollViewDelegate?
    private var lastVelocityYSign = 0

    public weak var scrollView: UIScrollView? {
        didSet {
            if let view = oldValue {
                removeKVO(scrollView: view)
                lastVelocityYSign = 0
            }

            if let view = scrollView {
                addKVO(scrollView: view)
                updateScrollPosition()
            }
        }
    }

    deinit {
        if let scrollView = scrollView {
            removeKVO(scrollView: scrollView)
        }
    }

    private func removeKVO(scrollView: UIScrollView) {
        scrollView.removeObserver(
            self,
            forKeyPath: contentSizeLabel,
            context: &ContentSizeKVO
        )

        scrollView.removeObserver(
            self,
            forKeyPath: contentOffsetLabel,
            context: &ContentOffsetKVO
        )
    }

    private func addKVO(scrollView: UIScrollView) {
        scrollView.addObserver(
            self,
            forKeyPath: contentSizeLabel,
            options: [.initial, .new],
            context: &ContentSizeKVO
        )

        scrollView.addObserver(
            self,
            forKeyPath: contentOffsetLabel,
            options: [.initial, .new],
            context: &ContentOffsetKVO
        )
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case .some(contentSizeLabel), .some(contentOffsetLabel):
            updateScrollPosition()

        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func updateScrollPosition() {
        guard let scrollView = scrollView else { return }

        // Update with the new scroll position.

        let viewSize = scrollView.bounds.size.height
        let scrollLimit = scrollView.contentSize.height - viewSize
        let scrollOffset = scrollView.contentOffset.y
        let scrollDelta = scrollOffset / scrollLimit

        let currentVelocityY = scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
        let currentVelocityYSign = Int(currentVelocityY).signum()
        if currentVelocityYSign != lastVelocityYSign &&
            currentVelocityYSign != 0
        {
            lastVelocityYSign = currentVelocityYSign
            let scrollDirection: ScrollDirection = lastVelocityYSign < 0 ? .scrollDown : .scrollUp

            scrollViewDelegate?.scrollViewDidScroll(delta: scrollDelta, scrollDirection: scrollDirection)
        }
    }
}
