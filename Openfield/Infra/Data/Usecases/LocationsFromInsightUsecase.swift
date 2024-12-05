//
//  LocationsFromInsightUsecase.swift
//  Openfield
//
//  Created by amir avisar on 11/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase
import RxSwift

class LocationsFromInsightUsecase: LocationsFromInsightUsecaseProtocol {
    
    private let jsonDecoder: JSONDecoder
    private let insightsRepo: InsightsRepositoryProtocol
    private let locationsMapper: LocationModelMapper
    
    init(jsonDecoder: JSONDecoder, insightsRepo : InsightsRepositoryProtocol, locationsMapper: LocationModelMapper) {
        self.jsonDecoder = jsonDecoder
        self.insightsRepo = insightsRepo
        self.locationsMapper = locationsMapper
    }
    
    func locations(forInsightUID insightUID: String) -> Observable<[Location]> {
        let attachmentsStream = insightsRepo.locations(forInsightUID: insightUID)
        let resultSream = attachmentsStream.map {
            try $0.map { insightAttachmentServerModel -> [Location] in
                try insightAttachmentServerModel.items.compactMap { [weak self] item -> Location? in
                    guard let self = self else {
                        log.error("Error - Repository dont exist")
                        throw ParsingError(description: "Repository dont exist")
                    }
                    if item.type != "location" { // Only supported item type
                        return nil
                    }
                    guard let data = item.data.data(using: .utf8) else {
                        log.error("Could not decode data to utf8. insight uid - \(insightUID)")
                        return nil
                    }
                    do {
                        let locationDetailServerModel = try self.jsonDecoder.decode(LocationDetailServerModel.self, from: data)
                        return try self.locationsMapper.map(locationDetailServerModel: locationDetailServerModel)
                    } catch {
                        log.error("Could not parse location data for insight uid - \(insightUID), with error - \(error)")
                        return nil
                    }
                }.compactMap { $0 }
            }.flatMap { $0 }
        }
        return resultSream
    }
    
}
