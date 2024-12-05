//
//  FieldsSectionHeader.swift
//  Openfield
//
//  Created by amir avisar on 29/07/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class FieldsSectionHeader: UITableViewHeaderFooterView {
    static let height: CGFloat = 56

    @IBOutlet var listTitle: BodySemiBoldBlack!
    @IBOutlet var fieldSelectedSortingName: UILabel!
    @IBOutlet var fieldListSortingSelectionContainer: UIStackView!
    
    public var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
}



