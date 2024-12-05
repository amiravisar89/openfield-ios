//
//  ImageryPopupViewController.swift
//  Openfield
//
//  Created by Daniel Kochavi on 08/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import NVActivityIndicatorView
import ReactorKit
import Resolver
import RxCocoa
import RxDataSources
import RxSwift
import RxSwiftExt
import STPopup
import SwiftDate
import UIKit

class ImageryPopupViewController: UIViewController {
    static let analyticName = "imagery_popup"

    @IBOutlet var imageryImagesTable: UITableView!
    @IBOutlet var staticTitle: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var closeButton: UIImageView!
    @IBOutlet var popupContent: UIView!
    @IBOutlet var loadingIndicator: NVActivityIndicatorView!

    var getImageryUsecase: GetImageryUsecase = Resolver.resolve()
    let farmFilter: FarmFilter = Resolver.resolve()
    let dateProvider: DateProvider = Resolver.resolve()
    var disposeBag: DisposeBag = .init()
    weak var flowController: ImageryFlowController!
    var allImageryDate: Date!
    var imagerySelected: Imagery!
    var imagesPresented: [ImageryImage]!
    var forceRefresh = false

    override func viewDidLoad() {
        setupTable()
        setupStaticColors()
        setupStaticText()
        loadImagery()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBarColor(color: .clear)
        setupClosingTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PerformanceManager.shared.stopTrace(for: .imagery_popup)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setStatusBarColor(color: .clear)
    }

    private func loadImagery() {
        Observable.combineLatest(getImageryUsecase.imageries(), farmFilter.farms).observeOn(MainScheduler.instance).subscribe { [weak self] imageris, farms in
            guard let self = self else { return }
            let imagerySelected = imageris.first(where: { imagery -> Bool in
                imagery.date.isTheSameWeek(as: self.allImageryDate)
            })
            let farmsSelected = farms.filter { $0.isSelected }
            guard imagerySelected != nil else { return }
            self.imagerySelected = imagerySelected
            self.imagesPresented = self.imagerySelected.images.sorted(by: { $0.date.dateTruncated(from: .hour) != $1.date.dateTruncated(from: .hour) ? ($0.date.dateTruncated(from: .hour) ?? $0.date) > ($1.date.dateTruncated(from: .hour) ?? $1.date) : $0.field.name.lowercased() < $1.field.name.lowercased() })
            self.imagesPresented = self.imagesPresented.filter { farmsSelected.compactMap { $0.name }.contains($0.field.farmName) }
            self.setupData()
        } onError: { _ in
            self.closePopup()
        }.disposed(by: disposeBag)
    }

    private func setupData() {
        imageryImagesTable.delegate = self
        imageryImagesTable.dataSource = self
        imageryImagesTable.reloadData()
        loadingIndicator.isHidden = true

        dateLabel.text = String(format: "%@ - %@ | %@", dateProvider.format(date: allImageryDate.startOfWeek, region: Region.local, format: .short), dateProvider.format(date: allImageryDate.endOfWeek, region: Region.local, format: .short), R.string.strings.fieldsCount(fields_count: UInt(imagesPresented.count)))
    }

    private func setupClosingTapGesture() {
        popupContent.layer.cornerRadius = 6
        popupContent.layer.masksToBounds = true
    }

    private func setupStaticColors() {
        popupContent.backgroundColor = R.color.white()
        loadingIndicator.color = R.color.valleyBrand()!
        loadingIndicator.type = .circleStrokeSpin
        loadingIndicator.startAnimating()
    }

    private func setupStaticText() {
        staticTitle.text = R.string.localizable.imageryNewImageryReceived()
    }

    private func setupTable() {
        imageryImagesTable.register(UINib(resource: R.nib.imageryPopupCellView), forCellReuseIdentifier: R.reuseIdentifier.imageryPopupCellView.identifier)
    }

    @objc private func closePopup() {
        flowController.navigationController.dismiss(animated: true, completion: nil)
    }

    private func navigateToAnalysis(imageryImage: ImageryImage) {
        closePopup()
        flowController.goToAnalysis(params: AnalysisParams(fieldId: imageryImage.field.id, initialDate: imageryImage.date, initialLayer: imageryImage.layer, origin: "imagery_popup"), animated: true)
    }

    func setup() {
        closeButton
            .rx
            .tapGesture()
            .when(.recognized)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] _ in
                EventTracker.track(event: AnalyticsEventFactory.buildDialogEvent(EventCategory.imageryPopup, ImageryPopupViewController.analyticName, false, [EventParamKey.origin: "button"]))
                self?.closePopup()
            }
            .disposed(by: disposeBag)
    }
}

extension ImageryPopupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImageryPopupCellView = tableView.dequeueReusableCell(withIdentifier: "ImageryPopupCellView", for: indexPath) as! ImageryPopupCellView
        cell.bind(to: imagesPresented[indexPath.row])
        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return imagesPresented.count
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        PerformanceManager.shared.startTrace(origin: .imagery_popup, target: .analysis)
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.imageryPopup,
                                                                   .imageryFieldClick, [EventParamKey.imageryDate: dateProvider.format(date: allImageryDate, format: .short),
                                                                                        EventParamKey.fieldId: "\(imagerySelected.images[indexPath.row].field.id)"]))
        navigateToAnalysis(imageryImage: imagesPresented[indexPath.row])
    }
}

extension ImageryPopupViewController {
    class func instantiate(with imageryDate: Date, forceRefresh: Bool = false, flowController: ImageryFlowController) -> ImageryPopupViewController {
        let vc = R.storyboard.imageryPopupViewController.imageryPopupViewController()!
        vc.flowController = flowController
        vc.allImageryDate = imageryDate
        vc.forceRefresh = forceRefresh
        return vc
    }
}

protocol HasImageryPopup: HasPopup {}
