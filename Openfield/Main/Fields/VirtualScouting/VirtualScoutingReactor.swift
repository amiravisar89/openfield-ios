//
//  VirtualScoutingReactor.swift
//  Openfield
//
//  Created by Yoni Luz on 13/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import ReactorKit
import Resolver
import RxSwift
import Then
import FirebaseAnalytics

class VirtualScoutingReactor: Reactor {
  var initialState: VirtualScoutingReactor.State
  let virtualScoutingDatesUseCase: VirtualScoutingDatesUseCaseProtocol
  let virtualScoutingGridUsecase: VirtualScoutingGridUsecaseProtocol
  let virtualScoutingImagesUsecase: VirtualScoutingImagesUsecaseProtocol
  let getImagesGalleryImageSizeUseCase: GetImagesGalleryImageSizeUseCaseProtocol

  let field: Field
  let cycleId: Int
  let disposeBag = DisposeBag()

  init(field: Field, cycleId: Int,
       virtualScoutingDatesUseCase: VirtualScoutingDatesUseCaseProtocol,
       virtualScoutingGridUsecase: VirtualScoutingGridUsecaseProtocol,
       virtualScoutingImagesUsecase: VirtualScoutingImagesUsecaseProtocol,
       getImagesGalleryImageSizeUseCase: GetImagesGalleryImageSizeUseCaseProtocol)
  {
    initialState = VirtualScoutingReactor.State(field: field)
    self.virtualScoutingDatesUseCase = virtualScoutingDatesUseCase
    self.virtualScoutingGridUsecase = virtualScoutingGridUsecase
    self.virtualScoutingImagesUsecase = virtualScoutingImagesUsecase
    self.getImagesGalleryImageSizeUseCase = getImagesGalleryImageSizeUseCase
    self.field = field
    self.cycleId = cycleId
    virtualScoutingDatesUseCase.getDates(fieldId: field.id, cycleId: cycleId).flatMap { dates in
      var virtualScoutingGridObservable: Observable<VirtualScoutingGrid>
      let selectedDate = dates.first(where: { $0 == self.currentState.selectedDate }) ?? dates.last
      if !dates.isEmpty {
        virtualScoutingGridObservable = self.virtualScoutingGridUsecase.getGrid(gridId: String(selectedDate!.gridId))
      } else {
        virtualScoutingGridObservable = .empty()
      }
      return Observable.combineLatest(
        Observable.just(dates),
        Observable.just(selectedDate),
        virtualScoutingGridObservable
      )
    }.map {
      .setData(dates: $0, selectedDate: $1, grid: $2)
    }
    .bind(to: action)
    .disposed(by: disposeBag)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .clickBack(navigationEffect):
      reportBackClick()
      navigationEffect?()
      return Observable.empty()
    case let .setData(dates: dates, selectedDate: selectedDate, grid: grid):
      return Observable.concat(
        .just(.setLoading(isLoading: false)),
        .just(.setDates(dates: dates)),
        .just(.setVirtualScoutingGrid(grid: grid)),
        .just(.setSelectedDate(date: selectedDate))
      )
    case let .selectedDate(dateWithType):
      reportSelectDate(dateWithType: dateWithType)
      let selectedDay = DateFormatter.iso8601DateOnly.string(from: dateWithType.date)
      if let selectedDate = currentState.dates.first(where: { $0.day == selectedDay }) {
        let gridMutationObservable = virtualScoutingGridUsecase.getGrid(gridId: String(selectedDate.gridId)).map { grid in
          Mutation.setVirtualScoutingGrid(grid: grid)
        }
        return Observable.concat(
          .just(.setSelectedDate(date: selectedDate)),
          gridMutationObservable
        )
      } else {
        return Observable.empty()
      }
    case let .cellSelected(cellId):
      return virtualScoutingImagesUsecase.getImages(cellId: cellId).flatMap { images in
        self.reportSelectCell(cellId, imageCount: images.count)
        return Observable.concat(.just(Mutation.setSelectedCell(cellId: cellId)), .just(Mutation.setCellImages(images: images)))
      }
    case let .clickCloseGallery(closeEffect):
      closeEffect?()
      reportCloseGallery()
      return .just(Mutation.setCellImages(images: []))
    case let .imageSelected(index, navigationEffect):
      let tagedImagesViewModel = currentState.cellImages.map { image in
        let isNightImage = self.isNightImage(image)
        let largImage = AppImage(height: image.height, width: image.width, url: image.imageURL)
        var images = [largImage]
        if let thumbnail = image.thumbnail { images.insert(AppImage(height: thumbnail.height, width: thumbnail.width, url: thumbnail.url), at: .zero) }
          return TagedImageViewModel(fieldId: field.id, farmId: field.farmId, cycleId: cycleId, imageId: image.id, context: "virtual_scouting", issueId: image.cycleID, images: images, onClickUrl: getLocationUrl(latitude: image.latitude, longitude: image.longitude), date: image.tsTaken.dateValue().in(region: self.field.region), tags: [], isNightImage: isNightImage)
      }
      reportSelectImage(imageId: tagedImagesViewModel[index].imageId)
      navigationEffect?(TagedImagesViewModel(issueColor: UIColor.black, name: "", insight: nil, initialIndex: index, tagedImagesViewModel: tagedImagesViewModel, showNavigationTip: false))
      return Observable.empty()
    case let .imageDisplay(index, displayType):
      reportImageDisplay(index: index, displayType: displayType)
      return Observable.empty()
    case let .analyticsZoomOnFullImage(index, zoomScale):
      reportZoomOnFullImage(index: index, zoomScale: zoomScale)
      return Observable.empty()
    case let .analyticsNavigationToImageLocation(index):
      reportNavigationToImageLocation(index: index)
      return Observable.empty()
    case let .analyticsZoomMap(zoomScale):
      reportZoomMapImage(zoomScale: zoomScale)
      return Observable.empty()
    case .reportScreenView:
        let screenViewParams = [AnalyticsParameterScreenName: ScreenName.virtualScouting,
                               AnalyticsParameterScreenClass: String(describing: VirtualScoutingViewController.self),
                                EventParamKey.category: EventCategory.virtualScouting,
                                EventParamKey.fieldId: field.id,
                                EventParamKey.farmId: field.farmId,
                                EventParamKey.cycleId: cycleId
        ] as [String : Any]
        Analytics.logEvent(AnalyticsEventScreenView, parameters: screenViewParams)
        return Observable.empty()
    }
  }

  func reduce(state: VirtualScoutingReactor.State, mutation: VirtualScoutingReactor.Mutation) -> VirtualScoutingReactor.State {
    switch mutation {
    case let .setDates(dates: dates):
      return state.with {
        $0.dates = dates
      }
    case let .setVirtualScoutingGrid(grid: grid):
      return state.with { s in
        s.grid = grid
        s.coverImages = grid?.coverImages.filter { image in
          image.imageType == s.selectedImageType
        }
      }
    case let .setSelectedDate(date: date):
      return state.with {
        $0.selectedDate = date
      }

    case let .setCellImages(images: images):
      let imageSize = getImagesGalleryImageSizeUseCase.size()
      return state.with {
        $0.cellImages = images
        $0.imagesForGallery = images.map { image in
          let isNightImage = self.isNightImage(image)
          var url = image.thumbnail?.url ?? image.imageURL
          if imageSize > 0 {
            url += "?width=\(imageSize)"
          }
          let appImage = AppImage(height: image.thumbnail?.height ?? image.height, width: image.thumbnail?.width ?? image.width, url: url)
          return AppImageGalleyElement(images: [appImage], isNightImage: isNightImage, tags: [], dotColor: UIColor.clear, subtitle: "", showSubtitleContainer: false)
        }
      }
    case let .setSelectedCell(celldId):
      return state.with {
        $0.selectedCellId = celldId
      }
    case let .setLoading(isLoading: isLoading):
      return state.with {
        $0.isLoading = isLoading
      }
    }
  }

  enum Action {
    case setData(dates: [VirtualScoutingDate], selectedDate: VirtualScoutingDate?, grid: VirtualScoutingGrid?)
    case clickBack(navigationEffect: SideEffect)
    case selectedDate(dateWithType: DateWithType)
    case cellSelected(cellId: Int)
    case clickCloseGallery(closeEffect: SideEffect)
    case imageSelected(index: Int, navigationEffect: ((TagedImagesViewModel) -> Void)?)
    case imageDisplay(index: Int, displayType: ImageDisplayType)
    case analyticsZoomOnFullImage(index: Int, zoomScale: CGFloat)
    case analyticsNavigationToImageLocation(index: Int)
    case analyticsZoomMap(zoomScale: CGFloat)
    case reportScreenView
  }

  enum Mutation {
    case setDates(dates: [VirtualScoutingDate])
    case setVirtualScoutingGrid(grid: VirtualScoutingGrid?)
    case setSelectedDate(date: VirtualScoutingDate?)
    case setCellImages(images: [VirtualScoutingImage])
    case setSelectedCell(cellId: Int)
    case setLoading(isLoading: Bool)
  }

  struct State: Then {
    let field: Field
    var coverImages: [ScoutingGridImage]? = nil
    var selectedDate: VirtualScoutingDate? = nil
    var selectedCellId: Int? = nil
    var dates: [VirtualScoutingDate] = []
    var grid: VirtualScoutingGrid? = nil
    var selectedImageType: AppImageType = .rgb
    var cellImages: [VirtualScoutingImage] = []
    var isLoading = true
    var imagesForGallery: [AppImageGalleyElement] = []
  }

  private func isNightImage(_ image: VirtualScoutingImage) -> Bool {
    return image.labels != nil && ((image.labels?.contains(where: { $0 == ImageLable.nightImage.rawValue })) ?? false)
  }

  private func reportBackClick() {
    EventTracker.track(event: AnalyticsEventFactory
      .buildClickEvent(EventCategory.virtualScouting, "back_from_vs_to_field",
                       [EventParamKey.fieldId: String(field.id),
                        EventParamKey.currentCycle: String(cycleId)]))
  }

  private func reportSelectDate(dateWithType: DateWithType) {
    EventTracker.track(event: AnalyticsEventFactory
      .buildClickEvent(EventCategory.virtualScouting, "virtual_scouting_\(dateWithType.dateSelectType.rawValue)_date",
                       [EventParamKey.fieldId: String(field.id),
                        EventParamKey.currentCycle: String(cycleId),
                        "from_date": currentState.selectedDate?.day ?? "",
                        "to_date": DateFormatter.iso8601DateOnly.string(from: dateWithType.date)]))
  }

  private func reportImageDisplay(index: Int, displayType: ImageDisplayType) {
    var itemId: String
    switch displayType {
    case .fullsize:
      itemId = "virtual_scouting_view_image_fullsize"
    case .preview:
      itemId = "virtual_scouting_gallery_image_preview"
    }
    let imageId = currentState.cellImages[index].id
    EventTracker.track(event: AnalyticsEventFactory
      .buildEvent(EventCategory.virtualScouting, .impression,
                  [EventParamKey.itemId: itemId,
                   EventParamKey.fieldId: String(field.id),
                   EventParamKey.currentCycle: String(cycleId),
                   "image_id": String(imageId),
                   "cell_id": String(currentState.selectedCellId ?? 0)]))
  }

  private func reportSelectImage(imageId: Int) {
    EventTracker.track(event: AnalyticsEventFactory
      .buildClickEvent(EventCategory.virtualScouting, "virtual_scouting_gallery_select_image",
                       [EventParamKey.fieldId: String(field.id),
                        EventParamKey.currentCycle: String(cycleId),
                        "image_id": String(imageId),
                        "cell_id": String(currentState.selectedCellId ?? 0)]))
  }

  private func reportSelectCell(_ cellId: Int, imageCount: Int) {
    EventTracker.track(event: AnalyticsEventFactory
      .buildEvent(EventCategory.virtualScouting, .mapClick,
                  [EventParamKey.fieldId: String(field.id),
                   EventParamKey.currentCycle: String(cycleId),
                   EventParamKey.itemId: "virtual_scouting_select_cell",
                   "date": currentState.selectedDate?.day ?? "",
                   "cell_id": String(cellId),
                   "image_count": String(imageCount)]))
  }

  private func reportCloseGallery() {
    EventTracker.track(event: AnalyticsEventFactory
      .buildClickEvent(EventCategory.virtualScouting, "virtual_scouting_close_cell_gallery",
                       [EventParamKey.fieldId: String(field.id),
                        EventParamKey.currentCycle: String(cycleId),
                        "date": currentState.selectedDate?.day ?? "",
                        "cell_id": String(currentState.selectedCellId ?? 0),
                        "image_count": String(currentState.cellImages.count)]))
  }

  private func reportZoomOnFullImage(index: Int, zoomScale: CGFloat) {
    let imageId = currentState.cellImages[index].id
    EventTracker.track(event: AnalyticsEventFactory
      .buildEvent(EventCategory.virtualScouting, .imageZoom,
                  [EventParamKey.itemId: "virtual_scouting_zoom_full_image",
                   EventParamKey.fieldId: String(field.id),
                   EventParamKey.currentCycle: String(cycleId),
                   "zoom_scale": zoomScale.description,
                   "image_id": String(imageId),
                   "cell_id": String(currentState.selectedCellId ?? 0)]))
  }

  private func reportZoomMapImage(zoomScale: CGFloat) {
    EventTracker.track(event: AnalyticsEventFactory
      .buildEvent(EventCategory.virtualScouting, .imageZoom,
                  [EventParamKey.itemId: "virtual_scouting_map_zoom",
                   EventParamKey.fieldId: String(field.id),
                   EventParamKey.currentCycle: String(cycleId),
                   "zoom_scale": zoomScale.description]))
  }

  private func reportNavigationToImageLocation(index: Int) {
    let imageId = currentState.cellImages[index].id
    EventTracker.track(event: AnalyticsEventFactory
      .buildClickEvent(EventCategory.virtualScouting, "virtual_scouting_navigate_to_location",
                       [EventParamKey.fieldId: String(field.id),
                        EventParamKey.currentCycle: String(cycleId),
                        "cell_id": String(currentState.selectedCellId ?? 0),
                        "image_id": String(imageId)]))
  }

  private func getLocationUrl(latitude: Double?, longitude: Double?) -> URL? {
    guard let latitude = latitude,
          let longitude = longitude,
          let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(String(latitude)),\(String(longitude))") else { return nil }
    return url
  }
}

enum ImageDisplayType: String {
  case preview
  case fullsize
}
