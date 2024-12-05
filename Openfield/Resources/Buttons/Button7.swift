//
//  Button7.swift
//  Openfield
//
//  Created by amir avisar on 09/03/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation
import UIKit

class Button7: SGButton {
    override func setupView() {
        super.setupView()
        defaultButtonStyle = ButtonStyle(
            bgColor: R.color.grey3()!,
            titleFont: Body.regFont!,
            borderWidth: 0
        )
        cornerRadius = 2.0
    }
}
