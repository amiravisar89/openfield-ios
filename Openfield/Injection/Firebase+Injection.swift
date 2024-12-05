//
//  Firebase+Injection.swift
//  Openfield
//
//  Created by Daniel Kochavi on 13/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Firebase
import Resolver

extension Resolver {
    static func registerFirebase() {
        register { _, _ -> Firestore in
            let settings = FirestoreSettings()
            settings.isPersistenceEnabled = true
            let db = Firestore.firestore()
            db.settings = settings
            return db
        }.scope(application)

        register { AuthInteractor(extUserMapper: resolve()) }.scope(application)
        register {
          let updateUserParamsUseCase : UpdateUserParamsUsecase = resolve()
          return FirebaseAppDelegateService(updateUserParamsUsecase: updateUserParamsUseCase)
        }.scope(application)
    }
}
