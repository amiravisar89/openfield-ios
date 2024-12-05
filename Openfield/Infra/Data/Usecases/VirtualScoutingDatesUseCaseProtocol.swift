//
//  VirtualScoutingDatesUseCaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 17/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol VirtualScoutingDatesUseCaseProtocol {
    
    func getDates(fieldId: Int, cycleId: Int, limit: Int?) -> Observable<[VirtualScoutingDate]>
    
}

extension VirtualScoutingDatesUseCaseProtocol {
    func getDates(fieldId: Int, cycleId: Int) -> Observable<[VirtualScoutingDate]> {
        return getDates(fieldId: fieldId, cycleId: cycleId, limit: nil)
    }
}
