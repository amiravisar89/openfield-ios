//
//  Field.swift
//  Openfield
//
//  Created by Daniel Kochavi on 27/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Foundation
import SwiftDate

struct Field: Hashable {
    let id: Int
    let country: String
    let name: String
    let farmName: String
    let dateUpdated: Date
    let imageGroups: [FieldImageGroup]
    let coverImage: SpatialImage?
    let region: Region
    let farmId: Int
    let filters: [FieldFilter]
    let subscriptionTypes: [String]?

    static let empty = Field(id: 0, country: "", name: "", farmName: "", dateUpdated: Date(), imageGroups: [], coverImage: nil, region: Region.local, farmId: 0, filters: [], subscriptionTypes: [])

    func latestFieldImageGroup() -> FieldImageGroup? {
        if let latestRgb: FieldImageGroup = imageGroups.last(where: { (fieldImageGroup: FieldImageGroup) -> Bool in
            fieldImageGroup.imageryMainType == .rgb
        }) {
            return latestRgb
        }

        if let latestNdvi: FieldImageGroup = imageGroups.last(where: { (fieldImageGroup: FieldImageGroup) -> Bool in
            fieldImageGroup.imageryMainType == .ndvi
        }) {
            return latestNdvi
        }

        if let latestThermal: FieldImageGroup = imageGroups.last(where: { (fieldImageGroup: FieldImageGroup) -> Bool in
            fieldImageGroup.imageryMainType == .thermal
        }) {
            return latestThermal
        }
        return imageGroups.last
    }

    func latestAvailableLayerFieldImageGroup() -> FieldImageGroup? {
        return imageGroups.last { fieldImageGroup -> Bool in
            !fieldImageGroup.imagesByLayer.isEmpty
        }
    }
}

struct FieldImageGroup: Hashable {
    let fieldId: Int
    let fieldName: String
    let imageryMainImage: String
    let imageryMainType: AppImageType
    let date: Date
    let bounds: ImageBounds
    let imagesByLayer: [AppImageType: [PreviewImage]]
    let region: Region
    let sourceType: ImageSourceType
}

struct FieldFilter: Hashable {
    let order: Int
    let name: String
    let criteria: [FilterCriterion]
}

struct FilterCriterion: Hashable {
    let collection: String
    let filterBy: [FilterBy]
}

struct FilterBy: Hashable {
    let property: String
    let value: DynamicValue
}

enum ImageSourceType: String, CaseIterable, Hashable {
    case plane
    case satellite

    func name() -> String {
        switch self {
        case .satellite:
            return R.string.localizable.satelliteType()
        case .plane:
            return R.string.localizable.airplaneType()
        }
    }
}

class ImageGroupHash: Hashable {
    var dateOnly: String!

    init(dateOnly: String) {
        self.dateOnly = dateOnly
    }

    static func == (lhs: ImageGroupHash, rhs: ImageGroupHash) -> Bool {
        return lhs.dateOnly == rhs.dateOnly
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(dateOnly)
    }
}

enum SubscriptionType: String {
    case ValleyInsightsPanda = "ValleyInsightsPanda"
}

extension Field {

    func getCycleId(forSelectedOrder selectedSeasonOrder: Int) -> Int? {
        let filter = filters.first(where: { $0.order == selectedSeasonOrder})
        return (filter?.criteria.compactMap { criteria in
            if let filterByCycle = criteria.filterBy.first(where: { $0.property == "cycle_id"} ) {
                return filterByCycle.value.valueAsAny as? Int
            } else {
                return nil
            }
        }.first)
    }

    func getPublicationYear(forSelectedOrder selectedSeasonOrder: Int) -> Int? {
        let filter = filters.first(where: { $0.order == selectedSeasonOrder})
        return (filter?.criteria.compactMap { criteria in
            if let filterByCycle = criteria.filterBy.first(where: { $0.property == "publication_year"} ) {
                return filterByCycle.value.valueAsAny as? Int
            } else {
                return nil
            }
        }.first)
    }
}
