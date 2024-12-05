//
//  RemoteConfigRepo.swift
//  Openfield
//
//  Created by Yoni Luz on 02/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import CodableFirebase
import FirebaseRemoteConfig
import Foundation
import RxSwift

class RemoteConfigRepository: RemoteConfigRepositoryProtocol {
    
    private let jsonDecoder: JSONDecoder
    private let remoteConfig: RemoteConfig
    
    private let updateInterval: TimeInterval = 60 * 60 * 12
    
    init(remoteConfig: RemoteConfig, jsonDecoder: JSONDecoder) {
        self.jsonDecoder = jsonDecoder
        self.remoteConfig = remoteConfig
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = ConfigEnvironment.isDebugMode ? 0 : updateInterval
        setDefaults()
        remoteConfig.configSettings = settings
    }
    
    func fetch() -> Completable {
        let completeable = Completable.create(subscribe: { [weak self] completeable in
            guard let self = self else {
                completeable(.completed)
                return Disposables.create {}
            }
          
            var duration: TimeInterval = ConfigEnvironment.isDebugMode ? 0 : self.updateInterval
          
            self.remoteConfig.fetch(withExpirationDuration: duration) { status, error in
                if let error = error {
                  log.error("Fetched config not activatedd: \(error.localizedDescription)")
                  completeable(.error(error))
                  return
                }
                if status == .success {
                    log.info("Config fetched")
                    self.remoteConfig.activate(completion: { _, error in
                        if error != nil {
                            log.error("Fetched config not activated: \(error?.localizedDescription ?? "No error available.")")
                        }
                        completeable(.completed)
                    })
                } else {
                    log.error("Config not fetched: \(error?.localizedDescription ?? "No error available.")")
                    completeable(.completed)
                }
            }

            return Disposables.create {}
        })
        return completeable
    }
    
    private func setDefaults() {
        remoteConfig.setDefaults(fromPlist: R.file.remoteConfigDefaultsPlist.name)
    }
    
    func dictionary(forKey key: String) -> [String: Any] {
        return remoteConfig[key].jsonValue as! [String: Any]
    }
    
    func bool(forKey key: RemoteConfigParameterKey) -> Bool {
        return remoteConfig[key.rawValue].boolValue
    }

    func string(forKey key: RemoteConfigParameterKey) -> String {
        return remoteConfig[key.rawValue].stringValue
    }

    func data(forKey key: RemoteConfigParameterKey) -> Data {
        return remoteConfig[key.rawValue].dataValue
    }

    func int(forKey key: RemoteConfigParameterKey) -> Int {
        return remoteConfig[key.rawValue].numberValue.intValue
    }

    func dictionary(forKey key: RemoteConfigParameterKey) -> [String: Any] {
        return remoteConfig[key.rawValue].jsonValue as! [String: Any]
    }

    func double(forKey key: RemoteConfigParameterKey) -> Double {
        return remoteConfig[key.rawValue].numberValue.doubleValue
    }
    
    func getDefaultValue<T>(forKey key: String) -> T? {
        guard let plistURL = R.file.remoteConfigDefaultsPlist(),
              let plistData = try? Data(contentsOf: plistURL),
              let plistDict = try? PropertyListSerialization.propertyList(from: plistData, format: nil) as? [String: Any] else {
            log.error("Faild to load RemoteConfigDefault key: \(key)")
            return nil
        }
        return plistDict[key] as? T
    }
    
}
