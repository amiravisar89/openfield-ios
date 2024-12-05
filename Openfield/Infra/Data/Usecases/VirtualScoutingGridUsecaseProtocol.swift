//
//  VirtualScoutingGridUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 17/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol VirtualScoutingGridUsecaseProtocol {
    
    func getGrid(gridId: String) -> Observable<VirtualScoutingGrid>
}
