//
//  ShareButton.swift
//  Openfield
//
//  Created by Daniel Kochavi on 15/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

class ShareButton: SGButton {
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: .clear,
            titleFont: SubHeadline.regFont!,
            titleColor: R.color.primary()!,
            borderColor: .clear
        )

        highlightedButtonStyle = ButtonStyle(
            bgColor: R.color.lightGrey()!,
            titleFont: SubHeadline.regFont!,
            titleColor: R.color.primary()!,
            borderColor: .clear
        )
    }
}
