//
//  UIView+Badge.swift
//  Openfield
//
//  Created by Amitai Efrati on 20/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension UIView {
    
    func addBadge(title: String, position: CGPoint, fontSize: CGFloat, cornerRadius: CGFloat) {
        removeBadge()
        
        let badge = PaddedLabel()
        badge.tag = 999
        badge.text = title
        badge.textColor = R.color.white()
        badge.backgroundColor = R.color.readSelected()
        badge.font = R.font.avertaRegular(size: fontSize)
        badge.textAlignment = .center
        badge.clipsToBounds = true
        badge.layer.cornerRadius = cornerRadius
        badge.textInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        badge.translatesAutoresizingMaskIntoConstraints = false
        
        clipsToBounds = false
        addSubview(badge)
        
        badge.snp.makeConstraints { make in
           make.centerX.equalToSuperview().offset(position.x)
           make.centerY.equalTo(self.snp.bottom).offset(position.y)
       }
    }
    
    func removeBadge() {
        for subview in self.subviews {
            if let button = subview as? UIButton, button.tag == 999 {
                subview.removeFromSuperview()
            }
        }
    }
    
    private func setConfig(badge: UIButton, title: String) {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.baseForegroundColor = .white
        config.background.backgroundColor = R.color.readSelected()
        config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)
        badge.configuration = config
    }
}

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
