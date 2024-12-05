//
//  BindsToInsightCell.swift
//  Openfield
//
//  Created by Daniel Kochavi on 19/03/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Kingfisher
import Resolver
import SwiftDate
import UIKit

protocol BindsToInsightCell {
    func bindToInsight(insight: Insight,
                       icon: UIImageView?,
                       title: UILabel?,
                       subtitle: UILabel?,
                       timeAgo: UILabel?,
                       chipsList: AppChipsList?,
                       dotView: UIView?,
                       dateProvider: DateProvider,
                       chipsProvider: ChipsProvider)
}

extension BindsToInsightCell {
    func bindToInsight(insight: Insight,
                       icon: UIImageView?,
                       title: UILabel?,
                       subtitle: UILabel?,
                       timeAgo: UILabel?,
                       chipsList: AppChipsList?,
                       dotView: UIView?,
                       dateProvider: DateProvider,
                       chipsProvider: ChipsProvider)
    {
        var subTitleText = insight.subject
        if let locationInsight = insight as? LocationInsight, !(insight is SingleLocationInsight), locationInsight.uid != WelcomeInsightsIds.locationInsight.rawValue {
            let startDate = dateProvider.format(date: locationInsight.startDate, region: locationInsight.dateRegion, format: .shortNoYear)
            let endDate = dateProvider.format(date: locationInsight.endDate, region: locationInsight.dateRegion, format: .shortNoYear)
            let dateText = locationInsight.startDate.isTheSameDay(as: locationInsight.endDate) ? startDate : "\(startDate)-\(endDate)"
            subTitleText = "\(locationInsight.subject) (\(dateText))"
        }

        let subtitleUnreadFont = BodyBoldPrimary.boldFont
        let subtitleReadFont = BodyRegularSecondary.regFont
        let timeAgoUnreadFont = SubHeadlineRegularPrimary.regFont
        let timeAgoReadFont = SubHeadlineRegularSecondary.regFont

        title?.text = insight.fieldName.capitalize()
        subtitle?.text = subTitleText
        timeAgo?.text = self.timeAgo(insight.publishDate, dateProvider: dateProvider)

        if let thumbnailUrl = insight.thumbnail {
            icon?.kf.setImage(with: URL(string: thumbnailUrl), placeholder: R.image.imageThumbnailPlaceHolder()!, options: [.transition(.fade(1))])
        } else {
            icon?.image = R.image.imageThumbnailPlaceHolder()!
        }

        timeAgo?.font = insight.isRead ? timeAgoReadFont : timeAgoUnreadFont
        subtitle?.font = insight.isRead ? subtitleReadFont : subtitleUnreadFont
        subtitle?.textColor = insight.isRead ? R.color.secondary() : R.color.primary()
        subtitle?.textColor = insight.isRead ? R.color.secondary() : R.color.primary()
        timeAgo?.textColor = insight.isRead ? R.color.secondary() : R.color.primary()

        let chipsConfig = chipsProvider.provideChips(for: insight)

        let chips: [String] = chipsConfig?.chips.map { $0.text } ?? []

        chipsList?.removeAllTags()
        chipsList?.bind(chips: chips)
        chipsList?.chipBackgroundColor = chipsConfig?.secondaryColor ?? R.color.meidumContrastYellow()!
        chipsList?.chipBorderColor = chipsConfig?.mainColor ?? R.color.meidumContrastYellow()!
        dotView?.backgroundColor = chipsConfig?.mainColor ?? R.color.meidumContrastYellow()
        dotView?.isHidden = chips.isEmpty

        title?.accessibilityIdentifier = "InsightFieldName_\(insight.uid)"
        subtitle?.accessibilityIdentifier = "InsightSubject_\(insight.uid)"
        timeAgo?.accessibilityIdentifier = "InsightTime_\(insight.uid)"
    }

    private func timeAgo(_ date: Date, dateProvider: DateProvider) -> String {
        let now = Date()
        return date.isTheSameWeek(as: now) ? dateProvider.timeAgoSince(date) : dateProvider.format(date: date, region: Region.local, format: .short)
    }
}
