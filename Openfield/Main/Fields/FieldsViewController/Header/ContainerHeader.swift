//
//  ContainerHeader.swift
//  Openfield
//
//  Created by Daniel Kochavi on 27/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Resolver
import RxCocoa
import RxGesture
import RxSwift
import UIKit

final class ContainerHeader: UIView {
    fileprivate enum Filter {
        case unread
        case all
    }

    let disposeBag = DisposeBag()
    let animationProvider: AnimationProvider = Resolver.resolve()
    private let feebackGenerator = UIImpactFeedbackGenerator(style: .light)
    public var tapUnreadFilter: Observable<UITapGestureRecognizer>?

    @IBOutlet var searchBarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate var contentView: UIView!
    @IBOutlet fileprivate var searchButton: UIImageView!
    @IBOutlet fileprivate var searchBackButton: UIImageView!
    @IBOutlet var readFilter: UIImageView!
    @IBOutlet var searchBar: FieldSearchBar!
    @IBOutlet var farmBtn: UIView!
    @IBOutlet var farmBtntitle: Title3BoldWhite!
    @IBOutlet var farmFromArrow: UIImageView!
    @IBOutlet var settingBtn: UIImageView!
    let searchActive: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let farmsSelectionListener: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let farmsSelectedListener: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let settingsButtonListener: BehaviorSubject<Bool> = BehaviorSubject(value: false)

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        UINib(resource: R.nib.containerHeader).instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        searchBarLeadingConstraint?.isActive = false
        readFilter.image = readFilter.image?.withRenderingMode(.alwaysTemplate)
        tapUnreadFilter = readFilter
            .rx
            .tapGesture()
            .when(.recognized)
        bind()
        forQA()
    }

    private func bind() {
        searchButton.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.searchActive.onNext(true)
            self.searchBar.searchTF.becomeFirstResponder()
            self.feebackGenerator.impactOccurred()
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.fieldsFilter, "fields_search"))
        }.disposed(by: disposeBag)

        readFilter.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.feebackGenerator.impactOccurred()
        }.disposed(by: disposeBag)

        searchBackButton.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.searchActive.onNext(false)
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.fieldsFilter, "fields_filter_close"))
        }.disposed(by: disposeBag)
        
        searchActive.observeOn(MainScheduler.instance).subscribe { [weak self] active in
            guard let self = self else { return }
            self.searchBackButton.isHidden = !active
            self.searchBarLeadingConstraint?.isActive = active
          _ = animationProvider.animate(duration: 0.3, delay: .zero) { [weak self] in
                guard let self = self else { return }
                self.searchBar.alpha = active ? 1 : 0
                self.searchButton.alpha = active ? 0 : 1
                self.farmBtn.alpha = active ? 0 : 1
                self.settingBtn.alpha = active ? 0 : 1
                self.layoutIfNeeded()
            }.subscribe()
            if active {
                self.searchBar.searchTF.becomeFirstResponder()
            } else {
                self.searchBar.searchTF.text = ""
                self.endEditing(true)
            }
        }.disposed(by: disposeBag)
    }

    private func forQA() {
        searchButton.accessibilityIdentifier = "fields_search_button"
        searchBar.searchTF.accessibilityIdentifier = "fields_search_text"
        searchBackButton.accessibilityIdentifier = "fields_search_back_button"
        readFilter.accessibilityIdentifier = "read_unread"
        farmBtntitle.accessibilityIdentifier = "farm_button_title"
        farmFromArrow.accessibilityIdentifier = "farm_button_arrow"

    }

    func setTab(by: CustomTabBar.TabItem) {
        switch by {
        case .insights:
            readFilter.isHidden = false
            searchButton.isHidden = true
            searchBackButton.isHidden = true
            setSearchActive(active: false)
        case .fields:
            readFilter.isHidden = true
            searchButton.isHidden = false
        }
        _ = animationProvider.animate(duration: 0.3, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.readFilter.alpha = by == .insights ? 1 : 0
            self.searchButton.alpha = by == .insights ? 0 : 1
            self.layoutIfNeeded()
        }.subscribe()
    }

    public func hideSearch(hide: Bool) {
        searchButton.isHidden = hide
    }

    fileprivate final func filter(by: Filter) {
        switch by {
        case .unread:
            readFilter.tintColor = R.color.readSelected()!
        case .all:
            readFilter.tintColor = R.color.white()
        }
    }
    
     func setSearchActive(active: Bool) {
         searchActive.onNext(active)
    }
    
    deinit {
        searchActive.dispose()
    }
}

extension Reactive where Base: ContainerHeader {

    var isUnreadState: Binder<Bool> {
        return Binder(base) { view, isUnread in
            view.filter(by: isUnread ? .unread : .all)
        }
    }
    
    
}
