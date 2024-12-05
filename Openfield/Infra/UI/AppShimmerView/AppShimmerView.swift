//
//  AppShimmerView.swift
//  Openfield
//
//  Created by amir avisar on 27/05/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIView_Shimmer
import Kingfisher

class AppShimmerView : UIView, ShimmeringViewProtocol, Placeholder {
    
    @IBInspectable var viewBackgroundColor: UIColor = R.color.white()!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
  
    func startShimmering() {
        setTemplateWithSubviews(true, viewBackgroundColor: viewBackgroundColor)
    }
    
    func stopShimmering() {
        setTemplateWithSubviews(false)
    }
  
    private func setupView(){
        backgroundColor = viewBackgroundColor
        setTemplateWithSubviews(false)
    }
}
