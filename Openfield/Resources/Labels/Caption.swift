//
//  Caption.swift
//  Openfield
//
//  Created by Daniel Kochavi on 26/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import UIKit

open class Caption: SGLabelStyleBase {
    private static let fontSize: CGFloat = 13.0
    static let boldFont = R.font.avertaBold(size: fontSize)
    static let regFont = R.font.avertaRegular(size: fontSize)
    static let semiBold = R.font.avertaSemibold(size: fontSize)
}

open class CaptionRegularBlack: Caption {
    override open func setupStyle() {
        super.setupStyle()
        font = Caption.regFont
        textColor = R.color.blacK()!
    }
}

open class CaptionRegular: Caption {
    override open func setupStyle() {
        super.setupStyle()
        font = Caption.regFont
    }
}

open class CaptionRegularPrimary: CaptionRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.primary()
    }
}

open class CaptionBoldWhite: CaptionRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.white()
        font = Caption.boldFont
    }
}

open class CaptionSemiBoldPrimary: CaptionRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.primary()
        font = Caption.semiBold
    }
}

open class CaptionRegularSecondary: CaptionRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.secondary()
    }
}

open class CaptionRegularSecondaryAlpha: CaptionBold {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.secondary()!.withAlphaComponent(0.4)
    }
}

open class CaptionRegularValley: CaptionRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.valleyBrand()
    }
}

open class CaptionRegularGrey: CaptionRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.secondary()
    }
}

open class CaptionRegularLightBlueGrey: CaptionRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.lightBlueGrey()
    }
}

open class CaptionRegularRed: CaptionRegular {
    override open func setupStyle() {
        super.setupStyle()
        textColor = R.color.red()
    }
}

open class CaptionBold: Caption {
    override open func setupStyle() {
        super.setupStyle()
        font = Caption.boldFont
    }
}
