//
//  GetUserRolesUseCase.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

class GetUserRolesUseCase: GetUserRolesUseCaseProtocol {
    
    private let remoteconfigRepository: RemoteConfigRepositoryProtocol
    private let roleConfigMapper: UserRoleConfigurationModellMapper
    private let jsonDecoder: JSONDecoder
    
    init(remoteconfigRepository: RemoteConfigRepositoryProtocol, jsonDecoder: JSONDecoder, roleConfigMapper: UserRoleConfigurationModellMapper) {
        self.remoteconfigRepository = remoteconfigRepository
        self.jsonDecoder = jsonDecoder
        self.roleConfigMapper = roleConfigMapper
    }
    
    func roles() -> [UserRoleConfiguration] {
        let userRoleServerModel = remoteconfigRepository.data(forKey: .user_roles)
        do {
            let userRoleServerModel = try jsonDecoder.decode([UserRoleConfigurationServerModel].self, from: userRoleServerModel)
            return try roleConfigMapper.map(UserRoleServerModel: userRoleServerModel)
        } catch {
            reportCrashlytics()
            log.error("Could not retreive role configuration from Firebase Remote Config, Error: \(error)")
            return [UserRoleConfiguration]()
        }
    }
    
    private func reportCrashlytics(){
        Crashlytics.crashlytics().record(error: AppErrors.RemoteConfigErrors.valueError)
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
