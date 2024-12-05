//
//  FieldRepository.swift
//  Openfield
//
//  Created by Yoni Luz on 23/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase
import RxSwift

class FieldRepository: FieldRepositoryProtocol {
    
    // Collections
    private let fieldsCollectionName = "fields"
    private let insightsCollectionName = "insights"
    private let imagesCollectionName = "images"
    
    // Fields
    private let usersFieldName = "users"
    private let imagesFieldDate = "date"
    private let fieldIdField = "field_id"
    private let id = "id"
    private let ndviLayer = "layers.ndvi"
    
    private var userID: Int
    private let db: Firestore
    private let decoder: FirestoreDecoder
    
    private let queue = ConcurrentDispatchQueueScheduler(qos: .utility)
    
    init(userID: Int, db: Firestore, decoder: FirestoreDecoder) {
        self.userID = userID
        self.db = db
        self.decoder = decoder
    }
    
    private var fieldsCollectionRef: CollectionReference {
        db.collection(fieldsCollectionName)
    }
    
    private var fieldsBaseQuery: Query {
        fieldsCollectionRef
            .whereField(usersFieldName, arrayContains: userID)
    }
    
    func fieldStream(fieldId: Int) -> Observable<FieldServerModel> {
        return fieldsCollectionRef.document(String(fieldId)).fetchSingle(decoder: decoder).share(replay: 1).observeOn(queue)
    }
    
    private var fieldImagesBaseQuery: Query {
        db.collection(imagesCollectionName)
            .whereField(usersFieldName, arrayContainsAny: [userID])
            .order(by: imagesFieldDate, descending: false)
    }
    
    func imagesStream(fieldId: Int) -> Observable<[FieldImageServerModel]> {
        return fieldImagesBaseQuery.whereField(fieldIdField, isEqualTo: fieldId).fetchList(decoder: decoder).ifEmpty(default: []).share(replay: 1).observeOn(queue)
    }
    
    func imagesStreamByFieldFilter(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[FieldImageServerModel]> {
        let observables = criteria.compactMap { criterion -> Observable<[FieldImageServerModel]>? in
            guard criterion.collection == imagesCollectionName else {
                return nil
            }
            
            var insightQuery = fieldImagesBaseQuery
                .whereField(fieldIdField, isEqualTo: fieldId)
            criterion.filterBy.forEach { filterItem in
                insightQuery = insightQuery.whereField(filterItem.property, isEqualTo: filterItem.value.valueAsAny)
            }
            
            return insightQuery.fetchList(decoder: decoder)
        }
        
        return Observable.merge(observables).observeOn(queue)
    }
    
    func lastImageStream(fieldId: Int) -> Observable<[FieldImageServerModel]> {
        return fieldImagesBaseQuery
            .whereField(fieldIdField, isEqualTo: fieldId)
            .order(by: imagesFieldDate, descending: true)
            .order(by: ndviLayer, descending: true)
            .limit(to: 1)
            .fetchList(decoder: decoder)
            .observeOn(queue)
    }
    
}
