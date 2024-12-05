//
//  UserStreamUsecase.swift
//  Openfield
//
//  Created by Yoni Luz on 08/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class UserStreamUsecase: UserStreamUsecaseProtocol {
    
    private let userRepository: UserRepositoryProtocol
    private let userMapper: UserModelMapper
    
    
    init (userRepository: UserRepositoryProtocol, userMapper: UserModelMapper) {
        self.userRepository = userRepository
        self.userMapper = userMapper
    }
    
  func userStream() -> Observable<Openfield.User> {
        return userRepository.createUserStream().compactMap { (userSM: UserServerModel) -> User in
            self.userMapper.map(userServerModel: userSM)
        }
    }
  
}
