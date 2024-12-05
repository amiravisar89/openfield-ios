//
//  RequestReportCell.swift
//  Openfield
//
//  Created by Yoni Luz on 28/05/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import UIKit

class RequestReportCell: UITableViewCell {
    
    @IBOutlet weak var title: Title7SemiBold! {
        didSet {
            title.text = R.string.localizable.fieldRequestReportTitle()
        }
    }
    @IBOutlet weak var summery: BodyRegular! {
        didSet {
            summery.text = R.string.localizable.fieldRequestReportDescription()
        }
    }
}
