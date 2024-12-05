//
//  ButtonValleyBrand.swift
//  Openfield
//
//  Created by Daniel Kochavi on 04/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import UIKit

class ButtonValleyBrandBoldWhite: SGButton {
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: R.color.valleyBrand()!,
            titleFont: Body.boldFont!,
            titleColor: R.color.white()!,
            borderWidth: 0
        )

        highlightedButtonStyle = ButtonStyle(
            bgColor: R.color.green7()!,
            titleFont: Body.boldFont!,
            titleColor: R.color.white()!,
            borderWidth: 0
        )

        disabledButtonStyle = ButtonStyle(
            bgColor: R.color.lightGrey()!,
            titleFont: Body.regFont!,
            titleColor: R.color.secondary()!,
            borderWidth: 0
        )
        isUserInteractionEnabled = true
        cornerRadius = 4.0
    }
}
