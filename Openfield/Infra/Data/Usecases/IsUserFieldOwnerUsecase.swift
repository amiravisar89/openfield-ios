//
//  IsUserFieldUseCase.swift
//  Openfield
//
//  Created by amir avisar on 11/04/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class IsUserFieldOwnerUsecase: IsUserFieldOwnerUseCaseProtocol {

    private var fieldRepo: FieldRepositoryProtocol
    
    init(fieldRepo: FieldRepositoryProtocol) {
        self.fieldRepo = fieldRepo
    }
    
    func isUserField(fieldId: Int) -> Observable<Bool> {
        fieldRepo.fieldStream(fieldId: fieldId).map{_ in true}.catchError { error in
            if error.localizedDescription == AppErrors.FirebaseErrors.noPermissions.detail {
                return Observable.just(false)
            } else {return Observable.just(true)}
        }
    }
    
   
}
