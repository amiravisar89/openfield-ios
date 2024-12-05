//
//  AppWalkthroughViewReactor.swift
//  Openfield
//
//  Created by amir avisar on 14/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import ReactorKit
import Resolver
import RxCocoa
import RxSwift
import SwiftyUserDefaults
import Then

class AppWalkthroughViewReactor: Reactor {
    var initialState: State
    let disposeBag = DisposeBag()
    let contractsProvider: TermsOfUseProviderProtocol

    init(contractsProvider: TermsOfUseProviderProtocol) {
        self.contractsProvider = contractsProvider
        let layerCarousel: [AppWalkthroughCellInput] = [
            AppWalkthroughCellInput(layerImage: R.image.walkthroughPage0()!, layerTitle: R.string.localizable.walkthroughWelcomeToValley(), layerContent: R.string.localizable.walkthroughTurningData(), buttonTitle: R.string.localizable.walkthroughGetStarted(), isEnabled: false, showError: false),
            AppWalkthroughCellInput(layerImage: R.image.walkthroughPage1()!, layerTitle: R.string.localizable.walkthroughCaptureFieldImagery(), layerContent: R.string.localizable.walkthroughScanVariousImageTypes(), buttonTitle: R.string.localizable.walkthroughNext(), isEnabled: false, showError: false),
            AppWalkthroughCellInput(layerImage: R.image.walkthroughPage2()!, layerTitle: R.string.localizable.walkthroughDetectIssuesEarly(), layerContent: R.string.localizable.walkthroughUsingArtificialIntelligenceTechnology(), buttonTitle: R.string.localizable.walkthroughNext(), isEnabled: false, showError: false),
            AppWalkthroughCellInput(layerImage: R.image.walkthroughPage3()!, layerTitle: R.string.localizable.walkthroughGetNotified(), layerContent: R.string.localizable.walkthroughReceiveAlertsReports(), buttonTitle: R.string.localizable.done(), isEnabled: false, showError: false),
        ]

        initialState = State(carouselCuruentIndex: .zero, layerCarousel: layerCarousel, isContractSigned: false)
        Observable.just(Action.viewContract).bind(to: action).disposed(by: disposeBag)
    }

    enum Action {
        case nothing
        case viewContract
        case setIsContractSigned(isSigned: Bool)
        case goToContract(type: ContractType, navigation: (Double, Contract) -> Void)
        case setCarouselIndex(index: Int, navigation: () -> Void)
        case showError
    }

    enum Mutation {
        case setIsContractSigned(isSigned: Bool)
        case setCarouselIndex(index: Int)
        case setLayerCarousel(layerCarousel: [AppWalkthroughCellInput])
        case unChange
    }

    struct State: Then {
        var carouselCuruentIndex: Int
        var layerCarousel: [AppWalkthroughCellInput]
        var isContractSigned: Bool
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setIsContractSigned(isSigned: isSigned):

            EventTracker.track(event: AnalyticsEventFactory.buildEvent(EventCategory.contract, .contractAccept, [EventParamKey.contractIsAccept: String(isSigned)]))
            let signedObs = Observable.just(Mutation.setIsContractSigned(isSigned: isSigned))
            let layers = currentState.layerCarousel.map { AppWalkthroughCellInput(layerImage: $0.layerImage, layerTitle: $0.layerTitle, layerContent: $0.layerContent, buttonTitle: $0.buttonTitle, isEnabled: isSigned, showError: false) }
            let setLayersObs = Observable.just(Mutation.setLayerCarousel(layerCarousel: layers))
            return Observable.concat(signedObs, setLayersObs)

        case .showError:
            let layers = currentState.layerCarousel.map { AppWalkthroughCellInput(layerImage: $0.layerImage, layerTitle: $0.layerTitle, layerContent: $0.layerContent, buttonTitle: $0.buttonTitle, isEnabled: $0.isEnabled, showError: true) }
            return Observable.just(Mutation.setLayerCarousel(layerCarousel: layers))

        case let .goToContract(type: type, navigation: navigation):
            guard let contract = contractsProvider.getContract(by: type),
                  let remoteContract = contractsProvider.remoteContracts else { return Observable.empty() }
            navigation(remoteContract.version, contract)
            return Observable.empty()

        case .viewContract:
            let updateContractTrackingObs = contractsProvider.updateContractSeen(tsSeenContract: Date()).map { _ in Mutation.unChange }
            return updateContractTrackingObs

        case let .setCarouselIndex(index: index, navigation: navigation):
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.introCarousel, "intro_lets_start"))
            if index == currentState.layerCarousel.count {
                Defaults.seenAppwalkthrough = Defaults.seenAppwalkthrough + [Defaults.userId]
                guard Defaults.impersonatorId == nil else {
                    navigation()
                    return Observable.empty()
                }
                let signObs = contractsProvider.sign().map { _ in Mutation.unChange }
                navigation()
                return signObs
            } else {
                return Observable.just(Mutation.setCarouselIndex(index: index))
            }
        case .nothing:
          return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setIsContractSigned(isSigned: isSigned):
            return state.with {
                $0.isContractSigned = isSigned
            }
        case let .setLayerCarousel(layerCarousel: layerCarousel):
            return state.with {
                $0.layerCarousel = layerCarousel
            }

        case let .setCarouselIndex(index: index):
            return state.with {
                $0.carouselCuruentIndex = index
            }
        case .unChange:
            return state
        }
    }
}
