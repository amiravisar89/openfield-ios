//
//  VirtualScoutingGridUsecase.swift
//  Openfield
//
//  Created by Yoni Luz on 17/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class VirtualScoutingGridUsecase : VirtualScoutingGridUsecaseProtocol {
    
    let virtualScoutingRepository: VirtualScoutingRepositoryProtocol
    let virtualScoutingModelsMapper: VirtualScoutingModelsMapper
    
    init(virtualScoutingRepository: VirtualScoutingRepositoryProtocol, virtualScoutingModelsMapper: VirtualScoutingModelsMapper) {
        self.virtualScoutingRepository = virtualScoutingRepository
        self.virtualScoutingModelsMapper = virtualScoutingModelsMapper
    }
    
    func getGrid(gridId: String) -> Observable<VirtualScoutingGrid> {
        return virtualScoutingRepository.getGrid(gridId: gridId).map {
            self.virtualScoutingModelsMapper.map(virtualScoutingGridServerModel: $0)
        }
    }
}
