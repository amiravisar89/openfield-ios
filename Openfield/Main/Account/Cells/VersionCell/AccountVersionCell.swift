//
//  AccountVersionCell.swift
//  Openfield
//
//  Created by amir avisar on 29/10/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit

class AccountVersionCell: UIControl {
  
    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet var titleLabel: CaptionRegularGrey!

    // MARK: - Override
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    // MARK: - UI

    private func setup() {
        setupView()
    }

    private func setupView() {
        UINib(resource:
                R.nib.accountVersionCell).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
        titleLabel.alignment = "natural"
    }
}
