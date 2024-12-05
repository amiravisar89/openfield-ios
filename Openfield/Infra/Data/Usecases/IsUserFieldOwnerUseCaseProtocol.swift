//
//  IsUserFieldUseCaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 11/04/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol IsUserFieldOwnerUseCaseProtocol {
    func isUserField(fieldId : Int) -> Observable<Bool>
}
