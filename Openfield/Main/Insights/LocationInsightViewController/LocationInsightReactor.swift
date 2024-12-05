//
//  LocationInsightReactor.swift
//  Openfield
//
//  Created by Itay Kaplan on 31/12/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import ReactorKit
import Resolver
import RxCocoa
import RxSwift
import Then
import UIKit

typealias SideEffect = (() -> Void)?

final class LocationInsightReactor: Reactor {
    // MARK: - Members

    let originScreen: String
    var initialState: State
    let disposeBag = DisposeBag()
    let updateUserParamsUsecase: UpdateUserParamsUsecaseProtocol
    let dateProvider: DateProvider
    let remoteConfigRepository: RemoteConfigRepository
    let singleIssueCardProvider: LocationInsightSingleIssueCardProvider
    let locationsFromInsightUsecase : LocationsFromInsightUsecaseProtocol
    var locationInsightColorProviders: [LocationColorProvider]
    let getSupportedInsightUseCase : GetSupportedInsightUseCaseProtocol
    let isUserFieldOwnerUsecase: IsUserFieldOwnerUseCaseProtocol
    var colorProvider: LocationColorProvider? {
        return locationInsightColorProviders.first(where: { $0.canProvide(for: currentState.locationInsight) })
    }
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .userInitiated)
    
    init(locationInsight: LocationInsight, locationColorProviders: [LocationColorProvider],
         locationInsightSingleIssueCardProvider: LocationInsightSingleIssueCardProvider, dateProvider: DateProvider, originScreen: String, locationsFromInsightUsecase : LocationsFromInsightUsecaseProtocol, remoteConfigRepository: RemoteConfigRepository,
         getSupportedInsightUseCase : GetSupportedInsightUseCaseProtocol, updateUserParamsUsecase: UpdateUserParamsUsecaseProtocol,
            isUserFieldOwnerUsecase: IsUserFieldOwnerUseCaseProtocol)
      {
        self.updateUserParamsUsecase = updateUserParamsUsecase
        self.dateProvider = dateProvider
        self.locationsFromInsightUsecase = locationsFromInsightUsecase
        self.remoteConfigRepository = remoteConfigRepository
        self.getSupportedInsightUseCase = getSupportedInsightUseCase
        self.isUserFieldOwnerUsecase = isUserFieldOwnerUsecase
        let isWelcomeInsight = locationInsight.uid == WelcomeInsightsIds.locationInsight.rawValue
        initialState = State(pinAlwaysOn: locationInsight is SingleLocationInsight, showWalkThrough: isWelcomeInsight, isWelcomeInsight: isWelcomeInsight, locationInsight: locationInsight)
        locationInsightColorProviders = locationColorProviders
        singleIssueCardProvider = locationInsightSingleIssueCardProvider
        self.originScreen = originScreen
        Observable.concat([
            Observable.just(Action.initLocationData),
            Observable.just(Action.analyticsInsightView),
        ]).bind(to: action)
            .disposed(by: disposeBag)
        
        isUserFieldOwnerUsecase.isUserField(fieldId: locationInsight.fieldId).map{Action.initFieldOwner(isOwner: $0)}
          .bind(to: action)
          .disposed(by: disposeBag)
    }
        
    // MARK: State

    struct State: Then {
        var pinAlwaysOn: Bool
        var showWalkThrough: Bool
        var isWelcomeInsight: Bool
        fileprivate(set) var singleIssueGalleryImages = [LocationImageMeatadata]()
        var locationInsight: LocationInsight
        var allLocations: [Location]? = nil
        var selectedLocationCardIndex = 0
        var selectedSingleIssueImageIndex = 0
        var isFieldOwner = false

        // Compute
        var selectedImage: LocationImageMeatadata? {
            guard singleIssueGalleryImages.indices.contains(selectedSingleIssueImageIndex) else {
                return nil
            }
            return singleIssueGalleryImages[selectedSingleIssueImageIndex]
        }

        var selectedIssueItemIndex: Int? {
            return selectedLocationCardIndex > 0 ? selectedLocationCardIndex - 1 : nil
        }

        var selectedLocation: Location? {
            guard singleIssueGalleryImages.indices.contains(selectedSingleIssueImageIndex) else {
                return nil
            }
            return allLocations?.filter { location -> Bool in
                location.images.contains { locationImage -> Bool in
                    locationImage.id == selectedImage?.id
                }
            }.first
        }
    }

    // MARK: - Actions

    enum Action {
        case initFieldOwner(isOwner: Bool)
        case clickBack(navigationEffect: SideEffect)
        case initLocationData
        case openLocationIssueGallery(imageIndex: Int, sideEffect: SideEffect, showPin: SideEffect)
        case closeLocationIssueGallery(sideEffect: SideEffect, hidePin: SideEffect)
        case navigateToLocation(sideEffect: (URL) -> Void)
        case selectIssueImage(index: Int, navigationEffect: ((TagedImagesViewModel) -> Void)?)
        case selectCard(index: Int)
        case openOverviewInfo(sideEffect: ((String, [OverviewInformationView.InfoDataElement]) -> Void)?)
        case analyticsInsightView
        case analyticsViewIssueCard(issueIndex: Int)
        case analyticsClickIssueCard(issueIndex: Int)
        case analyticsViewLocationImage(imageId: Int, issueId: Int, imageIndex: Int)
        case analyticsZoomOnLocationImage(imageId: Int, issueId: Int, imageIndex: Int)
        case analyticsNavigationToImageLocation(imageId: Int, issueId: Int, imageIndex: Int)
    }

    // MARK: - Muatation

    enum Mutation {
        case setLocationData(locations: [Location], images: [LocationImageMeatadata])
        case setIsFieldOwner(isFieldOwner: Bool)
        case setLocationIssueGallery(issueGalleryImages: [LocationImageMeatadata])
        case setSelectedIssueImageIndex(index: Int)
        case setSelectedCardIndex(index: Int)
        case setShowWalkThrough(_ show: Bool)
        case unChange
    }



    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .initFieldOwner(isOwner):
            return Observable.just(Mutation.setIsFieldOwner(isFieldOwner: isOwner))
        case let .selectCard(index):
            let galleryImages = caluculateLocationImagesGallery(byLocations: currentState.allLocations, forIssueIndex: index, forInsight: currentState.locationInsight)
            return Observable.concat(.just(Mutation.setSelectedCardIndex(index: index)),
                                     .just(Mutation.setLocationIssueGallery(issueGalleryImages: galleryImages)),
                                     .just(Mutation.setSelectedIssueImageIndex(index: 0)))

        case let .clickBack(navigationEffect):
            navigationEffect?()
            return .empty()

        case let .openLocationIssueGallery(imageIndex, sideEffect, showPin):
            sideEffect?()
            showPin?()
            let selectedIssueItemIndex = currentState.selectedIssueItemIndex ?? 0
            guard currentState.singleIssueGalleryImages.indices.contains(imageIndex) && currentState.locationInsight.items.indices.contains(selectedIssueItemIndex)
            else { return .empty() }
            let image = currentState.singleIssueGalleryImages[imageIndex]
            let issue = currentState.locationInsight.items[selectedIssueItemIndex].id
            reportClickOnImageGallery(imageId: image.id, issueId: issue, imageIndex: imageIndex, locationInsight: currentState.locationInsight)
            return .just(.setSelectedIssueImageIndex(index: imageIndex))

        case let .closeLocationIssueGallery(sideEffect, hidePin):
            sideEffect?()
            currentState.pinAlwaysOn ? nil : hidePin?()
            return .empty()

        case let .selectIssueImage(index: index, navigationEffect: effect):
            if currentState.selectedSingleIssueImageIndex == index,
               let _ = currentState.selectedImage,
               let navigationEffect = effect
            {
                let tagedImagesViewModel: [TagedImageViewModel] = currentState.singleIssueGalleryImages.map {
                    let selectedLocation = currentState.selectedLocation
                    let locationImage = self.getLocation(byImage: $0) ?? (lat: selectedLocation?.latitude, lon: selectedLocation?.longitude)
                    return TagedImageViewModel(
                        fieldId: currentState.locationInsight.fieldId,
                        farmId: currentState.locationInsight.farmId,
                        cycleId: currentState.locationInsight.cycleId,
                        imageId: $0.id,
                        context: "plants",
                        issueId: $0.itemId,
                        images: $0.previews,
                        onClickUrl: getLocationUrl(latitude: locationImage.lat, longitude: locationImage.lon),
                        date: Date(timeIntervalSince1970: TimeInterval($0.date)).in(region: currentState.locationInsight.dateRegion),
                        tags: $0.tags, 
                        isNightImage: $0.isNightImage
                    )
                }
                let selectedIssueItemIndex = currentState.selectedIssueItemIndex ?? 0
                navigationEffect(TagedImagesViewModel(
                    issueColor: colorProvider?.getColor(forItemAtIndex: currentState.selectedIssueItemIndex, forInsight: currentState.locationInsight, locationSelected: nil) ?? R.color.valleyBrand()!,
                    name: currentState.locationInsight.items.count > selectedIssueItemIndex ? currentState.locationInsight.items[selectedIssueItemIndex].name : "",
                    insight: currentState.locationInsight,
                    initialIndex: index,
                    tagedImagesViewModel: tagedImagesViewModel,
                    showNavigationTip: currentState.showWalkThrough
                ))
            }
            let selectIssueImageMutation = Mutation.setSelectedIssueImageIndex(index: index)
            if currentState.showWalkThrough {
                return Observable.concat(
                    .just(.setShowWalkThrough(false)),
                    .just(selectIssueImageMutation)
                )
            }
            return .just(selectIssueImageMutation)

        case let .openOverviewInfo(sideEffect: effect):
            let insightCategory = currentState.locationInsight.category
            let overviewTitle = currentState.locationInsight is SingleLocationInsight ? R.string.localizable.insightFirstDetection() : currentState.locationInsight.subject

            if let insightOverviewInfo = getSupportedInsightUseCase.supportedInsights()[insightCategory]?.insightExplanation {
                let infoData = insightOverviewInfo.map { OverviewInformationView.InfoDataElement(title: $0.title, subtitle: $0.subTitle) }
                effect?(overviewTitle, infoData)
            }
            reportOverview(issueIndex: currentState.selectedIssueItemIndex ?? 0, locationInsight: currentState.locationInsight)
            return .empty()

        case let .analyticsViewIssueCard(issueIndex: issueIndex):
            reportViewIssueCard(issueIndex: issueIndex, locationInsight: currentState.locationInsight)
            return .empty()

        case let .analyticsClickIssueCard(issueIndex: issueIndex):
            reportClickOnIssueCard(issueIndex: issueIndex, locationInsight: currentState.locationInsight)
            return .empty()

        case let .analyticsViewLocationImage(imageId: imageId, issueId: issueId, imageIndex: imageIndex):
            reportViewLocationImage(imageId: imageId, issueId: issueId, imageIndex: imageIndex, locationInsight: currentState.locationInsight)
            return .empty()

        case let .analyticsZoomOnLocationImage(imageId: imageId, issueId: issueId, imageIndex: imageIndex):
            reportZoomOnLocationImage(imageId: imageId, issueId: issueId, imageIndex: imageIndex, locationInsight: currentState.locationInsight)
            return .empty()

        case let .analyticsNavigationToImageLocation(imageId: imageId, issueId: issueId, imageIndex: imageIndex):
            reportNavigateToImageLocation(imageId: imageId, issueId: issueId, imageIndex: imageIndex, locationInsight: currentState.locationInsight)
            return .empty()

        case let .navigateToLocation(sideEffect: sideEffect):
            guard let location = currentState.selectedLocation,
                  let url = getLocationUrl(latitude: location.latitude, longitude: location.longitude) else { return Observable.just(Mutation.unChange) }
            sideEffect(url)
            return Observable.just(Mutation.unChange)
        case .initLocationData:
            let locationInsight = currentState.locationInsight
            if !locationInsight.isRead {
                updateUserParamsUsecase.changeInsightReadStatus(insight: locationInsight, isRead: true)
            }
            return locationsFromInsightUsecase.locations(forInsightUID: locationInsight.uid)
                .observeOn(scheduler)
                .compactMap { [weak self] in
                    guard let self = self else { return nil }
                    let galleryImages = self.caluculateLocationImagesGallery(byLocations: $0, forIssueIndex: self.currentState.selectedLocationCardIndex, forInsight: locationInsight)
                    return Mutation.setLocationData(locations: $0, images: galleryImages)
                }
        case .analyticsInsightView:
            reportInsightView()
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLocationData(locations, images):
            return state.with {
                $0.allLocations = locations
                $0.singleIssueGalleryImages = images
            }

        case let .setIsFieldOwner(isFieldOwner):
            return state.with {
                $0.isFieldOwner = isFieldOwner
            }

        case let .setLocationIssueGallery(images):
            var newState: State = state
            newState.singleIssueGalleryImages = images
            return newState

        case let .setSelectedIssueImageIndex(index):
            var newState: State = state
            newState.selectedSingleIssueImageIndex = index
            return newState

        case let .setSelectedCardIndex(index: index):
            var newState: State = state
            newState.selectedLocationCardIndex = index
            return newState

        case let .setShowWalkThrough(show):
            return state.with {
                $0.showWalkThrough = show
            }
        case .unChange:
            return state
        }
    }

    private func getLocationUrl(latitude: Double?, longitude: Double?) -> URL? {
        guard let latitude = latitude,
              let longitude = longitude,
              let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(String(latitude)),\(String(longitude))") else { return nil }
        return url
    }

    private func getLocation(byImage image: LocationImageMeatadata) -> (lat: Double, lon: Double)? {
        guard let lat = image.lat, let lon = image.long else { return nil }
        return (lat, lon)
    }

    private func caluculateLocationImagesGallery(byLocations locations: [Location]?, forIssueIndex index: Int, forInsight insight: LocationInsight) -> [LocationImageMeatadata] {
        return singleIssueCardProvider.provide(imageGalleryByLocations: locations, forIssueIndex: index, forInsight: insight)
    }

    private func reportInsightView() {
        let locationInsight = currentState.locationInsight
        let analyticsParams = [
            EventParamKey.insightUid: locationInsight.uid,
            EventParamKey.fieldId: "\(locationInsight.fieldId)",
            EventParamKey.origin: originScreen,
            EventParamKey.insightType: locationInsight.type,
        ]
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.insight, .insightView, analyticsParams))
    }

    private func reportViewIssueCard(issueIndex _: Int, locationInsight : LocationInsight) {
        guard let selectedIssueItemIndex = currentState.selectedIssueItemIndex else { return }
        let analyticsParams = getAnalyticsParamsForIssueCardReporting(issueIndex: selectedIssueItemIndex, locationInsight: locationInsight)
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.locationIssues, .viewIssueCard, analyticsParams))
    }

    private func reportClickOnIssueCard(issueIndex _: Int, locationInsight : LocationInsight) {
        guard let selectedIssueItemIndex = currentState.selectedIssueItemIndex else { return }
        let analyticsParams = getAnalyticsParamsForIssueCardReporting(issueIndex: selectedIssueItemIndex, locationInsight: locationInsight)
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.locationIssues, .viewIssueCard, analyticsParams))
    }

    private func reportOverview(issueIndex: Int, locationInsight : LocationInsight) {
        let analyticsParams = getAnalyticsParamsForIssueCardReporting(issueIndex: issueIndex, locationInsight: locationInsight)
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.reportOverviewInfo, .buttonClick, analyticsParams))
    }

    private func reportClickOnImageGallery(imageId: Int, issueId: Int, imageIndex: Int, locationInsight : LocationInsight) {
        let analyticsParams = getAnalyticsParamsForImageReporting(imageId: imageId, issueId: issueId, imageIndex: imageIndex, locationInsight: locationInsight)
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.locationIssues, .reportImageClick, analyticsParams))
    }

    private func reportViewLocationImage(imageId: Int, issueId: Int, imageIndex: Int, locationInsight : LocationInsight) {
        let analyticsParams = getAnalyticsParamsForImageReporting(imageId: imageId, issueId: issueId, imageIndex: imageIndex, locationInsight: locationInsight)
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.locationIssues, .viewLocationImage, analyticsParams))
    }

    private func reportZoomOnLocationImage(imageId: Int, issueId: Int, imageIndex: Int, locationInsight : LocationInsight) {
        let analyticsParams = getAnalyticsParamsForImageReporting(imageId: imageId, issueId: issueId, imageIndex: imageIndex, locationInsight: locationInsight)
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.locationIssues, .zoomOnLocationImage, analyticsParams))
    }

    private func reportNavigateToImageLocation(imageId: Int, issueId: Int, imageIndex: Int, locationInsight : LocationInsight) {
        let analyticsParams = getAnalyticsParamsForImageReporting(imageId: imageId, issueId: issueId, imageIndex: imageIndex, locationInsight: locationInsight)
        EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.locationIssues, .navigateToImageLocation, analyticsParams))
    }

    private func getAnalyticsParamsForImageReporting(imageId: Int, issueId: Int, imageIndex: Int, locationInsight : LocationInsight) -> [String: String] {
        return [
            EventParamKey.imageIndex: "\(imageIndex)",
            EventParamKey.insightUid: locationInsight.uid,
            EventParamKey.fieldId: "\(locationInsight.fieldId)",
            EventParamKey.insightType: locationInsight.type,
            EventParamKey.issueId: "\(issueId)",
            EventParamKey.imageId: "\(imageId)",
        ]
    }

    private func getAnalyticsParamsForIssueCardReporting(issueIndex: Int, locationInsight : LocationInsight) -> [String: String] {
        return [
            EventParamKey.insightUid: locationInsight.uid,
            EventParamKey.fieldId: "\(locationInsight.fieldId)",
            EventParamKey.insightType: locationInsight.type,
            EventParamKey.issueName: locationInsight.items[issueIndex].name,
            EventParamKey.issueId: "\(locationInsight.items[issueIndex].id)",
            EventParamKey.presentedIndex: "\(issueIndex)",
            EventParamKey.totalItems: "\(locationInsight.items.count)",
        ]
    }
}
