//
//  GetHighlightsForFieldsUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 28/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol GetHighlightsForFieldsUseCaseProtocol {
    func highlights(limit : Int?, fromDate: Date?) -> Observable<[HighlightItem]>
}
