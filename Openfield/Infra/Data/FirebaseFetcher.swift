//
//  FirebaseFetcher.swift
//  Openfield
//
//  Created by Yoni Luz on 15/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import RxSwift

extension Query {
    
    func fetchList<T: Decodable>(decoder: FirestoreDecoder, source: FirestoreSource = .default, function: StaticString = #function) -> Observable<[T]> {
        let traceIdentifier = "network_request_\(String(describing: function))"
        return Observable<[T]>.create { observer in
            PerformanceManager.shared.startTrace(for: traceIdentifier)
            let listener = self.addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    log.error("\(function) failed with error: \(error)")
                    PerformanceManager.shared.stopTrace(for: traceIdentifier)
                    observer.onError(error)
                    return
                }
                
                if let querySnapshot = querySnapshot {
                    log.debug("\(function) success")
                    PerformanceManager.shared.stopTrace(for: traceIdentifier)
                    let result: [T] = querySnapshot.toObjects(decoder: decoder)
                    observer.onNext(result)
                }
            }
            return Disposables.create {
                // Cleanup, remove the listener when the observer is disposed
                listener.remove()
                PerformanceManager.shared.stopTrace(for: traceIdentifier)
            }
        }
    }
    
    
}

extension DocumentReference {
    func fetchSingle<T: Decodable>(decoder: FirestoreDecoder, source: FirestoreSource = .server, function: StaticString = #function) -> Observable<T> {
        return Observable.create { observer in

            let listener = self.addSnapshotListener { (documentSnapshot, error) in
                if let error = error {
                    log.error("\(function) failed with error: \(error)")
                    observer.onError(error)
                    return
                }
                
                if let document = documentSnapshot {
                    if let item: T = document.toObject(decoder: decoder) {
                        log.debug("\(function) success")
                        observer.onNext(item)
                    } else {
                        //TODO: emit error here and fix the issues follows
                        log.error("\(function) failed")
                    }
                }
            }
            
            return Disposables.create {
                // Cleanup, remove the listener when the observer is disposed
                listener.remove()
            }
        }
    }
}
