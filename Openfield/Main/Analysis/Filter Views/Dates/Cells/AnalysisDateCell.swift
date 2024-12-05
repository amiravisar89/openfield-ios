//
//  AnalysisDateCell.swift
//  Openfield
//
//  Created by Daniel Kochavi on 20/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Resolver
import RxSwift
import SwiftDate
import UIKit

class AnalysisDateCell: UIView {
    // MARK: - Outlets

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var dayName: UILabel!
    @IBOutlet private var monthName: UILabel!
    @IBOutlet private var dayDate: UILabel!
    @IBOutlet private var dateContainer: UIView!
    @IBOutlet var sourceTypeImageView: UIImageView!
    @IBOutlet var cloudImageView: UIImageView!

    let languageService: LanguageService = Resolver.resolve()
    let dateProvider: DateProvider = Resolver.resolve()
    let disposeBag = DisposeBag()

    // MARK: - Requeird

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        UINib(resource: R.nib.analysisDateCell).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
        setupStaticColor()
    }

    // MARK: - Bind

    public func bind(to date: DateCell) {
        if date.isEnabled && date.isSelected {
            dateContainer.layer.borderColor = R.color.valleyBrand()?.cgColor
            dateContainer.backgroundColor = R.color.valleyBrand()
            dayDate.textColor = R.color.white()
            dayName.textColor = R.color.white()
            monthName.textColor = R.color.white()
            setupCloud(isCloudy: date.isCloudy)
        } else if date.isEnabled {
            dateContainer.layer.borderColor = R.color.lightGrey()!.cgColor
            setBasicDateContainerColors()
            setupCloud(isCloudy: date.isCloudy)
        } else {
            dateContainer.layer.borderColor = UIColor.clear.cgColor
            setBasicDateContainerColors()
            cloudImageView.isHidden = true
            sourceTypeImageView.isHidden = true
        }

        let dayName = dateProvider.weekDayName(date: date.date, region: date.region).prefix(2).uppercased()
        let dayDate = "\(dateProvider.dayNumber(date: date.date, region: date.region))"
        let monthName = dateProvider.monthName(date: date.date, region: date.region).prefix(3).uppercased()
        self.dayName.text = dayName
        self.dayDate.text = dayDate
        self.monthName.text = monthName
        forQA(dayName: dayName, dayDate: dayDate, monthName: monthName)

        // set the source type image by source type
        // if there is no source type, default is analysis_date_plane
        sourceTypeImageView.image = date.sourceType == .satellite ? R.image.satellite() : R.image.analysis_date_plane()
    }

    // MARK: - Colors

    private func setupStaticColor() {
        dateContainer.layer.borderColor = R.color.lightGrey()!.cgColor
    }

    private func setupCloud(isCloudy: Bool) {
        sourceTypeImageView.isHidden = false
        cloudImageView.isHidden = !isCloudy
    }

    private func setBasicDateContainerColors() {
        dateContainer.backgroundColor = .clear
        dayDate.textColor = R.color.primary()
        dayName.textColor = R.color.secondary()
        monthName.textColor = R.color.secondary()
    }

    // MARK: - QA

    private func forQA(dayName: String, dayDate: String, monthName: String) {
        self.dayDate.accessibilityIdentifier = "day_\(dayDate)"
        self.dayName.accessibilityIdentifier = "day_name_\(dayName)"
        self.monthName.accessibilityIdentifier = "month_\(monthName)"
    }
}

// MARK: - Extensions

extension AnalysisDateCell {
    static func instanceFromNib() -> AnalysisDateCell {
        let item = AnalysisDateCell(frame: CGRect.zero)
        return item
    }
}
