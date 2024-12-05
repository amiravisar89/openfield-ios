//
//  FieldsUsecase.swift
//  Openfield
//
//  Created by Yoni Luz on 01/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class FieldsUsecase: FieldsUsecaseProtocol {
    
    private let fieldsRepo: FieldsRepositoryProtocol
    private let fieldMapper: FieldModelMapper
        
    init(fieldsRepo: FieldsRepositoryProtocol, fieldMapper: FieldModelMapper) {
        self.fieldsRepo = fieldsRepo
        self.fieldMapper = fieldMapper
    }
    
    func getFieldsWithImages(imagesFromDate: Date = Date(timeIntervalSince1970: 0)) -> Observable<[Field]> {
        let fieldStream = fieldsRepo.fieldsStream()
        let imagesStream = fieldsRepo.imagesStream(whereDateGreaterThanOrEqualTo: imagesFromDate)
        return Observable.combineLatest(fieldStream, imagesStream) { fields, images in
            fields.map { fieldServerModel -> Field in
                let fieldImages = images.filter { $0.field_id == fieldServerModel.id }
                return self.fieldMapper.map(fieldServerModel: fieldServerModel, imagesServerModel: fieldImages)
            }
        }
    }
    
    func getFieldsWithoutImages() -> Observable<[Field]> {
        return fieldsRepo.fieldsStream().map { fieldStream in
            return fieldStream.map { fieldServerModel -> Field in
                return self.fieldMapper.map(fieldServerModel: fieldServerModel, imagesServerModel: [FieldImageServerModel]())
            }
        }
    }
  
    
}
