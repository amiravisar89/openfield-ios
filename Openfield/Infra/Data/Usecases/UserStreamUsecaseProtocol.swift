//
//  UserStreamUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

// Define a protocol for the UserStreamUsecase
protocol UserStreamUsecaseProtocol {
  func userStream() -> Observable<Openfield.User>
}
