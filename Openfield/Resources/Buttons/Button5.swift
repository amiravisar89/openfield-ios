//
//  Button5.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

class Button5: SGButton {
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: R.color.valleyBrand()!,
            titleFont: Body.regFont!,
            titleColor: R.color.white()!,
            borderWidth: 0
        )

        highlightedButtonStyle = ButtonStyle(
            bgColor: R.color.green7()!,
            titleFont: Body.regFont!,
            titleColor: R.color.white()!,
            borderWidth: 0
        )
        cornerRadius = 2.0
    }
}
