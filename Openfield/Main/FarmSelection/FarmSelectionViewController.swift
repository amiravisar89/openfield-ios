//
//  FarmSelectionViewController.swift
//  Openfield
//
//  Created by amir avisar on 16/04/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import ReactorKit
import Resolver
import RxCocoa
import RxSwift
import UIKit

class FarmSelectionViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var farmCounterLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var applyBtn: ButtonValleyBrandBoldWhite!
    @IBOutlet var farmFilterTitle: UILabel!

    // MARK: - Members

    let farmFilter: FarmFilter = Resolver.resolve()
    let disposeBag = DisposeBag()
    var farms: [FilteredFarm] = .init()
    var farmsSelectedListener: BehaviorSubject<Bool>?
    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.farmPopUp, .openFarmPopup))
        registerTable()
        staticTextSetUp()
        bind()
        QA()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1
        }
        PerformanceManager.shared.stopTrace(for: .farm_selection)
    }

    private func staticTextSetUp() {
        farmFilterTitle.text = R.string.localizable.farmFilterFarmSelection()
        applyBtn.titleString = R.string.localizable.apply()
        closeButton.setTitle(R.string.localizable.cancel(), for: .normal)
    }

    func enableApplyBtn() {
        applyBtn.isUserInteractionEnabled = true
        applyBtn.alpha = 1
    }

    func disableApplyBtn() {
        applyBtn.isUserInteractionEnabled = false
        applyBtn.alpha = 0.4
    }

    func QA() {
        applyBtn.accessibilityIdentifier = "farm_apply_button"
        closeButton.accessibilityIdentifier = "farm_close_button"
        farmFilterTitle.accessibilityIdentifier = "farm_filter_title"
        farmCounterLabel.accessibilityIdentifier = "farm_counter_title"
    }

    func bind() {
        farmFilter.farms.observeOn(MainScheduler.instance).map { farms in
            farms.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        }.subscribe { [weak self] farms in
            guard let self = self else { return }
            guard let farms = farms.element else { return }
            let farmsSelected = farms.filter { $0.isSelected }
            self.farms = farms
            self.farms.insert(FilteredFarm(isSelected: farmsSelected.count == farms.count, name: R.string.localizable.farmAllFarms(), fieldIds: farms.flatMap { $0.fieldIds }, type: .allFarms, id: 0), at: 0)
            self.tableView.reloadData()
        }.disposed(by: disposeBag)

        farmFilter.farms.observeOn(MainScheduler.instance)
            .map { R.string.localizable.farmFilterFarmSelected($0.filter { $0.isSelected }.count, $0.count) }
            .bind(to: farmCounterLabel.rx.text)
            .disposed(by: disposeBag)

        applyBtn.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            let defaultFarms = self.farms.filter { $0.type == .defaultFarm }
            let selectedFarms = defaultFarms.filter { $0.isSelected }

            // TODO: maybe we need to remove this analytics
            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.farmPopUp, .farmSelection, [EventParamKey.farmList: selectedFarms.compactMap { $0.name }.joined(separator: ",")]))
            self.farmFilter.selectFarms(farms: defaultFarms)
            self.farmsSelectedListener?.onNext(true)
            self.dismissMySelf()
        }.disposed(by: disposeBag)
    }

    func dismissMySelf() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Actions

    @IBAction func closeAction(_: Any) {
        dismissMySelf()
    }
}

extension FarmSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func registerTable() {
        tableView.register(UINib(resource: R.nib.farmSelectCell), forCellReuseIdentifier: R.reuseIdentifier.farmSelectCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let farmSelected = farms[indexPath.row]
        farms[indexPath.row].isSelected = !farmSelected.isSelected
        var regularFarms = farms.filter { $0.type == .defaultFarm }

        if farmSelected.type == .allFarms {
            farms.enumerated().forEach { index, _ in
                farms[index].isSelected = !farmSelected.isSelected
            }
        } else if regularFarms.filter({ $0.isSelected }).count == regularFarms.count {
            farms.enumerated().forEach { index, _ in
                farms[index].isSelected = true
            }
        } else {
            if let index = farms.firstIndex(where: { $0.type == .allFarms }) {
                farms[index].isSelected = false
            }
        }
        regularFarms = farms.filter { $0.type == .defaultFarm }
        let farmsSelected = regularFarms.filter { $0.isSelected }
        farmsSelected.count > 0 ? enableApplyBtn() : disableApplyBtn()
        farmCounterLabel.text = R.string.localizable.farmFilterFarmSelected(farmsSelected.count, regularFarms.count)
        tableView.reloadData()
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return farms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FarmSelectCell = tableView.dequeueReusableCell(withIdentifier: "FarmSelectCell", for: indexPath) as! FarmSelectCell
        cell.initCell(farm: farms[indexPath.row], didSelect: farms[indexPath.row].isSelected)
        cell.accessibilityIdentifier = "farm_cell"
        return cell
    }
}

extension FarmSelectionViewController {
    static func getVc() -> FarmSelectionViewController {
        let farmStoryBoard = UIStoryboard(name: "FarmSelectionViewController", bundle: nil)
        return farmStoryBoard.instantiateViewController(withIdentifier: "FarmSelectionViewController") as! FarmSelectionViewController
    }
}

struct FilteredFarm {
    var isSelected: Bool
    let name: String
    let fieldIds: [Int]
    let type: FarmType
    let id: Int
}
