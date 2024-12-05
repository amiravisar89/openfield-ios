//
//  AppCalendarWithArrows.swift
//  Openfield
//
//  Created by amir avisar on 18/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import UIKit
import Resolver
import SwiftDate

@IBDesignable
class AppCalendarWithArrows: UIView {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet private weak var appCalendar: AppCalendarCollection!
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet public weak var title: BodySemiBoldBrand!
    @IBOutlet public weak var backwardArrow: UIButton!
    @IBOutlet public weak var forwardArrow: UIButton!
    
    private let dateProvider: DateProvider = Resolver.resolve()
    
    public let dateSelected : PublishSubject<DateWithType> = PublishSubject()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        UINib(resource: R.nib.appCalendarWithArrows).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in make.left.right.top.bottom.equalToSuperview() }
        bind()
    }
    
    private func bind() {
        appCalendar.itemSelected.subscribe { [weak self] item in
            guard let self = self else { return }
            self.dateSelected.onNext(DateWithType(date: item.date, dateSelectType: .specific))
        }.disposed(by: disposeBag)
        
        backwardArrow.rx.tapGesture().when(.recognized)
            .observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.goToPrevIndex()
            }).disposed(by: disposeBag)
        
        forwardArrow.rx.tapGesture().when(.recognized)
            .observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.goToNextIndex()
            }).disposed(by: disposeBag)
        
        backwardArrow.setImage(R.image.left_arrow_24pt()!, for: .normal)
        backwardArrow.setImage(R.image.left_arrow_disabled_24pt()!, for: .disabled)
        forwardArrow.setImage(R.image.right_arrow_24pt()!, for: .normal)
        forwardArrow.setImage(R.image.right_arrow_disabled_24pt()!, for: .disabled)

    }
    
    public func setDates(dates: [Date], selectedDate: Date, region: Region, fillGaps: Bool = true) {
        let elements = (fillGaps ? fillDateGaps(dates: dates) : dates).map {
            AppCallendarElement(date: $0, selected: $0.compare(.isSameDay(selectedDate)), enabled: dates.contains($0))
        }
        let animated = (appCalendar.items?.count ?? 0) > 0
        appCalendar.setDates(elements: elements)
        title.text = dateProvider.format(date: selectedDate, region: region, format: .short)
        let index = elements.firstIndex(where: { $0.selected }) ?? elements.count - 1
        goToIndex(index: index, animated: animated)
        updateButtons()
    }
    
    private func goToNextIndex() {
        if let index = getNextIndex(), let date = appCalendar.items?[index].date {
            self.dateSelected.onNext(DateWithType(date: date, dateSelectType: .next))
        }
    }
    
    private func goToPrevIndex() {
        if let index = getPrevIndex(), let date = appCalendar.items?[index].date {
            self.dateSelected.onNext(DateWithType(date: date, dateSelectType: .previous))
        }
    }
    
    private func updateButtons() {
        forwardArrow.isEnabled = getNextIndex() != nil
        backwardArrow.isEnabled = getPrevIndex() != nil
    }
    
    private func getNextIndex() -> Int? {
        if let array = appCalendar.items, let selectedIndex = array.firstIndex(where: { $0.selected }) {
            if let next = getSubarray(from: array, fromIndex: selectedIndex + 1, toIndex: array.count - 1)?.firstIndex(where: { $0.enabled }) {
                return next + selectedIndex + 1
            } else {
                return nil
            }
        }
        return nil
    }
    
    private func getPrevIndex() -> Int? {
        if let array = appCalendar.items, let selectedIndex = array.firstIndex(where: { $0.selected }) {
            return getSubarray(from: array, fromIndex: 0, toIndex: selectedIndex - 1)?.lastIndex(where: { $0.enabled })
        }
        return nil
    }
    
    private func goToIndex(index: Int, animated: Bool = false) {
        appCalendar.goToIndex(index: index, animated: animated)
    }
    
    
    private func fillDateGaps(dates: [Date]) -> [Date] {
        if dates.isEmpty {
            return []
        }
        let sortedDates = dates.sorted(by: { $0.compare($1) == .orderedAscending })
        guard let startDate = sortedDates.first, let endDate = sortedDates.last else {
            return []
        }
        return generateDatesArray(from: startDate, to: endDate)
    }

    private func generateDatesArray(from startDate: Date, to endDate: Date) -> [Date] {
        var datesArray: [Date] = []
        var currentDate = startDate
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // Set calendar to UTC

        while currentDate <= endDate {
            let normalizedDate = calendar.startOfDay(for: currentDate)
            datesArray.append(normalizedDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: normalizedDate) else { break }
            currentDate = nextDate
        }

        return datesArray
    }

    private func getSubarray<T>(from array: [T], fromIndex: Int, toIndex: Int) -> [T]? {
        // Ensure the indices are within the bounds of the array
        guard fromIndex >= 0, toIndex < array.count, fromIndex <= toIndex else {
            return nil
        }
        let subarray = Array(array[fromIndex...toIndex])
        return subarray
    }
    
}

enum DateSelectType: String {
    case previous
    case next
    case specific
}

struct DateWithType {
    let date: Date
    let dateSelectType: DateSelectType
}




