//
//  AccountLanguageCell.swift
//  Openfield
//
//  Created by amir avisar on 02/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import Foundation
import UIKit

class AccountLanguageCell: UIControl {
    // MARK: - Outlets

    @IBOutlet var contentView: UIView!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: BodyBoldPrimary!

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
            R.nib.accountLanguageCell).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
        titleLabel.text = R.string.localizable.languageLanguage()
    }
}
