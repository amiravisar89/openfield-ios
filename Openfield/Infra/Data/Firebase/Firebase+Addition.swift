//
//  Firebase+Addition.swift
//  Openfield
//
//  Created by Daniel Kochavi on 12/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import CodableFirebase
import Firebase

extension DocumentSnapshot {
    func toObject<T: Decodable>(decoder: FirestoreDecoder) -> T? {
        let theData: [String: Any]? = data()
        guard let unwrappedData = theData else { return nil }
        do {
            let object = try decoder.decode(T.self, from: unwrappedData)
            return object
        } catch {
            log.error("Object of type: \(T.self) with ID: \(String(describing: unwrappedData["id"])) could not be parsed with error: \(error)")
            return nil
        }
    }
}

extension QuerySnapshot {
    func toObjects<T: Decodable>(decoder: FirestoreDecoder) -> [T] {
        let objects: [T] = documents.compactMap { $0.toObject(decoder: decoder) }
        return objects.isEmpty ? [] : objects
    }
}

// The following extensions make Firebase custom objects comply with the Decodable protocol
extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}
