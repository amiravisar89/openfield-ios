//
//  FarmFilterProtocol.swift
//  Openfield
//
//  Created by amir avisar on 19/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol FarmFilterProtocol {
    var farms: BehaviorSubject<[FilteredFarm]> { get }
    func selectFarms(farms: [FilteredFarm])
    func resetFarms()
}
