//
//  IntentTransitioner.swift
//  Openfield
//
//  Created by Daniel Kochavi on 01/02/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import Resolver
import RxSwift
import SwiftyUserDefaults

enum Intent {
    case insight(insightUID: String, origin: NavigationOrigin)
    case imagery(date: Date, origin: NavigationOrigin)
    case home
}

class IntentTransitioner {
    weak var rootFlowController: RootFlowController!
    let disposeBag: DisposeBag = .init()
    let singleInsightUseCase: GetSingleInsightUsecase = Resolver.resolve()

    init(rootFlowController: RootFlowController) {
        self.rootFlowController = rootFlowController
    }

    func handleIntent(_ intent: Intent?, afterLogin _: Bool) {
        guard let intent = intent else { return }
        switch intent {
        case let .imagery(date, origin):
            navigateToImagery(date: date, origin: origin)
        case let .insight(insightUID, origin):
            AnalyticsMeasure.sharedInstance.start(label: Events.openToInsight.rawValue)
            navigateToInsight(insightUID: insightUID, origin: origin)
        case .home:
            rootFlowController.mainFlowController.goToIboxTab()
        }
    }

    func navigateToInsight(insightUID: String, origin: NavigationOrigin) {
        rootFlowController.mainFlowController.showLoaderOnContainer()
        singleInsightUseCase.insight(byUID: insightUID).observeOn(MainScheduler.instance).take(1).subscribe { [weak self] insight in
            guard let self = self else { return }
            self.rootFlowController.mainFlowController.hideLoaderOnContainer()
            if let insight = insight as? LocationInsight {
                self.rootFlowController.mainFlowController.goToLocationInsight(insightUid: insight.uid, category: insight.category, subCategory: insight.subCategory, fieldId: insight.fieldId, cycleId: insight.cycleId, publicationYear: insight.publicationYear, origin: origin)
            } else if insight is IrrigationInsight {
                self.rootFlowController.mainFlowController.goToIrrigationInsight(insightUid: insightUID, origin: origin)
            } else {
                log.error("Error - insightId \(insightUID) type is not supported")
                self.rootFlowController.mainFlowController.naviagteToErrorScreen()
            }
        } onError: { err in
            self.rootFlowController.mainFlowController.hideLoaderOnContainer()
            log.error("Error - \(err.localizedDescription) for insightId \(insightUID)")
            self.rootFlowController.mainFlowController.naviagteToErrorScreen()
        }.disposed(by: disposeBag)
    }

    func navigateToImagery(date: Date, origin: NavigationOrigin) {
        rootFlowController.mainFlowController.goToImageryPopup(imageryDate: date, animated: false, origin: origin)
    }
}
