//
//  AnalysisInsightsViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 04/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import PullUpController
import ReactorKit
import Resolver
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class AnalysisInsightsViewController: UIViewController, StoryboardView {
    var disposeBag: DisposeBag = .init()

    typealias Reactor = AnalysisReactor

    @IBOutlet private var insightsTable: UITableView!
    @IBOutlet var closeBtn: SGButton!
    @IBOutlet private var tableTotalHeight: NSLayoutConstraint!
    var insightsCount: Double = 1
    let rowHeight: CGFloat = 80
    var totalRowHeight: CGFloat {
        return CGFloat(min(2.5, insightsCount)) * rowHeight
    }

    var viewSize: CGSize {
        let height = 50 + totalRowHeight
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(height))
    }

    override func viewDidLoad() {
        setupTable()
        setupStaticTexts()
        setupAccessibility()
    }

    private func setupAccessibility() {
        closeBtn.accessibilityIdentifier = "insighs_close"
    }

    private func setupStaticTexts() {
        closeBtn.titleString = R.string.localizable.closeButton()
    }

    private func setupTable() {
        insightsTable.register(UINib(resource: R.nib.analysisInsightCell), forCellReuseIdentifier: R.reuseIdentifier.analysisInsightCell.identifier)
        insightsTable.separatorInset = UIEdgeInsets(top: 0, left: 78, bottom: 0, right: 20)
        insightsTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: insightsTable.frame.size.width, height: 1)) // Hides last separator in tableview
        insightsTable.rowHeight = rowHeight

        rx.viewDidAppear.take(1)
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tableTotalHeight.constant = self.totalRowHeight - 1 // -1 is for hiding the separator when there's more than 2 items
                self.view.updateConstraints()
                self.view.layoutIfNeeded()
                self.insightsTable.isScrollEnabled = self.insightsCount > 2
                self.view.accessibilityIdentifier = "AnalysisInsightsView_\(self.insightsCount)"
                self.view.accessibilityTraits = [.button]
            })
            .subscribe()
            .disposed(by: disposeBag)
    }

    func bind(reactor: AnalysisReactor) {
        reactor.state
            .filter { state -> Bool in !state.isWrapperEmpty }
            .compactMap { $0.insights }
            .bind(to: insightsTable.rx.items(cellIdentifier: R.reuseIdentifier.analysisInsightCell.identifier, cellType: AnalysisInsightCell.self)) { _, insight, cell in
                cell.bind(to: insight)
                cell.accessibilityIdentifier = "insight_cell"
                cell.accessibilityTraits = [.button]
            }
            .disposed(by: disposeBag)

        closeBtn.rx.tapGesture()
            .when(.recognized)
            .do(onNext: { _ in EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.detectionsSelection, "detections_selection_close")) })
            .subscribe(onNext: { [weak self] _ in
                self?.hideMySelf()
            })
            .disposed(by: disposeBag)

        insightsTable.rx
            .itemSelected
            .map { indexPath in Reactor.Action.clickedInsight(indexPath: indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func hideMySelf() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.frame.origin.y = UIScreen.main.bounds.height
            }
        }
    }
}

extension AnalysisInsightsViewController {
    class func instantiate(with reactor: AnalysisReactor?) -> AnalysisInsightsViewController {
        let vc = R.storyboard.analysisInsightsViewController.analysisInsightsViewController()!
        vc.reactor = reactor
        return vc
    }
}
