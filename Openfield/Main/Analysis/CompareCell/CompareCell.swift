//
//  CompareCell.swift
//  Openfield
//
//  Created by amir avisar on 02/07/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import SnapKit
import UIKit

class CompareCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initCell(viewController: UIViewController, parent: UIViewController) {
        addSubview(viewController.view)
        parent.addChild(viewController)
        viewController.didMove(toParent: parent)
        viewController.view.snp.updateConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
}
