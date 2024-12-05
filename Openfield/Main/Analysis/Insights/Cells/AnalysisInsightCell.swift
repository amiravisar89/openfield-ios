//
//  AnalysisInsightCell.swift
//  Openfield
//
//  Created by Daniel Kochavi on 04/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Kingfisher
import Resolver
import UIKit

class AnalysisInsightCell: UITableViewCell {
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var subject: UILabel!
    @IBOutlet var timeAgo: UILabel!
    @IBOutlet var tagVisibilityImage: UIImageView!

    let dateProvider: DateProvider = Resolver.resolve()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    public func bind(to insight: IrrigationInsight) {
        if let thumbnailUrl = insight.thumbnail {
            cellImage.kf.setImage(with: URL(string: thumbnailUrl), placeholder: R.image.imageThumbnailPlaceHolder()!, options: [.transition(.fade(1))])
        } else {
            cellImage.image = R.image.imageThumbnailPlaceHolder()!
        }

        timeAgo.text = dateProvider.format(date: insight.publishDate, format: .short)
        subject.text = insight.subject

        tagVisibilityImage.image = insight.isSelected ? R.image.showTag() : R.image.hideTag()
        timeAgo.textColor = insight.isSelected ? R.color.valleyBrand() : R.color.secondary()
        subject.textColor = insight.isSelected ? R.color.valleyBrand() : R.color.primary()
        forQA(insight: insight)
    }

    private func forQA(insight: IrrigationInsight) {
        subject.accessibilityIdentifier = "subject_\(insight.uid)"
        timeAgo.accessibilityIdentifier = "time_ago_\(insight.uid)"
        tagVisibilityImage.accessibilityIdentifier = "eye_\(insight.uid)_\(insight.isSelected ? "selected" : "unselected")"
    }
}
