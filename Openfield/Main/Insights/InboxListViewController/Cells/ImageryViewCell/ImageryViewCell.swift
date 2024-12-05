//
//  ImageryViewCell.swift
//  Openfield
//
//  Created by Daniel Kochavi on 05/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Kingfisher
import Resolver
import SwiftDate
import UIKit

class ImageryViewCell: UITableViewCell {
    @IBOutlet private var imageryCellImage: UIImageView!
    @IBOutlet private var imageryCellTitle: UILabel!
    @IBOutlet private var imageryCellSubtitle: UILabel!
    @IBOutlet private var imageryCellTimeAgo: UILabel!
    @IBOutlet private var contentViewBackground: UIView!

    private let subtitleUnreadFont = BodyBoldPrimary.boldFont
    private let subtitleReadFont = BodyRegularSecondary.regFont
    private let timeAgoUnreadFont = SubHeadlineRegularPrimary.regFont
    private let timeAgoReadFont = SubHeadlineRegularSecondary.regFont

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupStaticColor()
    }

    private func setupStaticColor() {
        contentViewBackground.backgroundColor = R.color.screenBg()!
    }

    public func bind(to imagery: Imagery) {
        imageryCellTitle.text = R.string.strings.fieldsCount(fields_count: UInt(imagery.count))
        imageryCellSubtitle.text = R.string.localizable.imageryNewImagery()
        imageryCellTimeAgo.text = timeAgo(imagery.date)
        imageryCellTimeAgo.font = imagery.isRead ? timeAgoReadFont : timeAgoUnreadFont
        imageryCellSubtitle.font = imagery.isRead ? subtitleReadFont : subtitleUnreadFont
        imageryCellSubtitle.textColor = imagery.isRead ? R.color.secondary() : R.color.primary()
        imageryCellSubtitle.textColor = imagery.isRead ? R.color.secondary() : R.color.primary()
        imageryCellTimeAgo.textColor = imagery.isRead ? R.color.secondary() : R.color.primary()
    }

    override func setHighlighted(_ highlighted: Bool, animated _: Bool) {
        if highlighted {
            contentViewBackground.backgroundColor = R.color.highLightedCell()!
        } else {
            contentViewBackground.backgroundColor = R.color.screenBg()!
        }
    }

    private func timeAgo(_ date: Date) -> String {
        let now = Date()
        let dateProvider: DateProvider = Resolver.resolve()
        return date.isTheSameWeek(as: now) ? dateProvider.timeAgoSince(date) : dateProvider.format(date: date, region: Region.local, format: .short)
    }
}
