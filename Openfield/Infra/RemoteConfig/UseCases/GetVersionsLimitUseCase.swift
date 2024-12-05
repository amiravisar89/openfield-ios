//
//  GetVersionsLimitUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

class GetVersionsLimitUseCase: GetVersionsLimitUseCaseProtocol {
    let remoteconfigRepository: RemoteConfigRepositoryProtocol
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol) {
        self.remoteconfigRepository = remoteconfigRepository
    }
    
    func force() -> Int {
        return remoteconfigRepository.int(forKey: .iosMinForceVersion)
    }
    
    func soft() -> Int {
        return remoteconfigRepository.int(forKey: .iosMinSoftVersion)
    }
}
