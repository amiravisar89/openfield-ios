//
//  GetImageryUsecase.swift
//  Openfield
//
//  Created by amir avisar on 21/10/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift
import Dollar

class GetImageryUsecase: GetImageryUsecaseProtocol {
    
    private let fieldsUseCase: FieldsUsecaseProtocol
    private let getFeedMinDateUseCase : GetFeedMinDateUseCaseProtocol
    
    init (fieldsUseCase: FieldsUsecaseProtocol, getFeedMinDateUseCase : GetFeedMinDateUseCaseProtocol) {
        self.fieldsUseCase = fieldsUseCase
        self.getFeedMinDateUseCase = getFeedMinDateUseCase
    }
    
    func imageries() -> Observable<[Imagery]> {
        return fieldsUseCase.getFieldsWithImages(imagesFromDate: getFeedMinDateUseCase.date()).map { fields in
            var imageries = [Imagery]()
            var fieldById = [Int: Field]()
            fields.forEach { field in
                fieldById[field.id] = field
            }
            
            let imageGroups = fields.flatMap { field -> [FieldImageGroup] in
                field.imageGroups
            }
            
            let imageGroupsByDate = Dollar.groupBy(imageGroups) { imageGroup -> (String) in
                String(format: "%d %d", imageGroup.date.weekInYearNum, imageGroup.date.year)
            }
            
            for (_, imageGroups) in imageGroupsByDate {
                let currentWeekImages = imageGroups.map { ImageryImage(url: $0.imageryMainImage, date: $0.date, region: $0.region, layer: $0.imageryMainType, field: fieldById[$0.fieldId]!) }.sorted(by: { $0.date > $1.date })
                
                let images: [ImageryImage] = Dollar.uniq(currentWeekImages) { $0.field.id }
                guard let latestImage = images.min(by: { $0.date > $1.date }) else {
                    continue
                }
                imageries.append(Imagery(images: images, date: latestImage.date, region: latestImage.date.region, isRead: true))
            }
            return imageries
        }
    }
    
}
