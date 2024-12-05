//
//  CloudButton.swift
//  Openfield
//
//  Created by amir avisar on 13/04/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

class CloudButton: UIButton {
    // MARK: - Outlets

    @IBOutlet var contentView: UIView!
    @IBOutlet var cloudIcon: UIImageView!

    // MARK: - Members

    private var toolTipManager = ToolTipManager()

    // MARK: - required

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
        isHidden = true
        UINib(resource:
            R.nib.cloudButton).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
        layer.borderWidth = 1
        layer.cornerRadius = 11
        layer.masksToBounds = true
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
    }
}

extension CloudButton {
    static func instanceFromNib() -> CloudButton {
        return CloudButton(frame: CGRect.zero)
    }
}
