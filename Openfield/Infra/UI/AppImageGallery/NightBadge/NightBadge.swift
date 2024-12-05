//
//  NightBadge.swift
//  Openfield
//
//  Created by amir avisar on 16/07/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

@IBDesignable
class NightBadge: UIView {
    
    @IBOutlet public weak var title: Title10RegularWhite!
    @IBOutlet private var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        UINib(resource: R.nib.nightBadge).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in make.left.right.top.bottom.equalToSuperview() }
        title.text = R.string.localizable.nightImage()
    }
    

}

