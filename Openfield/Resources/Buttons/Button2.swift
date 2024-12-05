//
//  Button2.swift
//  Openfield
//
//  Created by Daniel Kochavi on 28/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

class Button2: SGButton { // TODO-Daniel: Rename this to PrimaryTextWhiteButton
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: R.color.white()!,
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
        cornerRadius = 4.0
    }
}
