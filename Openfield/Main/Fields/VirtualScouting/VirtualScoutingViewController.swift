//
//  VirtualScoutingViewController.swift
//  Openfield
//
//  Created by Yoni Luz on 13/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import ReactorKit
import Resolver
import RxCocoa
import RxDataSources
import RxSwift
import SwiftDate
import UIKit

final class VirtualScoutingViewController: UIViewController, StoryboardView {
  typealias Reactor = VirtualScoutingReactor
  var disposeBag = DisposeBag()

  weak var flowController: MainFlowController!
  var animationProvider: AnimationProvider!

  private let dateProvider: DateProvider = Resolver.resolve()

  @IBOutlet var guideView: GuideCustomView!
  @IBOutlet var backButton: UIButton!
  @IBOutlet var fieldName: BodyRegular!
  @IBOutlet var fieldImage: VirtualScoutingImageViewer!
  @IBOutlet var virtualScoutingCalendar: AppCalendarWithArrows!
  @IBOutlet var imagesGallery: AppImageGallery!
  @IBOutlet var fieldImageHolder: UIView!
  @IBOutlet var loadingContainer: UIView!
  @IBOutlet var loadingLabel: BodyRegular!
  @IBOutlet var loader: NVActivityIndicatorView!
  @IBOutlet var imageGalleryTitle: BodySemiBoldBrand!
  @IBOutlet var imageGalleryCloseBtn: UIButton!
  @IBOutlet var imageGalleryContainer: UIView!
  @IBOutlet var titleLabel: BodySemiBoldBlack!

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    PerformanceManager.shared.stopTrace(for: .virtual_scouting)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    flowController.setStatusBarStyle(style: .lightContent)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    flowController.setStatusBarStyle(style: .darkContent)
    loadingLabel.text = R.string.localizable.loading()
      titleLabel.text = R.string.localizable.virtualScoutingVirtualScoutingButton()
    loader.startAnimating()
  }

  lazy var endLoadingAnimation: Observable<Void> = animationProvider.animate(duration: 0.5, delay: .zero) { [weak self] in
    guard let self = self else { return }
    self.loadingContainer.alpha = .zero
  }

  func bind(reactor: VirtualScoutingReactor) {
    reactor.state.map { $0.field.name }
      .distinctUntilChanged()
      .bind(to: fieldName.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map { $0.isLoading }
      .distinctUntilChanged()
      .delay(.milliseconds(700), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] isLoading in
        if isLoading {
          self?.loadingContainer.alpha = 1
        } else {
          _ = self?.endLoadingAnimation.observeOn(MainScheduler.instance).subscribe()
        }
      })
      .disposed(by: disposeBag)

    let imagesObservable = reactor.state
      .compactMap { $0.coverImages }
      .distinctUntilChanged()

    let geojsonObservable = reactor.state
      .compactMap { $0.grid }
      .distinctUntilChanged()

    let datesObservable = reactor.state
      .compactMap { $0.dates }
      .distinctUntilChanged()

    let selectedDateObservable = reactor.state
      .compactMap { $0.selectedDate }
      .distinctUntilChanged()

    let imagesForGallery = reactor.state
      .map { $0.imagesForGallery }
      .distinctUntilChanged({ $0 }, comparer: { ($0.map { $0.images } == $1.map { $0.images }) })

  Observable.combineLatest(imagesObservable, geojsonObservable)
      .observeOn(MainScheduler.instance)
      .flatMapLatest { [weak self] (images: [ScoutingGridImage]?, grid: VirtualScoutingGrid?) -> Observable<([ScoutingGridImage]?, VirtualScoutingGrid?)> in
          guard let self = self, let images = images, let grid = grid else { return Observable.empty() }
          return self.fieldImage.displayWithObserver(images: images).flatMap { _ in
              return Observable.just((images, grid))
          }
      }
      .subscribe(onNext: { [weak self] (images: [ScoutingGridImage]?, grid: VirtualScoutingGrid?) in
          guard let self = self, let images = images, let grid = grid, let geojson = grid.geojson else { return }
          if let bounds = images.first?.bounds {
              self.fieldImage.drawGeoJson(geoJson: geojson, bounds: bounds)
          }
      }).disposed(by: disposeBag)


    Observable.combineLatest(datesObservable, selectedDateObservable)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] dates, selectedDate in
        guard let self = self else { return }
        let selectedDay = selectedDate.day
        let selectedDate = DateFormatter.iso8601DateOnly.date(from: selectedDay)!
        self.virtualScoutingCalendar.setDates(dates: dates.compactMap {
            $0.day.toDate()?.date
        }, selectedDate: selectedDate, region: Region.UTC)
      }).disposed(by: disposeBag)

    selectedDateObservable.observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] selectedDate in
        guard let self = self,
          let selectedDate = selectedDate.day.toDate()?.date else { return }
        self.imageGalleryTitle.text = dateProvider.format(date: selectedDate, region: Region.UTC, format: .short)
      }).disposed(by: disposeBag)

    imagesForGallery.observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] images in
          guard let self = self else { return }
          if self.imagesGallery.currentIndex() > 0 {
              self.imagesGallery.goToIndex(index: 0)
          }
          self.imagesGallery.setImages(images: images)
      }).disposed(by: disposeBag)

    fieldImageHolder.rx.tapGesture().when(.recognized)
      .observeOn(MainScheduler.instance)
      .subscribe { [weak self] gesture in
        guard let self = self else { return }
        let location = gesture.location(in: self.fieldImage.fieldImageView)
        self.fieldImage.updateSelectedCellColor(by: location)
      }.disposed(by: disposeBag)

    backButton.rx.tapGesture()
      .when(.recognized)
      .map { [weak self] _ in
        Reactor.Action.clickBack(navigationEffect: self?.navigateBack)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    virtualScoutingCalendar
      .dateSelected.map { Reactor.Action.selectedDate(dateWithType: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    fieldImage.cellSelected.map {
      self.showImagesGallery()
      self.closeGuideView(removeFromSuperview: false)
      return Reactor.Action.cellSelected(cellId: $0)
    }.bind(to: reactor.action)
      .disposed(by: disposeBag)

    // we report the event within the VirtualScoutingReactor
    fieldImage.reportZoomEvent = false
    fieldImage.imageDidZoom.throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
      .map { Reactor.Action.analyticsZoomMap(zoomScale: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    imageGalleryCloseBtn.rx.tapGesture()
      .when(.recognized)
      .map { [weak self] _ in
        Reactor.Action.clickCloseGallery(closeEffect: self?.clickCloseGallery)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    imagesGallery.indexSelected.map { [weak self] index in
      Reactor.Action.imageSelected(index: index, navigationEffect: self?.navigateToImages)
    }
    .bind(to: reactor.action)
    .disposed(by: disposeBag)

    imagesGallery.indexDisplayed.map { index in
      Reactor.Action.imageDisplay(index: index, displayType: ImageDisplayType.preview)
    }
    .bind(to: reactor.action)
    .disposed(by: disposeBag)

    guideView.closeButtonClick
      .subscribe(onNext: { [weak self] in
        self?.closeGuideView()
      })
      .disposed(by: disposeBag)
      
      rx.viewDidAppear.map { _ in Reactor.Action.reportScreenView }
          .bind(to: reactor.action)
          .disposed(by: disposeBag)
  }

  private func closeGuideView(removeFromSuperview: Bool = true) {
    UIView.animate(withDuration: 0.3, animations: {
      self.guideView.alpha = 0.0
      self.guideView.transform = CGAffineTransform(translationX: 0, y: 50)
    }, completion: { _ in
      if removeFromSuperview {
        self.guideView.removeFromSuperview()
      }
    })
  }

  private func showGuideView() {
    if guideView.superview != nil {
      guideView.transform = CGAffineTransform(translationX: 0, y: 50)
      UIView.animate(withDuration: 0.3, animations: {
        self.guideView.alpha = 1.0
        self.guideView.transform = CGAffineTransform(translationX: 0, y: 0)
      })
    }
  }

  private func closeImagesGallery(removeFromSuperview _: Bool = true) {
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.imageGalleryContainer.alpha = 0.0
      self?.imageGalleryContainer.transform = CGAffineTransform(translationX: 0, y: 50)
    }, completion: { [weak self] _ in
      self?.imageGalleryContainer.isHidden = true
      self?.imagesGallery.setImages(images: [])
    })
  }

  private func showImagesGallery() {
    if imageGalleryContainer.isHidden {
      imageGalleryContainer.isHidden = false
      imageGalleryContainer.alpha = 0.0
      imageGalleryContainer.transform = CGAffineTransform(translationX: 0, y: 200)
      UIView.animate(withDuration: 0.3, animations: { [weak self] in
        self?.imageGalleryContainer.alpha = 1.0
        self?.imageGalleryContainer.transform = CGAffineTransform(translationX: 0, y: 0)
      })
    }
  }

  private func navigateBack() {
    flowController.pop()
  }

  private func clickCloseGallery() {
    fieldImage.focus(zoomScale: 1, animation: true)
    closeImagesGallery()
    fieldImage.resetSelectedCell()
    showGuideView()
  }

  private func navigateToImages(data: TagedImagesViewModel) {
    let vc = TagsImagesViewController.instantiate(data: data)
    if let reactor = reactor {
      vc.imageWillDisplayAtIndex?
        .do { [weak self] index in
          self?.imagesGallery.goToIndex(index: index, animated: false)
        }
        .flatMap { index in
          Observable.just(Reactor.Action.imageDisplay(index: index, displayType: ImageDisplayType.fullsize))
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)

      vc.imageZoom.compactMap { $0 }
        .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        .map { Reactor.Action.analyticsZoomOnFullImage(index: $0.imageIndex, zoomScale: $0.zoomScale) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)

      vc.imageNavigation.compactMap { $0 }
        .distinctUntilChanged()
        .map { Reactor.Action.analyticsNavigationToImageLocation(index: $0) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
    flowController?.present(vc, animated: true)
  }
}

extension VirtualScoutingViewController {
  class func instantiate(field: Field, cycleId: Int, flowController: MainFlowController, animationProvider: AnimationProvider) -> VirtualScoutingViewController {
    let vc = R.storyboard.virtualScoutingViewController.virtualScoutingViewController()!
    vc.flowController = flowController
    vc.animationProvider = animationProvider
    vc.reactor = Resolver.optional(args: [field, cycleId])
    return vc
  }
}
