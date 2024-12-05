//
//  ImageButton.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/04/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

class ImageButton: SGButton {
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: .clear,
            titleColor: .clear
        )

        highlightedButtonStyle = ButtonStyle(
            bgColor: .clear,
            titleColor: .clear
        )
    }
}
