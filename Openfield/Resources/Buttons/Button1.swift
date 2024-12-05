//
//  Button1.swift
//  Openfield
//
//  Created by Itay Kaplan on 04/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

class Button1: SGButton { // TODO-Daniel: Rename to convention: IconBrandTextScreenBGButton
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: R.color.screenBg()!,
            titleFont: Body.regFont!,
            titleColor: R.color.valleyBrand()!,
            borderColor: R.color.lightGrey()!
        )

        highlightedButtonStyle = ButtonStyle(
            bgColor: R.color.lightGrey()!,
            titleFont: Body.regFont!,
            titleColor: R.color.valleyBrand()!,
            borderColor: R.color.lightGrey()!
        )

        disabledButtonStyle = ButtonStyle(
            bgColor: R.color.screenBg()!,
            titleFont: Body.regFont!,
            titleColor: R.color.lightBlueGrey()!,
            borderColor: R.color.lightGrey()!
        )

        cornerRadius = 2.0
    }
}
