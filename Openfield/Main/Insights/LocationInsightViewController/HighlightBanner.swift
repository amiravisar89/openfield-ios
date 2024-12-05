//
//  HighlightBanner.swift
//  Openfield
//
//  Created by Yoni Luz on 18/04/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable
class HighlightBanner: BaseView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        UINib(resource: R.nib.highlightBanner).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in make.left.right.top.bottom.equalToSuperview() }
        
    }
}
