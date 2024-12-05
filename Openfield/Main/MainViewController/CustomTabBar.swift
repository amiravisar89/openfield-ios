//
//  CustomTabBar.swift
//  Openfield
//
//  Created by Daniel Kochavi on 25/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import EasyTipView
import UIKit

protocol CustomTabBarDelegate: class {
    func didSelect(tab: CustomTabBar.TabItem)
}

final class CustomTabBar: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var tabItemInsights: UIButton!
    @IBOutlet private var tabItemFields: UIButton!
    @IBOutlet var topSeparator: UIView!
    public weak var delegate: CustomTabBarDelegate?

    private var selectedTab: TabItem?
    var toolTipManager = ToolTipManager()
    private var tabItems: [TabItem: UIView] = [:]

    public enum TabItem: Int {
        case fields = 0
        case insights = 1
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupStaticColor() {
        tabItemFields.setTitleColor(R.color.secondary()!.withAlphaComponent(0.5), for: .normal)
        topSeparator.backgroundColor = R.color.lightGrey()
        tabItemFields.setTitleColor(R.color.secondary(), for: .normal)
        tabItemInsights.setTitleColor(R.color.secondary(), for: .normal)
        tabItemFields.setTitleColor(R.color.valleyBrand(), for: .highlighted)
        tabItemInsights.setTitleColor(R.color.valleyBrand(), for: .highlighted)
        tabItemFields.setTitleColor(R.color.valleyBrand(), for: .selected)
        tabItemInsights.setTitleColor(R.color.valleyBrand(), for: .selected)
    }

    func presentFeedBtnToolTip(superView: UIViewController) {
        toolTipManager.openTipView(text: R.string.localizable.welcomeMyFieldsTipNew(), forView: tabItemFields, superView: superView.view)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hideFieldToolTip), userInfo: nil, repeats: false)
    }

    @objc func hideFieldToolTip() {
        toolTipManager.dismissAllTipViews()
    }

    private func setupView() {
        UINib(resource: R.nib.customTabBar).instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        tabItemFields.setTitle(R.string.localizable.fieldsMyFileds(), for: .normal)
        setupStaticColor()
    }

    @IBAction func clickedInsights(_: Any) {
        selectTab(tabItem: .insights)
    }

    @IBAction func clickedFields(_: Any) {
        selectTab(tabItem: .fields)
    }

    public func setupTabs(initialTab: TabItem) {
        tabItems[.insights] = tabItemInsights
        tabItems[.fields] = tabItemFields

        if let tabView = tabItems[initialTab] {
            mark(tabView: tabView, isSelected: true)
            selectedTab = initialTab
        }
    }

    public func externalSelectTab(tabItem: TabItem) {
        selectTab(tabItem: tabItem)
    }

    private func selectTab(tabItem: TabItem) {
        guard tabItem != selectedTab else { return }
        selectedTab = tabItem
        for (tabItem, view) in tabItems {
            mark(tabView: view, isSelected: tabItem == selectedTab)
        }
        delegate?.didSelect(tab: tabItem)
    }

    private func mark(tabView: UIView, isSelected: Bool) {
        guard let button = tabView as? UIButton else { return }
        button.isSelected = isSelected
    }
}
