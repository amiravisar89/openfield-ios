//
//  Body.swift
//  Openfield
//
//  Created by Daniel Kochavi on 26/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

open class Body: SGLabelStyleBase {
    private static let fontSize: CGFloat = 16.0
    static let boldFont = R.font.avertaBold(size: fontSize)
    static let regFont = R.font.avertaRegular(size: fontSize)
    static let lightFont = R.font.avertaLight(size: fontSize)
    static let semiBoldFont = R.font.avertaSemibold(size: fontSize)
}


open class BodyRegular: Body {
    override open func setupStyle() {
        super.setupStyle()
        font = Body.regFont
    }
}

open class BodyRegularGreen: BodyRegular {
    override open func setupStyle() {
        super.setupStyle()
        font = Body.regFont
        textColor = R.color.primaryGreen()
    }
}

open class BodyRegularValleyBrand: BodyRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.valleyBrand()
    }
}

open class BodyRegularSecondary: BodyRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.secondary()
    }
}

open class BodyRegularPrimary: BodyRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.primary()
    }
}

open class BodyRegularRed: BodyRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.red()
    }
}

open class BodyRegularWhite: BodyRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.white()
    }
}

open class BodySemiBoldBlack: BodyRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.blacK()
        font = Body.semiBoldFont
    }
}

open class BodySemiBoldBrand: BodyRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.valleyBrand()
        font = Body.semiBoldFont
    }
}

open class BodyBold: Body {
    override open func setupStyle() {
        super.setupStyle()
        font = Body.boldFont
    }
}

open class BodyBoldPrimary: BodyBold {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.primary()
    }
}

open class BodyBoldSecondary: BodyBold {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.secondary()
    }
}

open class BodyBoldWhite: BodyBold {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.white()
    }
}

open class BodyLight: Body {
    override open func setupStyle() {
        super.setupStyle()
        font = Body.lightFont
    }
}

open class BodyLightSecondary: BodyLight {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.secondary()
    }
}
