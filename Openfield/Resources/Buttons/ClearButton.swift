//
//  ClearButton.swift
//  Openfield
//
//  Created by Eyal Prospera on 09/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

class ClearButton: SGButton {
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: .clear,
            titleColor: .clear,
            borderColor: .clear
        )

        highlightedButtonStyle = ButtonStyle(
            bgColor: R.color.lightGrey()!,
            titleColor: R.color.valleyBrand()!
        )
        cornerRadius = 2.0
    }
}
