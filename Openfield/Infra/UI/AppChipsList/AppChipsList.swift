//
//  AppChipsList.swift
//  Openfield
//
//  Created by amir avisar on 28/02/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation
import TagListView
import UIKit

@IBDesignable
class AppChipsList: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var chipList: TagListView!

    public var chipBackgroundColor: UIColor = .white {
        didSet {
            chipList.tagBackgroundColor = chipBackgroundColor
        }
    }

    public var chipBorderColor: UIColor = .white {
        didSet {
            chipList.borderColor = chipBorderColor
        }
    }

    public var chipTextColor: UIColor = .black {
        didSet {
            chipList.textColor = chipTextColor
        }
    }

    public var chipBorderWidth: CGFloat = 0.0 {
        didSet {
            chipList.borderWidth = chipBorderWidth
        }
    }

    public var chipCornerRadius: CGFloat = 0.0 {
        didSet {
            chipList.cornerRadius = chipCornerRadius
        }
    }

    public var alignment: TagListView.Alignment = .leading {
        didSet {
            chipList.alignment = alignment
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupView() {
        UINib(resource: R.nib.appChipsList).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in make.left.right.top.bottom.equalToSuperview() }
        chipBackgroundColor = R.color.meidumContrastYellowOpacity()!
        chipBorderColor = R.color.meidumContrastYellow()!
        chipTextColor = R.color.primary()!
        chipCornerRadius = 10
        chipList.borderWidth = 1
        chipList.marginY = 5
        chipList.paddingX = 8
        chipList.paddingY = 4
        chipList.textFont = R.font.avertaRegular(size: 14)!
    }

    func bind(chips: [String]) {
        chipList.addTags(chips)
        chipList.isAccessibilityElement = false // QA
        chipList.tagViews.enumerated().forEach { index, view in
            guard chips.indices.contains(index) else { return }
            let chip = chips[index]
            view.accessibilityIdentifier = "\(chip)_index_\(index)"
        }
    }

    func removeAllTags() {
        chipList.removeAllTags()
    }
}
