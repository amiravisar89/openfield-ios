//
//  FieldCellView.swift
//  Openfield
//
//  Created by Daniel Kochavi on 26/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Kingfisher
import Resolver
import UIKit


class FieldCellView: UITableViewCell {
    @IBOutlet private var fieldImage: UIImageView!
    @IBOutlet private var fieldName: UILabel!
    @IBOutlet private var lastReports: UILabel!
    @IBOutlet private var unavailableMarker: UIImageView!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var unreadDot: UIView!
    
    let dateProvider: DateProvider = Resolver.resolve()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.backgroundColor = R.color.screenBg()!
        fieldName.lineBreakMode = .byTruncatingMiddle
    }

    func bind(to fieldCellContent: FieldCellContent) {
        let field = fieldCellContent.field
        fieldName.text = field.name.capitalize()
        var reportDate: Date? = nil
        switch fieldCellContent.report {
        case .insigntsReport(let insights, let date):
            let prefix = R.string.strings.insightsUpdates(insights_updates: UInt(insights.count))
            let fullText = "\(prefix) \(insights.joined(separator: ", "))"
            let attributedString = NSMutableAttributedString(string: fullText)
            let boldFont = UIFont.boldSystemFont(ofSize: 13)
            let range = (fullText as NSString).range(of: prefix)
            attributedString.addAttribute(NSAttributedString.Key.font, value: boldFont, range: range)
            lastReports.attributedText = attributedString
            reportDate = date
        case .imagesReport(let date):
            lastReports.text = R.string.localizable.fieldUpdateSatelliteImagery()
            reportDate = date
        case .noReport:
            lastReports.text = R.string.localizable.fieldNoRecentUpdates()
        }
        lastReports.textAlignment = .natural
        timeAgoLabel.text = dateProvider.daysTimeAgoSince(reportDate)
        setUnreadRead(readTime: fieldCellContent.fieldLastRead?.tsRead, reportDate: reportDate)
        fieldImage.kf.setImage(with: URL(string: fieldCellContent.latestImage ?? ""), placeholder: R.image.fieldHeaderPlaceholder()!)
        unavailableMarker.isHidden = fieldCellContent.latestImage != nil
        qa(field: field)
    }

    private func setUnreadRead(readTime: Date?, reportDate: Date?) {
        let unread = reportDate != nil && (readTime == nil || readTime?.isBeforeDate(reportDate!, granularity: .second) == true)
        fieldName.font = unread ? R.font.avertaSemibold(size: 18) : R.font.avertaRegular(size: 18)
        timeAgoLabel.font = unread ? R.font.avertaSemibold(size: 16) : R.font.avertaRegular(size: 16)
        unreadDot.isHidden = !unread
    }

    func qa(field: Field) {
        accessibilityIdentifier = "fieldCell"
        fieldName.accessibilityIdentifier = "fieldName_\(field.id)"
        lastReports.accessibilityIdentifier = "lastUpdated"
        fieldImage.accessibilityIdentifier = "fieldImage"
        unavailableMarker.accessibilityIdentifier = "unavailableMarker"
        timeAgoLabel.accessibilityIdentifier = "time_ago"
    }

    override func setHighlighted(_ highlighted: Bool, animated _: Bool) {
        if highlighted {
            contentView.backgroundColor = R.color.highLightedCell()!
        } else {
            contentView.backgroundColor = R.color.screenBg()!
        }
    }
}
