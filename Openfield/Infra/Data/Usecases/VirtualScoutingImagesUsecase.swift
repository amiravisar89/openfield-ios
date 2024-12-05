//
//  virtualScoutingImagesUsecase.swift
//  Openfield
//
//  Created by Yoni Luz on 26/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class VirtualScoutingImagesUsecase: VirtualScoutingImagesUsecaseProtocol {
    
    let virtualScoutingRepository: VirtualScoutingRepositoryProtocol
    
    init(virtualScoutingRepository: VirtualScoutingRepositoryProtocol) {
        self.virtualScoutingRepository = virtualScoutingRepository
    }

    func getImages(cellId: Int) -> Observable<[VirtualScoutingImage]> {
        return virtualScoutingRepository.getImages(cellId: cellId)
    }
}
