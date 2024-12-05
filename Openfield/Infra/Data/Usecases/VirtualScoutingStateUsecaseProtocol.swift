//
//  VirtualScoutingStateUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 11/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol VirtualScoutingStateUsecaseProtocol {
    func getVirtualScoutingState(field: Field, selectedSeasonOrder: Int) -> Observable<VirtualScoutingState>

}

enum VirtualScoutingState {
    case enabled
    case disabled
    case hidden
}
