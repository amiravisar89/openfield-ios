//
//  SingleIssueImageCardTypes.swift
//  Openfield
//
//  Created by amir avisar on 16/02/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import UIKit

protocol SingleIssueImageCard {
    func getCellIdentifier() -> String

    var image: LocationImageMeatadata { get }
    var isSelected: Bool { get }
    var tagColor: UIColor { get }
    var index: String { get }
}

struct SingleIssueLocationImageCard: SingleIssueImageCard {
    var image: LocationImageMeatadata
    var isSelected: Bool
    var tagColor: UIColor
    var index: String

    func getCellIdentifier() -> String {
        return R.reuseIdentifier.singleIssueIndexedCell.identifier
    }
}

struct SingleIssueEnhanceLocationImageCard: SingleIssueImageCard {
    var image: LocationImageMeatadata
    var isSelected: Bool
    var tagColor: UIColor
    var index: String
    var color: UIColor!
    var name: String

    func getCellIdentifier() -> String {
        return R.reuseIdentifier.singleIssueIndexedNamedCell.identifier
    }
}
