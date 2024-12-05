//
//  EnableDisableButton.swift
//  Openfield
//
//  Created by Amitai Efrati on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

@IBDesignable
class DoneButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit(){
        self.accessibilityIdentifier = "done_button"
        self.viewCornerRadius = 8
        self.backgroundColor = R.color.valleyBrand()!
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.white, for: .highlighted)
        self.setTitleColor(.white, for: .disabled)
        setEnabled(false)
    }
    
    func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        if isEnabled {
            self.alpha = 1.0
        } else {
            self.alpha = 0.5
        }
    }
}

extension Reactive where Base: DoneButton {
    var isEnabled: Binder<Bool> {
        return Binder(base) { button, isEnabled in
            base.setEnabled(isEnabled)
        }
    }
}
