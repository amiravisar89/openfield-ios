//
//  InsightViewCell.swift
//  Openfield
//
//  Created by Itay Kaplan on 23/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Kingfisher
import Resolver
import TagListView
import UIKit

class InsightViewCell: UITableViewCell, BindsToInsightCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var timeAgo: UILabel!
    @IBOutlet private var contentViewBackground: UIView!
    @IBOutlet var dotView: UIView!
    @IBOutlet var chipsList: AppChipsList!

    private let subtitleUnreadFont = BodyBoldPrimary.boldFont
    private let subtitleReadFont = BodyRegularSecondary.regFont
    private let timeAgoUnreadFont = SubHeadlineRegularPrimary.regFont
    private let timeAgoReadFont = SubHeadlineRegularSecondary.regFont
    private let dateProvider: DateProvider = Resolver.resolve()
    private let chipsProvider: ChipsProvider = Resolver.resolve()

    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.accessibilityIdentifier = "InsightViewCell"
        setupStaticColor()
    }

    private func setupStaticColor() {
        contentViewBackground.backgroundColor = R.color.screenBg()!
        dotView.backgroundColor = R.color.meidumContrastYellow()
    }

    func bind(to insight: Insight) {
        bindToInsight(insight: insight,
                      icon: cellImage,
                      title: title,
                      subtitle: subtitle,
                      timeAgo: timeAgo,
                      chipsList: chipsList,
                      dotView: dotView,
                      dateProvider: dateProvider,
                      chipsProvider: chipsProvider)
    }

    override func setHighlighted(_ highlighted: Bool, animated _: Bool) {
        if highlighted {
            contentViewBackground.backgroundColor = R.color.highLightedCell()!
        } else {
            contentViewBackground.backgroundColor = R.color.screenBg()!
        }
    }
}
