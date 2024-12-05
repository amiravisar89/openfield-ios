//
//  DeeplinkingFacade.swift
//  Openfield
//
//  Created by Daniel Kochavi on 31/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation

class DeeplinkingFacade {
    private let intentTransitioner: IntentTransitioner
    private let urlGateway: URLGateway
    private let rootFlowController: RootFlowController

    init(intentTransitioner: IntentTransitioner,
         rootFlowController: RootFlowController)
    {
        self.intentTransitioner = intentTransitioner
        urlGateway = URLGateway()
        self.rootFlowController = rootFlowController
    }

    public func handleDeeplink(_ url: URL, origin: NavigationOrigin) {
        let intent = urlGateway.handleDeeplink(url, analyticsOrigin: origin)
        rootFlowController.intentHandler = intentTransitioner.handleIntent(_:afterLogin:)
        rootFlowController.pendingIntent = intent
    }
}
