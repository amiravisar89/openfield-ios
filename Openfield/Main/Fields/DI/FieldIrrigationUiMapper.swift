//
//  FieldInsightsCellUiElement.swift
//  Openfield
//
//  Created by amir avisar on 14/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

class FieldIrrigationUiMapper {
    
    private var dateProvider: DateProvider
    private let getFieldIrrigationLimitUseCase : GetFieldIrrigationLimitUseCaseProtocol


    init(dateProvider: DateProvider, getFieldIrrigationLimitUseCase : GetFieldIrrigationLimitUseCaseProtocol) {
        self.dateProvider = dateProvider
        self.getFieldIrrigationLimitUseCase = getFieldIrrigationLimitUseCase
    }
    
    func irrigation(fieldIrrigation: FieldIrrigation) -> FieldIrrigationUiElement {
        let insightLimit = getFieldIrrigationLimitUseCase.fieldIrrigationLimit()
        let prefixInsight = Array(fieldIrrigation.insights.prefix(insightLimit))
        let btnVisible = fieldIrrigation.insights.count > insightLimit
        let items = prefixInsight.enumerated().compactMap { index, irrigationInsight -> FieldIrrigationItemUiElement? in
            guard let mainImage = irrigationInsight.mainImage else {return nil}
            let images = mainImage.previews.map({ previewImage in
                return AppImage(height: previewImage.height, width: previewImage.width, url: previewImage.url)
            })

            let content = "\(String(format: "%.2f", irrigationInsight.affectedArea)) \(irrigationInsight.affectedAreaUnit) \(R.string.localizable.insightAffected())"
            return FieldIrrigationItemUiElement(insightUid: irrigationInsight.uid, title: irrigationInsight.subject, content: content, date: dateProvider.daysTimeAgoSince(irrigationInsight.publishDate), images: images, read: irrigationInsight.isRead, bottomLineVisible: btnVisible || prefixInsight.count - 1 != index)
        }
        return FieldIrrigationUiElement(title: R.string.localizable.fieldIrrigationInsights(), buttonTitle: R.string.localizable.fieldSeeAllIrrigationInsights(), items: items, btnVisible: btnVisible)
    }

}
