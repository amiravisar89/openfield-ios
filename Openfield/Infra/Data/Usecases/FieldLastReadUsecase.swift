//
//  FieldLastReadUseCase.swift
//  Openfield
//
//  Created by Yoni Luz on 02/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class FieldLastReadUsecase  {
    
    private let fieldsRepo: FieldsRepositoryProtocol
    private let fieldLastReadMapper: FieldLastReadMapper
    
    init(fieldsRepo: FieldsRepositoryProtocol, fieldLastReadMapper: FieldLastReadMapper) {
        self.fieldsRepo = fieldsRepo
        self.fieldLastReadMapper = fieldLastReadMapper
    }
    
    func fieldsLastReadStream() -> Observable<[Int:FieldLastRead]> {
        let fieldsLastReadStream = fieldsRepo.fieldsLastReadStream()
        return fieldsLastReadStream.map { list in
            var map = [Int: FieldLastRead]()
            list.forEach { item in
                if let fieldId = item.fieldId {
                    map[Int(fieldId)!] = self.fieldLastReadMapper.map(serverModel: item)
                }
            }
            return map
        }
        
    }
    
    func updateFieldLastRead(id: Int, lastRead: FieldLastRead?) -> Observable<Void> {
        return fieldsRepo.updateFieldLastRead(id: id, lastRead: lastRead)
    }
    
}
