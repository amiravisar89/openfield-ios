//
//  LoginButton.swift
//  Openfield
//
//  Created by Itay Kaplan on 30/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation

class Button6: SGButton {
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: R.color.lightGrey()!,
            titleFont: Body.boldFont!,
            titleColor: R.color.primary()!,
            borderColor: R.color.white42()!
        )

        disabledButtonStyle = ButtonStyle(
            bgColor: .clear,
            titleFont: Body.boldFont!,
            titleColor: R.color.white42()!,
            borderColor: R.color.white42()!
        )

        highlightedButtonStyle = ButtonStyle(
            bgColor: R.color.white()!,
            titleFont: Body.boldFont!,
            titleColor: R.color.primary()!,
            borderColor: R.color.white42()!
        )

        loadingButtonStyle = ButtonStyle(
            bgColor: R.color.white()!,
            titleFont: Body.boldFont!,
            titleColor: R.color.primary()!,
            borderColor: R.color.white42()!
        )

        cornerRadius = 2.0
    }
}
