//
//  FirebaseUserRepository.swift
//  Openfield
//
//  Created by Yoni Luz on 01/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

import CodableFirebase
import Dollar
import Firebase
import RxSwift
import SwiftDate
import SwiftyUserDefaults

class UserRepository: UserRepositoryProtocol {
    
    private var userID: Int
    private let decoder: FirestoreDecoder
    private let db: Firestore
    private let queue = ConcurrentDispatchQueueScheduler(qos: .utility)
    private let usersCollectionName = "users"
    
    private var userBaseQuery: DocumentReference {
        db
            .collection(usersCollectionName)
            .document(String(userID))
    }
    
    init(userID: Int, db: Firestore, decoder: FirestoreDecoder) {
        self.userID = userID
        self.db = db
        self.decoder = decoder
    }
    
    func createUserStream() -> Observable<UserServerModel> {
      return userBaseQuery.fetchSingle(decoder: decoder).observeOn(queue).share(replay: 1)
    }
}
