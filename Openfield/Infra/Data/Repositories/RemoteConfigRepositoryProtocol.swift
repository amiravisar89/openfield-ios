//
//  RemoteConfigRepositoryProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol RemoteConfigRepositoryProtocol {
    func fetch() -> Completable
    
    func dictionary(forKey key: String) -> [String: Any]
    func bool(forKey key: RemoteConfigParameterKey) -> Bool
    func string(forKey key: RemoteConfigParameterKey) -> String
    func data(forKey key: RemoteConfigParameterKey) -> Data
    func int(forKey key: RemoteConfigParameterKey) -> Int
    func dictionary(forKey key: RemoteConfigParameterKey) -> [String: Any]
    func double(forKey key: RemoteConfigParameterKey) -> Double
    func getDefaultValue<T>(forKey key: String) -> T?
}
