//
//  FieldServerModel.swift
//  Openfield
//
//  Created by Daniel Kochavi on 27/11/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Firebase
import Foundation

struct FieldServerModel: Decodable {
    let country: String
    let county: String
    let farm_id: Int
    let farm_name: String
    let id: Int
    let is_demo: Bool
    let name: String
    let state: String
    let time_zone: String?
    let cover_image: ImageSpatialServerModel?
    let filters: [FieldFilterServerModel]
    let subscription_types: [String]?
}

struct LayerIssueServerModel: Decodable {
    let comment: String?
    let is_hidden: Bool?
    let issue: String?
}

struct LayerImageServerModel: Decodable {
    let issue: LayerIssueServerModel?
    let previews: [PreviewImageServerModel]
}

struct FieldFilterServerModel: Decodable {
    let order: Int
    let i18n_name: LocalizeString
    let name: String
    let criteria: [FieldFilterCriterionServerModel]
}

struct FieldFilterCriterionServerModel: Decodable {
    let collection: String
    let filter_by: [FieldFilterByServerModel]
}

struct FieldFilterByServerModel: Decodable {
    let property: String
    let value: DynamicValue
}

enum DynamicValue: Decodable, Hashable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let strValue = try? container.decode(String.self) {
            self = .string(strValue)
        } else if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let dblValue = try? container.decode(Double.self) {
            self = .double(dblValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else {
            throw DecodingError.typeMismatch(DynamicValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected to decode String, Int, Double, or Bool"))
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .string(let value):
            hasher.combine(value)
        case .int(let value):
            hasher.combine(value)
        case .double(let value):
            hasher.combine(value)
        case .bool(let value):
            hasher.combine(value)
        }
    }
}

extension DynamicValue {
    var valueAsAny: Any {
        switch self {
        case .string(let value): return value
        case .int(let value): return value
        case .double(let value): return value
        case .bool(let value): return value
        }
    }
}
