//
//  GetFieldImageryUsecase.swift
//  Openfield
//
//  Created by amir avisar on 14/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class GetFieldImageryUsecase : GetFieldImageryUsecaseProtocol{
    
    private let fieldRepo: FieldRepositoryProtocol
    private let fieldMapper: FieldModelMapper
    let fieldUseCase : FieldUseCaseProtocol
    
    init (fieldRepo: FieldRepositoryProtocol, fieldMapper: FieldModelMapper, fieldUseCase : FieldUseCaseProtocol) {
        self.fieldRepo = fieldRepo
        self.fieldMapper = fieldMapper
        self.fieldUseCase = fieldUseCase
    }
    
    func fieldImages(fieldId: Int) -> Observable<[FieldImage]> {
        let fieldStream = fieldUseCase.getFieldWithImages(fieldId: fieldId)
        return getListOfFieldImages(fieldStream: fieldStream)
    }
    
    func fieldImagesWithFilter(field: Field, selectedSeasonOrder: Int) -> Observable<[FieldImage]> {
        guard let latestFilter = field.filters.first(where: { $0.order == selectedSeasonOrder } ) else {
            return Observable.just([])
        }
        let fieldStream = fieldUseCase.getFilteredFieldWithImages(fieldId: field.id, criteria: latestFilter.criteria)
        return getListOfFieldImages(fieldStream: fieldStream)
    }
    
    private func getListOfFieldImages(fieldStream: Observable<Field>) -> Observable<[FieldImage]> {
        return fieldStream.map { field in
            guard let latestImageGroup = field.latestFieldImageGroup(),
                  let layeredImages = latestImageGroup.imagesByLayer[AppImageType.ndvi],
                  let layeredImage = layeredImages.first else {return []}
            let image = AppImage(height: layeredImage.height, width: layeredImage.width, url: layeredImage.url)
            return [FieldImage(imageId: layeredImage.imageId, image: image, date: latestImageGroup.date)]
        }
    }
}
