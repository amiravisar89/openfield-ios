//
//  BrandButton.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

class BrandButton: SGButton {
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: R.color.valleyBrand()!,
            titleFont: BodyRegular.regFont!,
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
