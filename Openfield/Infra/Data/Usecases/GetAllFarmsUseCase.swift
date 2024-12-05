//
//  GetAllFarmsUseCase.swift
//  Openfield
//
//  Created by amir avisar on 21/10/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//


import Foundation
import RxSwift
import Dollar

class GetAllFarmsUseCase: GetAllFarmsUseCaseProtoocol {
    
    private let fieldsUseCase: FieldsUsecaseProtocol
    
    init (fieldsUseCase: FieldsUsecaseProtocol) {
        self.fieldsUseCase = fieldsUseCase
    }
    
    func farms() -> Observable<[Farm]> {
        return fieldsUseCase.getFieldsWithoutImages().map { fields in
            var farms = [Farm]()
            let fieldsByFarm = Dollar.groupBy(fields) { field -> (String) in
                field.farmName
            }
            for (farmName, fields) in fieldsByFarm {
                let farmId = fields.first?.farmId ?? 0
                farms.append(Farm(id: farmId, name: farmName, fieldIds: fields.compactMap { $0.id }, type: .defaultFarm))
            }
            return farms
        }
    }
    
}
