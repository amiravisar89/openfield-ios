//
//  KeyboardButton.swift
//  Openfield
//
//  Created by Daniel Kochavi on 05/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

class KeyboardButton: SGButton {
    override func setupView() {
        super.setupView()

        defaultButtonStyle = ButtonStyle(
            bgColor: R.color.white7()!,
            titleFont: Keyboard.regFont!,
            titleColor: R.color.white()!,
            borderColor: R.color.white42()!
        )

        highlightedButtonStyle = ButtonStyle(
            bgColor: R.color.white19()!,
            titleFont: Body.regFont!,
            titleColor: R.color.white()!,
            borderColor: R.color.white()!
        )

        cornerRadius = 2.0
    }
}
