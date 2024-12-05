//
//  DatesFilterViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 20/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import CollectionKit
import PullUpController
import ReactorKit
import Resolver
import RxCocoa
import RxSwift
import UIKit

class DatesFilterViewController: UIViewController, StoryboardView {
    var disposeBag: DisposeBag = .init()

    typealias Reactor = AnalysisReactor

    @IBOutlet var dateCollection: CollectionView!
    @IBOutlet var closeBtn: SGButton!
    @IBOutlet var leftArrowBtn: UIImageView!
    @IBOutlet var rightArrowBtn: UIImageView!
    @IBOutlet var dateLabel: UILabel!

    let dataSource = ArrayDataSource(data: [DateCell]())
    let dateProvider: DateProvider = Resolver.resolve()

    static var viewSize = CGSize(width: UIScreen.main.bounds.width, height: 241)

    override func viewDidLoad() {
        setupStaticTexts()
        setupAccessibility()
    }

    private func setupStaticTexts() {
        closeBtn.titleString = R.string.localizable.closeButton()
    }

    private func setupAccessibility() {
        leftArrowBtn.accessibilityIdentifier = "dateArrowLeft"
        rightArrowBtn.accessibilityIdentifier = "dateArrowRight"
        closeBtn.accessibilityIdentifier = "date_close"
    }

    private func setupCollection(reactor: AnalysisReactor) {
        let provider = BasicProvider(
            dataSource: dataSource,
            viewSource: { (view: AnalysisDateCell, data: DateCell, _: Int) in
                view.bind(to: data)
                view.accessibilityIdentifier = "date_cell"
                view.accessibilityTraits = [.button]
            },
            sizeSource: AutoLayoutSizeSource(dummyView: AnalysisDateCell.self,
                                             viewUpdater: { _, _, _ in }),
            tapHandler: { [weak self] context in
                guard let self = self else { return }
                Observable.just(context.data)
                    .map { Reactor.Action.selectedDate(dateCell: $0) }
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
            }
        )

        let inset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let layout = RowLayout(spacing: 10, justifyContent: .center)
        layout.alignItems = .center
        provider.layout = layout.inset(by: inset)
        dateCollection.provider = provider
    }

    func bind(reactor: AnalysisReactor) {
        setupCollection(reactor: reactor)

        closeBtn.rx.tapGesture()
            .when(.recognized)
            .do(onNext: { _ in EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.layerSelection, "date_selection_close")) })
            .subscribe(onNext: { [weak self] _ in
                self?.hideMySelf()
            })
            .disposed(by: disposeBag)

        rightArrowBtn.rx.tapGesture()
            .when(.recognized)
            .map { [weak self] _ in Reactor.Action.selectNextFlightDate(uiEffect: self?.scrollItemToCenter) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        leftArrowBtn.rx.tapGesture()
            .when(.recognized)
            .map { [weak self] _ in Reactor.Action.selectPreviousFlightDate(uiEffect: self?.scrollItemToCenter) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .filter { state -> Bool in !state.isWrapperEmpty }
            .map { $0.dates }
            .subscribe(onNext: { [weak self] data in
                self?.dataSource.data = data
                self?.dateCollection.reloadData()
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(reactor.state.filter { state -> Bool in !state.isWrapperEmpty }
            .compactMap { $0.currentDate }, reactor.state.compactMap { $0.field })
            .compactMap { [weak self] currentDate, field in
                guard let self = self else { return nil }
                return self.dateProvider.format(date: currentDate.date, region: field.region, format: .short)
            }
            .bind(to: dateLabel.rx.text).disposed(by: disposeBag)

        reactor.state
            .filter { state -> Bool in !state.isWrapperEmpty }
            .compactMap { $0.currentDate }
            .take(1)
            .subscribe(onNext: { [weak self] in self?.scrollItemToCenter(to: $0.index, animated: false) })
            .disposed(by: disposeBag)

        reactor.state
            .filter { state -> Bool in !state.isWrapperEmpty }
            .map { $0.hasNextDate }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isEnabled in
                self?.rightArrowBtn.image = isEnabled ? R.image.right_arrow_24pt() : R.image.right_arrow_disabled_24pt()
            })
            .disposed(by: disposeBag)

        reactor.state
            .filter { state -> Bool in !state.isWrapperEmpty }
            .map { $0.hasPreviousDate }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isEnabled in
                self?.leftArrowBtn.image = isEnabled ? R.image.left_arrow_24pt() : R.image.left_arrow_disabled_24pt()
            })
            .disposed(by: disposeBag)
    }

    func hideMySelf() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.frame.origin.y = UIScreen.main.bounds.height
            }
        }
    }

    private func initialFocus(dateCell _: DateCell) {}

    private func scrollItemToCenter(to index: Int) {
        scrollItemToCenter(to: index, animated: true)
    }

    private func scrollItemToCenter(to index: Int, animated: Bool = false) {
        if let frame = dateCollection.provider?.frame(at: index) {
            let screenWidth = UIScreen.main.bounds.width
            let itemWidth = frame.width
            let margin = (screenWidth - itemWidth) / 2
            let extendedFrame = CGRect(x: frame.minX - margin, y: frame.minY, width: screenWidth, height: frame.height)
            dateCollection.scrollRectToVisible(extendedFrame, animated: animated)
        }
    }
}

extension DatesFilterViewController {
    class func instantiate(with reactor: AnalysisReactor?) -> DatesFilterViewController {
        let vc = R.storyboard.datesFilterViewController.datesFilterViewController()!
        vc.reactor = reactor
        return vc
    }
}
