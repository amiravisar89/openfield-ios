//
//  VirtualScoutingDatesUseCase.swift
//  Openfield
//
//  Created by Yoni Luz on 17/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class VirtualScoutingDatesUseCase : VirtualScoutingDatesUseCaseProtocol {
    
    let virtualScoutingRepository: VirtualScoutingRepositoryProtocol
    let virtualScoutingModelsMapper: VirtualScoutingModelsMapper
    
    init(virtualScoutingRepository: VirtualScoutingRepositoryProtocol, virtualScoutingModelsMapper: VirtualScoutingModelsMapper) {
        self.virtualScoutingRepository = virtualScoutingRepository
        self.virtualScoutingModelsMapper = virtualScoutingModelsMapper
    }
    
    func getDates(fieldId: Int, cycleId: Int, limit: Int? = nil) -> Observable<[VirtualScoutingDate]> {
        return virtualScoutingRepository.getDates(fieldId: fieldId, cycleId: cycleId, limit: limit).map { dates in
            dates.map { self.virtualScoutingModelsMapper.map(virtualScoutingDateServerModel: $0) }
        }
    }

}
