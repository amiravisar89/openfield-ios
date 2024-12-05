//
//  WelcomInsightsUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 28/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift
protocol WelcomInsightsUsecaseProtocol {
    
    func insights() -> Observable<[Insight]>
}
