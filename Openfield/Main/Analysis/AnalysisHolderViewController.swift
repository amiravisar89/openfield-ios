//
//  AnalysisHolderViewController.swift
//  Openfield
//
//  Created by amir avisar on 01/07/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import FirebaseAnalytics
import PullUpController
import ReactorKit
import Resolver
import RxSwift
import UIKit

class AnalysisHolderViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var headerContainer: UIView!
    @IBOutlet private var screenTitle: UILabel!
    @IBOutlet private var subtitle: UILabel!
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet var viewControllersTableView: UITableView!
    @IBOutlet var compareBtn: UIButton!

    // MARK: - Members

    var disposeBag = DisposeBag()
    var anlysysParam: AnalysisParams!
    weak var mainAnlysisViewController: AnalysisViewController!
    let fieldUseCase: FieldUseCase = Resolver.resolve()
    weak var compareAnlysisViewController: AnalysisViewController?
    var viewControllersArray: [UIViewController] = .init()
    var isCompareMode = false {
        didSet {
            if isCompareMode {
                guard let mainReactor = mainAnlysisViewController.reactor else { return }
                anlysysParam = mainReactor.anlysysParam
                anlysysParam.forceInitialDate = true
                compareAnlysisViewController = AnalysisViewController.instantiate(with: Resolver.resolve(args: anlysysParam))
                compareAnlysisViewController?.delegate = self
                insertTableCell(viewControler: compareAnlysisViewController!, animation: .top)
            } else {
                deleteTableCell(viewControler: compareAnlysisViewController!, animation: .top)
                compareAnlysisViewController = nil
            }
            compareAnlysisViewController?.toggleCompare(isCompare: isCompareMode, isMain: false)
            mainAnlysisViewController?.toggleCompare(isCompare: isCompareMode, isMain: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStaticText()
        setupHeader()
        setupStaticColor()
        mainAnlysisViewController = AnalysisViewController.instantiate(with: Resolver.resolve(args: anlysysParam))
        mainAnlysisViewController.delegate = self
        viewControllersArray.append(mainAnlysisViewController)
        initTableView()
        setUpActions()
        generateAccessibilityIdentifiers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        compareBtn.isUserInteractionEnabled = true
        PerformanceManager.shared.stopTrace(for: .analysis)
    }

    private func setupStaticText() {
        screenTitle.text = R.string.localizable.analysisAnalysisMode()
    }

    private func setUpActions() {
        compareBtn.rx
            .tapGesture()
            .when(.recognized)
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.analysis, .compareButtonclick))
                self?.isCompareMode = !(self?.isCompareMode ?? false)
                self?.handleCompareButton(isCompare: self?.isCompareMode ?? false)
            })
            .disposed(by: disposeBag)
    }

    private func setupHeader() {
        _ = fieldUseCase.getFieldWithoutImages(fieldId: anlysysParam.fieldId).observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] field in
        self?.subtitle.text = "\(field.farmName) / \(field.name.capitalize())"
        }, onError: { _ in
            log.error("Failed to implement analysisHeader logic")
        }, onCompleted: nil, onDisposed: nil)

        headerContainer.layer.borderWidth = 1.0
        headerContainer.layer.borderColor = R.color.lightGrey()!.cgColor
    }

    private func handleCompareButton(isCompare: Bool) {
        compareBtn?.setImage(isCompare ? UIImage(named: "compare_icon_blue") : UIImage(named: "compare_icon"), for: .normal)
        compareBtn?.backgroundColor = isCompare ? R.color.valleyBrand() : .clear
    }

    func synchronizeScrollView(_ scrollViewToScroll: UIScrollView, toScrollView scrolledView: UIScrollView) {
        DispatchQueue.main.async {
            scrollViewToScroll.setContentOffset(scrolledView.contentOffset, animated: false)
            scrollViewToScroll.setZoomScale(scrolledView.zoomScale, animated: false)
        }
    }

    func synchronizeZoomScrollView(scrollView: UIScrollView, toRect: CGRect) {
        DispatchQueue.main.async {
            scrollView.zoom(to: toRect, animated: true)
        }
    }

    private func setupStaticColor() {
        headerContainer.backgroundColor = R.color.white()
    }

    // insert viewControllersArray and tableView (only to first!)
    func insertTableCell(viewControler: UIViewController, animation: UITableView.RowAnimation) {
        viewControllersArray.insert(viewControler, at: 0)
        viewControllersTableView.beginUpdates()
        viewControllersTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: animation)
        viewControllersTableView.endUpdates()
    }

    // delete viewControllersArray and tableView (only the first!)
    func deleteTableCell(viewControler _: UIViewController, animation: UITableView.RowAnimation) {
        viewControllersArray.removeFirst()
        viewControllersTableView.beginUpdates()
        viewControllersTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: animation)
        viewControllersTableView.endUpdates()
    }

    // MARK: - Actions

    @IBAction func closeAction(_: Any) {
        dismiss(animated: true)
    }

    @IBAction func compareAction(_: Any) {
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.analysis, .compareButtonclick))
        isCompareMode = !isCompareMode
        handleCompareButton(isCompare: isCompareMode)
    }
}

// MARK: - UITableViewDelegate

extension AnalysisHolderViewController: UITableViewDelegate, UITableViewDataSource {
    func initTableView() {
        viewControllersTableView.register(UINib(nibName: "CompareCell", bundle: nil), forCellReuseIdentifier: "CompareCell")
        viewControllersTableView.delegate = self
        viewControllersTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        if isCompareMode {
            return tableView.frame.height * 0.5
        } else {
            return tableView.frame.height
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewControllersArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CompareCell = tableView.dequeueReusableCell(withIdentifier: "CompareCell", for: indexPath) as! CompareCell
        cell.initCell(viewController: viewControllersArray[indexPath.row], parent: self)
        return cell
    }
}

// MARK: - AnalysisViewControllerDelegate

extension AnalysisHolderViewController: AnalysisViewControllerDelegate {
    func scrollViewDidTapZoom(scrollView: UIScrollView, toRect: CGRect) {
        guard let compareScroll = compareAnlysisViewController?.fieldImage.getScrollView() else {
            return
        }
        if scrollView == compareScroll {
            synchronizeZoomScrollView(scrollView: mainAnlysisViewController.fieldImage.getScrollView(), toRect: toRect)
        } else {
            synchronizeZoomScrollView(scrollView: compareScroll, toRect: toRect)
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let compareScroll = compareAnlysisViewController?.fieldImage.getScrollView() else {
            return
        }
        if scrollView == compareScroll {
            synchronizeScrollView(mainAnlysisViewController.fieldImage.getScrollView(), toScrollView: compareScroll)
        } else if scrollView == mainAnlysisViewController.fieldImage.getScrollView() {
            synchronizeScrollView(compareScroll, toScrollView: mainAnlysisViewController.fieldImage.getScrollView())
        }
    }

    func compareClick() {
        isCompareMode = !isCompareMode
    }
}

// MARK: - Initiate

extension AnalysisHolderViewController {
    class func instantiate(with reactorParam: AnalysisParams) -> AnalysisHolderViewController {
        let vc = R.storyboard.analysisHolderViewController.analysisHolderViewController()!
        vc.anlysysParam = reactorParam
        return vc
    }
}
