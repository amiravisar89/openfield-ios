//
//  RemoteConfig+Injection.swift
//  Openfield
//
//  Created by amir avisar on 19/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Resolver
import FirebaseRemoteConfig

extension Resolver {
    static func registerRemoteConfig() {
        register {
            RemoteConfigRepository(remoteConfig: RemoteConfig.remoteConfig(), jsonDecoder: resolve())
        }.scope(application)
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetImagesIntervalSinceNowUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetInsightIntervalSinceNowUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetHighlightItemsLimitUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetHighlightDaysLimitUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetFieldIrrigationLimitUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetShapeFileUrlUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            let insightConfigMapper : InsightConfigurationModellMapper = resolve()
            return GetSupportedInsightUseCase(remoteconfigRepository: remoteConfigRepository, jsonDecoder: resolve(), insightConfigurationlMapper: insightConfigMapper)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            let roleConfigMapper : UserRoleConfigurationModellMapper = resolve()
            return GetUserRolesUseCase(remoteconfigRepository: remoteConfigRepository, jsonDecoder: resolve(), roleConfigMapper: roleConfigMapper)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            let unitByCountryModelMapper : UnitByCountryModelMapper = resolve()
            return GetUnitByCountryUseCase(remoteconfigRepository: remoteConfigRepository, jsonDecoder: resolve(), unitByCountryMapper: unitByCountryModelMapper)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            let contractMapper : ContracsMapper = resolve()
            return GetContractsUseCase(remoteconfigRepository: remoteConfigRepository, jsonDecoder: resolve(), contractsMapper: contractMapper)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetRequestReportStartYearUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetVirtualScoutingStartYearUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetImagesGalleryImageSizeUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetFeedMinDateUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetVersionsLimitUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetSubscriptionPopupDataUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetOptionalPopUpDaysTimeIntervalUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetSupportUrlUseCase(remoteconfigRepository: remoteConfigRepository)
        }
      
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetHelpCenterUrlUseCase(remoteconfigRepository: remoteConfigRepository)
        }
        
        register {
            let remoteConfigRepository : RemoteConfigRepository = resolve()
            return GetRequestReportUrlUseCase(remoteconfigRepository: remoteConfigRepository)
        }
                
    }
}

