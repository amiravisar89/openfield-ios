//
//  DeleteButton.swift
//  Openfield
//
//  Created by Daniel Kochavi on 06/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import UIKit

class DeleteButton: SGButton {
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: .clear,
            titleFont: Body.regFont!,
            titleColor: .clear,
            borderColor: .clear
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
