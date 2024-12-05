//
//  Button4.swift
//  Openfield
//
//  Created by Eyal Prospera on 05/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

class Button4: SGButton {
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: R.color.white()!,
            titleFont: Body.boldFont!,
            titleColor: R.color.valleyBrand()!,
            borderColor: R.color.lightGrey()!,
            borderWidth: 1.0
        )

        highlightedButtonStyle = ButtonStyle(
            bgColor: R.color.lightGrey()!,
            titleFont: Body.boldFont!,
            titleColor: R.color.valleyBrand()!
        )
        cornerRadius = 5.0
    }
}
