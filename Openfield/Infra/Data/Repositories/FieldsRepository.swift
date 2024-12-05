//
//  FirebaseFieldsRepository.swift
//  Openfield
//
//  Created by Yoni Luz on 28/12/2023.
//  Copyright © 2023 Prospera. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase
import RxSwift

class FieldsRepository: FieldsRepositoryProtocol {
    
    // Collections
    private let fieldsCollectionName = "fields"
    private let imagesCollectionName = "images"
    private let usersCollectionName = "users"
    private let fieldsLastReadCollectionName = "fields_last_read"
    // Fields
    private let usersFieldName = "users"
    private let imagesFieldDate = "date"
    private let userFieldTsReadKey = "ts_read"
    private let userFieldTsFirstReadKey = "ts_first_read"
    private let fieldId = "field_id"
    
    private var userID: Int
    private let db: Firestore
    private let decoder: FirestoreDecoder
    
    private let queue = ConcurrentDispatchQueueScheduler(qos: .utility)
    
    init(userID: Int, db: Firestore, decoder: FirestoreDecoder) {
        self.userID = userID
        self.db = db
        self.decoder = decoder
    }
    
    
    private var fieldsBaseQuery: Query {
        db.collection(fieldsCollectionName)
            .whereField(usersFieldName, arrayContains: userID)
    }
    
    func fieldsStream() -> Observable<[FieldServerModel]> {
        return fieldsBaseQuery.fetchList(decoder: decoder).share(replay: 1).observeOn(queue)
    }
        
    private var fieldImagesBaseQuery: Query {
        db.collection(imagesCollectionName)
            .whereField(usersFieldName, arrayContainsAny: [userID])
    }
    
    func imagesStream(whereDateGreaterThanOrEqualTo fromDate: Date) -> Observable<[FieldImageServerModel]> {
        return fieldImagesBaseQuery
            .order(by: imagesFieldDate)
            .start(at:[fromDate])
            .fetchList(decoder: decoder).share(replay: 1)
            .observeOn(queue)
    }
    
    func imagesStream(fieldId: Int) -> Observable<[FieldImageServerModel]> {
        return fieldImagesBaseQuery
            .whereField(self.fieldId, isEqualTo: fieldId)
            .fetchList(decoder: decoder)
            .observeOn(queue)
    }
        
    private var userBaseQuery: DocumentReference {
        db.collection(usersCollectionName)
            .document(String(userID))
    }
    
    private var fieldLastReadBaseQuery: CollectionReference {
        userBaseQuery.collection(fieldsLastReadCollectionName)
    }
    
    func fieldsLastReadStream() -> Observable<[FieldLastReadServerModel]> {
        let liveStream = Observable<[FieldLastReadServerModel]>.create { observer in
            let listener = self.fieldLastReadBaseQuery.addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                if let querySnapshot = querySnapshot {
                    log.info("Fetching data from Firebase")
                    let result = querySnapshot.documents.compactMap { document in
                        do {
                            var fieldLastReport: FieldLastReadServerModel? = try document.data(as: FieldLastReadServerModel.self)
                            fieldLastReport?.fieldId = document.documentID
                            print("\(document.documentID) => \(document.data())")
                            return fieldLastReport
                        } catch {
                            print("Error getting documents: \(error)")
                            return nil
                        }
                    }
                    observer.onNext(result)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
        
        return liveStream.share(replay: 1).observeOn(queue)
    }
    
    
    func updateFieldLastRead(id: Int, lastRead: FieldLastRead?) -> Observable<Void> {
        let now = Date()
        let lastReadServerModel : [String: Any] = [
            userFieldTsReadKey: Timestamp(date: now),
            userFieldTsFirstReadKey: Timestamp(date: lastRead?.tsFirstRead ?? now)
        ]
        return Observable.create { observer in
            self.fieldLastReadBaseQuery.document(String(id)).setData(lastReadServerModel, merge: true) { error in
                if let error = error {
                    log.error("failed to update the field: \(id), last read updated to \(lastReadServerModel)")
                    observer.onError(error)
                } else {
                    log.info("field: \(id) last read updated to \(lastReadServerModel)")
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }.observeOn(queue)
    }
    
}
