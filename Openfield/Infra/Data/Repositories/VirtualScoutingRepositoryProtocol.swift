//
//  VirtualScoutingRepositoryProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 18/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol VirtualScoutingRepositoryProtocol {
    
    func getDates(fieldId: Int, cycleId: Int, limit: Int?) -> Observable<[VirtualScoutingDateServerModel]>
    func getGrid(gridId: String) -> Observable<VirtualScoutingGridServerModel>
    func getImages(cellId: Int) -> Observable<[VirtualScoutingImage]>
    
}
