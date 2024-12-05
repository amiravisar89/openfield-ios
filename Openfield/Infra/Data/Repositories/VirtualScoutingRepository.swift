//
//  VirtualScoutingRepository.swift
//  Openfield
//
//  Created by Yoni Luz on 18/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase
import RxSwift

class VirtualScoutingRepository : VirtualScoutingRepositoryProtocol {
    
    private let vsDatesCollection = "grid-imagery-daily-dates"
    private let vsGridCollection = "grid-imagery-grids"
    private let vsImagesCollection = "grid-imagery-images"
    
    private let fieldIdfield = "field_id"
    private let cycleIdField = "cycle_id"
    private let dayField = "day"
    private let gridCellIdField = "grid_cell_id"
    
    private var userID: Int
    private let db: Firestore
    private let decoder: FirestoreDecoder
    
    private let queue = ConcurrentDispatchQueueScheduler(qos: .utility)
    
    init(userID: Int, db: Firestore, decoder: FirestoreDecoder) {
        self.userID = userID
        self.db = db
        self.decoder = decoder
    }
    
    func getDates(fieldId: Int, cycleId: Int, limit: Int?) -> Observable<[VirtualScoutingDateServerModel]> {
        var query = db.collection(vsDatesCollection)
            .whereField(fieldIdfield, isEqualTo: fieldId)
            .whereField(cycleIdField, isEqualTo: cycleId)
            .order(by: dayField)
        if let limit = limit {
            query = query.limit(toLast: limit)
        }
        return query.fetchList(decoder: decoder).share(replay: 1)
            .observeOn(queue)
    }
    
    func getGrid(gridId: String) -> Observable<VirtualScoutingGridServerModel> {
        return db.collection(vsGridCollection)
            .document(gridId)
            .fetchSingle(decoder: decoder)
    }
    
    func getImages(cellId: Int) -> Observable<[VirtualScoutingImage]> {
        return db.collection(vsImagesCollection)
            .whereField(gridCellIdField, isEqualTo: cellId)
            .fetchList(decoder: decoder).share(replay: 1)
            .observeOn(queue)
    }
    
}
