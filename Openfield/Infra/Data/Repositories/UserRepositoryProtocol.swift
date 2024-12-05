//
//  UserRepositoryProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 09/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol UserRepositoryProtocol {
    
    func createUserStream() -> Observable<UserServerModel>
}
