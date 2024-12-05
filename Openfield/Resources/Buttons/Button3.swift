//
//  Button3.swift
//  Openfield
//
//  Created by Eyal Prospera on 10/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

class Button3: SGButton {
    override func setupView() {
        super.setupView()
        imageTextSpacing = 2
        defaultButtonStyle = ButtonStyle(
            bgColor: R.color.screenBg()!,
            titleFont: Body.regFont!,
            titleColor: R.color.primary()!,
            borderColor: R.color.lightGrey()!
        )

        highlightedButtonStyle = ButtonStyle(
            bgColor: R.color.lightGrey()!,
            titleFont: Body.regFont!,
            titleColor: R.color.primary()!,
            borderColor: R.color.lightGrey()!
        )
        cornerRadius = 2.0
    }
}
