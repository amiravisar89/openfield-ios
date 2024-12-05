//
//  Button8.swift
//  Openfield
//
//  Created by amir avisar on 29/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation

class Button8: SGButton {
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: R.color.valleyBrand()!,
            titleFont: R.font.denimMedium(size: 18)!,
            titleColor: R.color.white()!,
            borderColor: R.color.valleyBrand()!
        )

        highlightedButtonStyle = ButtonStyle(
            bgColor: R.color.green7()!,
            titleFont: Body.boldFont!,
            titleColor: R.color.white()!
        )
        cornerRadius = 2.0
    }
}
