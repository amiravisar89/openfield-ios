//
//  LanguagePickerPopupViewController.swift
//  Openfield
//
//  Created by amir avisar on 02/08/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import FirebaseAnalytics
import Foundation
import NVActivityIndicatorView
import ReactorKit
import Resolver
import RxCocoa
import RxDataSources
import RxSwift
import RxViewController
import STPopup
import SwiftyUserDefaults
import UIKit

class LanguageCellViewModel: LanguageData {
    var isSelected: Bool

    init(name: String, locale: Locale, isSelected: Bool) {
        self.isSelected = isSelected
        super.init(name: name, locale: locale)
    }
}

class LanguagePickerPopupViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var doneBtn: ButtonValleyBrandBoldWhite!
    @IBOutlet var mainTitle: Title3BoldPrimary!
    @IBOutlet var languagesTable: UITableView!

    // MARK: - RxSwift

    let disposeBag = DisposeBag()

    // MARK: - Members

    let languageService: LanguageService = Resolver.resolve()
    var languageSelected: LanguageData?
    public weak var delegate: HasLanguagePickerPopup?

    var currentLocale: Locale?
    var supportedLanguagesItems: BehaviorSubject<[LanguageCellViewModel]> = BehaviorSubject(value: [])

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        setupUI()
        bind()

        languageService.currentLanguage.bind { self.currentLocale = $0.locale }
            .disposed(by: disposeBag)
    }

    // MARK: - UI

    private func setupUI() {
        setupStaticTexts()
    }

    private func setupStaticTexts() {
        mainTitle.text = R.string.localizable.languageChooseYourLanguage()
        doneBtn.titleString = R.string.localizable.done()
    }

    private func initTable() {
        languagesTable.tableFooterView = UIView()
        languagesTable.register(UINib(resource: R.nib.languageCell), forCellReuseIdentifier: R.reuseIdentifier.languageCell.identifier)
    }

    // MARK: - bind

    private func bind() {
        languageService.currentLanguage.map { $0.locale }.take(1).subscribe { [unowned self] locale in
            supportedLanguagesItems.onNext(languageService.languageSupported.map { LanguageCellViewModel(name: $0.name, locale: locale, isSelected: $0.locale.identifier == locale.identifier) }.sorted(by: { $0.name.caseInsensitiveCompare($1.name) == .orderedAscending }))
        }.disposed(by: disposeBag)

        supportedLanguagesItems.bind(to: languagesTable.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.languageCell.identifier, for: IndexPath(row: row, section: 0)) as! LanguageCell
            cell.bind(cell: element)
            return cell
        }.disposed(by: disposeBag)

        languagesTable.rx.modelSelected(LanguageData.self).subscribe { [weak self] languageData in
            guard let self = self else { return }
            self.supportedLanguagesItems.onNext(self.languageService.languageSupported.map { LanguageCellViewModel(name: $0.name, locale: $0.locale, isSelected: $0.locale.identifier == languageData.element!.locale.identifier) }.sorted(by: { $0.name.caseInsensitiveCompare($1.name) == .orderedAscending }))
            guard let element = languageData.element else { return }
            self.languageSelected = element
        }.disposed(by: disposeBag)

        doneBtn.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            if let lanSelected = self.languageSelected {
                self.reportAnalytics(selectedLanguage: lanSelected)
                self.delegate?.selectLanguage(language: lanSelected)
            }
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }

    private func reportAnalytics(selectedLanguage: LanguageData) {
        guard let currentLanguageIdentifier = currentLocale?.identifier else {
            return
        }

        if currentLanguageIdentifier == selectedLanguage.locale.identifier {
            return
        }

        let analyticsParams = [
            EventParamKey.language: selectedLanguage.locale.identifier,
            EventParamKey.previousLanguage: currentLanguageIdentifier,
            EventParamKey.deviceLanguage: NSLocale.current.languageCode ?? "none",
        ]
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.localization, .languageChanged, analyticsParams))
    }
}

extension LanguagePickerPopupViewController {
    class func instantiate() -> LanguagePickerPopupViewController {
        let vc = R.storyboard.languagePickerPopupViewController.languagePickerPopupViewController()!
        return vc
    }
}
