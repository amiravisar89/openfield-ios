//
//  EnhanceSeverityHeaderView.swift
//  Openfield
//
//  Created by amir avisar on 05/01/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class EnhanceSeverityHeaderView: UIView {
    // MARK: - Static members

    static let height: CGFloat = 45

    // MARK: - Outlets

    @IBOutlet var titleLabel: CaptionSemiBoldPrimary!
    @IBOutlet var subtitleLabel: CaptionSemiBoldPrimary!
    @IBOutlet private var contentView: UIView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var midtitleLabel: SubHeadlineRegular!

    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    public var subtitle: String? = "" {
        didSet {
            subtitleLabel.text = subtitle
        }
    }

    public var midtitle: String = "" {
        didSet {
            midtitleLabel.text = midtitle
        }
    }

    // MARK: - required

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func forQA() {
        accessibilityIdentifier = "severity_header"
        titleLabel.accessibilityIdentifier = "title"
        subtitleLabel.accessibilityIdentifier = "subtitle"
        midtitleLabel.accessibilityIdentifier = "midtitle"
    }

    // MARK: - UI

    private func setup() {
        UINib(resource:
            R.nib.enhanceSeverityHeaderView).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = R.color.lightGrey()!.withAlphaComponent(0.5)
        contentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        forQA()
    }
}

extension EnhanceSeverityHeaderView {
    static func instanceFromNib(rect: CGRect) -> EnhanceSeverityHeaderView {
        return EnhanceSeverityHeaderView(frame: rect)
    }
}
