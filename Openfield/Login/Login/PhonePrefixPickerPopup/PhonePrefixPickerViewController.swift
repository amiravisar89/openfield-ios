//
//  PhonePrefixPickerViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 10/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import CollectionKit
import Dollar
import PhoneNumberKit
import RxSwift
import STPopup
import UIKit

struct CountryCellData {
    let name: String
    let prefix: String
    let code: String
}

class PhonePrefixPickerViewController: UIViewController {
    static let analyticsName = "country_selection_dialog"

    @IBOutlet var popupTitle: UILabel!
    @IBOutlet var countryList: CollectionView!
    @IBOutlet var closeButton: SGButton!
    @IBOutlet var viewBackground: UIView!

    private let disposeBag = DisposeBag()
    private let popularDataSource = ArrayDataSource(data: [CountryCellData]())
    private let restDataSource = ArrayDataSource(data: [CountryCellData]())
    private let itemsInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    private let popularCountryCodes = ["US", "ZA", "IL", "BR"]

    private lazy var layout: InsetLayout = WaterfallLayout(columns: 1, spacing: 0).inset(by: itemsInset)

    public var delegate: HasPhonePrefixPickerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStaticText()
        let allCountries = setupData()
        setupCountriesTable(countriesByCategory: allCountries)
        setupUI()
        setupStaticColor()
    }

    private func setupData() -> [Bool: [CountryCellData]] {
        let phoneNumberKit = PhoneNumberKit()
        let allCountries: [CountryCellData] = Set(phoneNumberKit.allCountries())
            .compactMap { countryCode -> CountryCellData? in
                guard let appLocalCode = Locale.preferredLanguages.first else { return nil }
                guard let name = (Locale(identifier: appLocalCode) as NSLocale).localizedString(forCountryCode: countryCode) else { return nil }
                guard let prefix = phoneNumberKit.countryCode(for: countryCode)?.description else { return nil }
                return CountryCellData(name: name, prefix: "+\(prefix)", code: countryCode)
            }
            .sorted(by: { $0.name.caseInsensitiveCompare($1.name) == .orderedAscending })
        let groups = Dollar.groupBy(allCountries) { country in popularCountryCodes.contains(country.code) }

        return groups
    }

    private func setupStaticColor() {
        viewBackground.backgroundColor = R.color.screenBg()!
    }

    private func setupCountriesTable(countriesByCategory: [Bool: [CountryCellData]]) {
        countryList.bounces = false

        let popularCountries = countriesByCategory[true]!.sorted(by: { countryA, countryB in
            guard let countryACode = popularCountryCodes.firstIndex(of: countryA.code) else { return false }
            guard let countryBCode = popularCountryCodes.firstIndex(of: countryB.code) else { return false }
            return countryACode < countryBCode
        })
        let restOfCountries = countriesByCategory[false]!

        let popularCountriesProvider = createCountriesProvider(countries: popularCountries, dataSource: popularDataSource)
        let restOfCountriesProvider = createCountriesProvider(countries: restOfCountries, dataSource: restDataSource)
        let popularTitleProvider = createPopularTitleProvider()
        let dividerProvider = createDividerProvider()

        let composedProvider = ComposedProvider(sections: [popularTitleProvider,
                                                           popularCountriesProvider,
                                                           dividerProvider,
                                                           restOfCountriesProvider])
        countryList.provider = composedProvider
    }

    private func createDividerProvider() -> Provider {
        let dataSource = ArrayDataSource(data: [0])
        let viewSource = ClosureViewSource(viewUpdater: { (contentView: UIView, _: Int, _: Int) in
            contentView.backgroundColor = .clear
            let divider = UIView()
            contentView.addSubview(divider)
            divider.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            divider.backgroundColor = R.color.lightGrey()
        })
        let sizeSource = { (_: Int, _: Int, _: CGSize) -> CGSize in
            CGSize(width: UIScreen.main.bounds.width, height: 20)
        }

        let provider = BasicProvider(dataSource: dataSource,
                                     viewSource: viewSource,
                                     sizeSource: sizeSource)
        provider.layout = layout
        return provider
    }

    private func createPopularTitleProvider() -> Provider {
        let dataSource = ArrayDataSource(data: [0])
        let viewSource = ClosureViewSource(viewUpdater: { (label: CaptionRegularGrey, _: Int, _: Int) in
            label.text = R.string.localizable.loginPopular()
            label.alignment = "left"
        })
        let sizeSource = { (_: Int, _: Int, _: CGSize) -> CGSize in
            CGSize(width: UIScreen.main.bounds.width, height: 30)
        }

        let provider = BasicProvider(dataSource: dataSource,
                                     viewSource: viewSource,
                                     sizeSource: sizeSource)
        provider.layout = layout
        return provider
    }

    private func createCountriesProvider(countries: [CountryCellData], dataSource: ArrayDataSource<CountryCellData>) -> Provider {
        let restOfCountriesProvider = BasicProvider(
            dataSource: dataSource,
            viewSource: { (view: CountryCellView, data: CountryCellData, _: Int) in
                view.bind(country: data)
            },
            sizeSource: ClosureSizeSource(sizeSource: { _, _, _ in
                CGSize(width: UIScreen.main.bounds.width, height: 40)
            }),
            tapHandler: { context in
                EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.countrySelection,
                                                                           .itemSelection, [EventParamKey.itemList: "countries",
                                                                                            EventParamKey.itemId: context.data.name]))
                EventTracker.track(event: AnalyticsEventFactory.buildDialogEvent(EventCategory.countrySelection, PhonePrefixPickerViewController.analyticsName, false, [EventParamKey.origin: "button"]))
                self.delegate?.selectedCountry(country: context.data)
                self.dismiss(animated: true, completion: nil)
            }
        )

        restOfCountriesProvider.layout = layout
        dataSource.data = countries

        return restOfCountriesProvider
    }

    private func setupUI() {
        popupTitle.addBottomBorderWithColor(color: R.color.lightGrey()!, width: 1.0)

        closeButton
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe { _ in
                EventTracker.track(event: AnalyticsEventFactory.buildDialogEvent(EventCategory.countrySelection, PhonePrefixPickerViewController.analyticsName, false, [EventParamKey.origin: "back"]))
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }

    private func setupStaticText() {
        popupTitle.text = R.string.localizable.loginSelectCountry()
        closeButton.titleString = R.string.localizable.closeButton()
    }
}

extension PhonePrefixPickerViewController {
    class func instantiate() -> PhonePrefixPickerViewController {
        let vc = R.storyboard.phonePrefixPickerViewController.phonePrefixPickerViewController()!
        return vc
    }
}
