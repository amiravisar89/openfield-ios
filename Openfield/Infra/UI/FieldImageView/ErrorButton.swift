//
//  ErrorButton.swift
//  Openfield
//
//  Created by Omer Cohen on 2/20/20.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

class ErrorButton: SGButton {
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: .clear,
            titleColor: R.color.primary()!,
            borderColor: R.color.lightGrey()!
        )

        highlightedButtonStyle = ButtonStyle(
            bgColor: .clear,
            titleColor: .clear
        )
        cornerRadius = FieldImageViewConstants.reloadErrorButtonCornerRadius
    }
}
