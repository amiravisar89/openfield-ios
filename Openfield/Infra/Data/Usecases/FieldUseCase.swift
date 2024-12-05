//
//  FieldUseCase.swift
//  Openfield
//
//  Created by Yoni Luz on 23/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class FieldUseCase: FieldUseCaseProtocol {
    
    private var fieldRepo: FieldRepositoryProtocol
    private var fieldMapper: FieldModelMapper
    
    init(fieldRepo: FieldRepositoryProtocol, fieldMapper: FieldModelMapper) {
        self.fieldRepo = fieldRepo
        self.fieldMapper = fieldMapper
    }
    
    func getFieldWithImages(fieldId: Int) -> Observable<Field> {
        let fieldStream = fieldRepo.fieldStream(fieldId: fieldId)
        let imagesStream = fieldRepo.imagesStream(fieldId: fieldId)
        return Observable.combineLatest(fieldStream, imagesStream) { field, images in
            self.fieldMapper.map(fieldServerModel: field, imagesServerModel: images)
        }
    }
    
    func getFieldWithLastImage(fieldId: Int) -> Observable<Field> {
        let fieldStream = fieldRepo.fieldStream(fieldId: fieldId)
        let imagesStream = fieldRepo.lastImageStream(fieldId: fieldId)
        return Observable.combineLatest(fieldStream, imagesStream) { field, images in
            self.fieldMapper.map(fieldServerModel: field, imagesServerModel: images)
        }
    }
    
    func getFieldWithoutImages(fieldId: Int) -> Observable<Field> {
        let fieldStream = fieldRepo.fieldStream(fieldId: fieldId)
        return fieldStream.map { fieldServerModel -> Field in
            return self.fieldMapper.map(fieldServerModel: fieldServerModel, imagesServerModel: [FieldImageServerModel]())
        }
    }
    
    func getFilteredFieldWithImages(fieldId: Int, criteria: [FilterCriterion]) -> Observable<Field> {
        let fieldStream = fieldRepo.fieldStream(fieldId: fieldId)
        let imagesStream = fieldRepo.imagesStreamByFieldFilter(fieldId: fieldId, criteria: criteria)
        return Observable.combineLatest(fieldStream, imagesStream) { field, images in
            self.fieldMapper.map(fieldServerModel: field, imagesServerModel: images)
        }
        
    }
}
