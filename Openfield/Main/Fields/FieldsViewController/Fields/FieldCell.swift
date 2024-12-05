//
//  FieldCell.swift
//  Openfield
//
//  Created by amir avisar on 27/05/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation

struct FieldsListSection: SectionModel {
  var items: [FieldElement]
  var type: FieldsListSectionType
  var id: String
  var header: FieldHeader?

  static func == (lhs: FieldsListSection, rhs: FieldsListSection) -> Bool {
    return lhs.identity == rhs.identity
  }
}

extension FieldsListSection: AnimatedSectionModelType {
  var identity: String { return id }

  init(original: FieldsListSection, items: [FieldElement]) {
    self = original
    self.items = items
  }
}

struct FieldElement: AnimatableModel {
  var type: FieldItem
  var identity: Int

  static func == (lhs: FieldElement, rhs: FieldElement) -> Bool {
    switch (lhs.type, rhs.type) {
    case let (.fieldCellContent(fieldCellContent: fieldCellContentA), .fieldCellContent(fieldCellContent: fieldCellContentB)):
      return fieldCellContentA.field.id == fieldCellContentB.field.id
    case let (.fieldHighlightContent(fieldHighlightContent: fieldHighlightContentA), .fieldHighlightContent(fieldHighlightContent: fieldHighlightContentB)):
      return fieldHighlightContentA.highlights.compactMap { $0.identity } == fieldHighlightContentB.highlights.compactMap { $0.identity }
    default:
      return false
    }
  }
}

enum FieldItem {
  case fieldCellContent(fieldCellContent: FieldCellContent)
  case fieldHighlightContent(fieldHighlightContent: FieldHighlightsContent)
  case loadingCell
}

struct FieldHeader {
  let leftTitle: String
  let rightTitle: String
}

struct FieldHighlightsContent {
  let highlights: [HighlightItem]
}

struct FieldCellContent {
  let field: Field
  let latestImage: String?
  let report: FieldsListReactor.FieldCellReport
  let fieldLastRead: FieldLastRead?
}

enum FieldsListSectionType: String {
  case fields
  case highlights
}

extension FieldCellContent: Equatable {
  static func == (lhs: FieldCellContent, rhs: FieldCellContent) -> Bool {
    return lhs.field.id == rhs.field.id &&
    lhs.field.dateUpdated == rhs.field.dateUpdated &&
    lhs.field.farmId == rhs.field.farmId &&
    lhs.field.name == rhs.field.name &&
    lhs.field.farmName == rhs.field.farmName &&
    lhs.latestImage == rhs.latestImage &&
    lhs.fieldLastRead == rhs.fieldLastRead
  }
}
