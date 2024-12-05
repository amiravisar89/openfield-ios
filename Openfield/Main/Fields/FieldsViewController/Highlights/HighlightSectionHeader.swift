//
//  HighlightHeader.swift
//  Openfield
//
//  Created by amir avisar on 29/07/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class HighlightSectionHeader: UITableViewHeaderFooterView {
    static let height: CGFloat = 52

    @IBOutlet weak var rightTitle: BodySemiBoldBrand!
    @IBOutlet weak var leftTitle: BodySemiBoldBlack!
    
    public var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
}



