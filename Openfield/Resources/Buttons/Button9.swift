//
//  Button9.swift
//  Openfield
//
//  Created by amir avisar on 29/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation

class Button9: SGButton {
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: R.color.grey3()!,
            titleFont: R.font.denimMedium(size: 18)!,
            borderWidth: 0
        )
        cornerRadius = 2.0
    }
}
