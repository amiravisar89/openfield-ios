//
//  GetVersionsLimitUseCaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

protocol GetVersionsLimitUseCaseProtocol {
    func force() -> Int
    func soft() -> Int
}
