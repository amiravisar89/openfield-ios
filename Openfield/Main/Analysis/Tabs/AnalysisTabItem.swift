//
//  AnalysisTabItem.swift
//  Openfield
//
//  Created by Daniel Kochavi on 18/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

@IBDesignable
class AnalysisTabItem: UIControl {
    // MARK: - Outlets

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var tabImage: UIImageView!
    @IBOutlet private var tabTitle: UILabel!
    @IBOutlet private var tabContent: UILabel!
    @IBOutlet private var emptyContentView: UIView!

    @IBOutlet var contentStackView: UIStackView!

    // MARK: - Members

    public var canClick: Bool {
        return tabContent.text != nil
    }

    // MARK: - Public

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public func toggleCompare(isCompare: Bool) {
        if isCompare {
            contentStackView.axis = .horizontal
            tabTitle.isHidden = true
        } else {
            tabTitle.isHidden = false
            contentStackView.axis = .vertical
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    // MARK: - Private

    private func setupStaticColor() {
        emptyContentView.backgroundColor = R.color.secondary()
    }

    private func setup() {
        setupView()
        setupStaticColor()
    }

    public final func image(image: UIImage) {
        tabImage.highlightedImage = image
    }

    public final func disabledImage(image: UIImage) {
        tabImage.image = image
    }

    public final func title(tabTitle: String) {
        self.tabTitle.text = tabTitle
        self.tabTitle.accessibilityIdentifier = "tab_title"
    }

    public final func content(tabContent: String?, accesabilty: String) {
        self.tabContent.text = tabContent
        setState(hasContent: tabContent != nil)
        self.tabContent.accessibilityIdentifier = accesabilty
    }

    private func setState(hasContent: Bool) {
        emptyContentView.isHidden = hasContent
        isUserInteractionEnabled = hasContent
        tabContent.alpha = hasContent ? 1 : 0
        tabTitle.textColor = hasContent ? R.color.primary() : R.color.secondary()
        tabImage.isHighlighted = hasContent
    }

    private func setupView() {
        UINib(resource: R.nib.analysisTabItem).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
    }
}

extension AnalysisTabItem {
    static func instanceFromNib() -> AnalysisTabItem {
        let tabItem = AnalysisTabItem(frame: CGRect.zero)
        return tabItem
    }
}

extension Reactive where Base: AnalysisTabItem {
    var image: Binder<UIImage> {
        return Binder(base) { view, image in
            view.image(image: image)
        }
    }

    var title: Binder<String> {
        return Binder(base) { view, title in
            view.title(tabTitle: title)
        }
    }

    var content: Binder<(content: String?, accesabilty: String)> {
        return Binder(base) { view, data in
            view.content(tabContent: data.content, accesabilty: data.accesabilty)
        }
    }
}
