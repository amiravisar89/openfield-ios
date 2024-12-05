//
//  LocationInsightPage.swift
//  Openfield
//
//  Created by Yoni Luz on 18/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FSPagerView
import SnapKit
import Resolver

class LocationInsightPage: FSPagerViewCell {
    
    var vc: LocationInsightViewController!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        vc = R.storyboard.locationInsightViewController.locationInsightViewController()!
        addSubview(vc.view)
        vc.view.snp.makeConstraints { make in make.left.right.top.bottom.equalToSuperview() }
    }
    
    func bind(insight: LocationInsight, origin: NavigationOrigin, flowController: MainFlowController?) {
        let reactor: LocationInsightReactor = Resolver.resolve(args: [insight, origin.rawValue])
        vc.reactor = reactor
        vc.flowController = flowController
    }
    
}
