//
//  InsightsRepository.swift
//  Openfield
//
//  Created by Yoni Luz on 15/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import CodableFirebase
import Firebase
import Foundation
import RxSwift

class InsightsRepository: InsightsRepositoryProtocol {
  private let maximumComparisonValuesForInOperator = 30

  // Collections
  private let insightsCollectionName = "insights"
  private let attachmentCollectionName = "attachments"

  // Fields
  private let uidFieldName = "uid"
  private let usersFieldName = "users"
  private let fieldIdFieldName = "field_id"
  private let categoryFieldName = "category"
  private let insightsCollectionTsPublish = "ts_published"
  private let highlightsFieldName = "highlight"
  private let cycleIdFieldName = "cycle_id"
  private let publicationYearFieldName = "publication_year"

  private var userID: Int
  private let db: Firestore
  private let decoder: FirestoreDecoder

  private let queue = ConcurrentDispatchQueueScheduler(qos: .utility)

  init(userID: Int, db: Firestore, decoder: FirestoreDecoder) {
    self.userID = userID
    self.db = db
    self.decoder = decoder
  }

  private var insightsCollectionRef: CollectionReference {
    db.collection(insightsCollectionName)
  }

  private var welcomeInsightBaseQuery: Query {
    insightsCollectionRef
      .whereField(usersFieldName, arrayContainsAny: [0])
  }

  private var insightsBaseQuery: Query {
    insightsCollectionRef
      .whereField(usersFieldName, arrayContainsAny: [userID])
      .order(by: insightsCollectionTsPublish, descending: false)
  }

  func insightsStream(whereDateGreaterThanOrEqualTo fromDate: Date, limit: Int?, onlyHighlights: Bool) -> Observable<[InsightServerModel]> {
    var query = insightsBaseQuery
    if onlyHighlights {
      query = query.order(by: highlightsFieldName)
    }
    query = query.start(at: [fromDate])
    if let limit = limit {
      query = query.limit(toLast: limit)
    }
    return query.fetchList(decoder: decoder).share(replay: 1).observeOn(queue)
  }

  func insightsStreamByFarms(
    whereDateGreaterThanOrEqualTo fromDate: Date,
    limit: Int?,
    onlyHighlights: Bool,
    fieldsIds: [Int]
  ) -> Observable<[InsightServerModel]> {
    let chunkedFieldsIds = stride(from: 0, to: fieldsIds.count, by: maximumComparisonValuesForInOperator).map {
      Array(fieldsIds[$0 ..< min($0 + maximumComparisonValuesForInOperator, fieldsIds.count)])
    }

    let observables = chunkedFieldsIds.map { chunk -> Observable<[InsightServerModel]> in
      var query = insightsBaseQuery
      query = query.whereField(fieldIdFieldName, in: chunk)

      if onlyHighlights {
        query = query.order(by: highlightsFieldName)
      }

      query = query.start(at: [fromDate])

      if let limit = limit {
        query = query.limit(toLast: limit)
      }

      return query.fetchList(decoder: decoder)
        .observeOn(queue)
    }

    return Observable.combineLatest(observables)
      .map { resultsArray in
        let allInsights = resultsArray.flatMap { $0 }
        let sortedInsights = allInsights.sorted(by: {
          guard let date1 = $0.ts_published?.dateValue(), let date2 = $1.ts_published?.dateValue() else {
            return $0.ts_published != nil
          }
          return date1 > date2
        })
        return limit != nil ? Array(sortedInsights.prefix(limit!)) : sortedInsights
      }
      .share(replay: 1)
      .observeOn(queue)
  }

  func welcomeInsightStream() -> Observable<[InsightServerModel]> {
    return welcomeInsightBaseQuery.fetchList(decoder: decoder).share(replay: 1).observeOn(queue)
  }

  func locations(forInsightUID insightUID: String) -> Observable<[InsightAttachmentServerModel]> {
    let attachmentsDocumentsRef = db.collection(insightsCollectionName).document(insightUID).collection(attachmentCollectionName)
    return attachmentsDocumentsRef.fetchList(decoder: decoder).share(replay: 1).observeOn(queue)
  }

  func insight(byUID uid: String) -> Observable<InsightServerModel?> {
    return insightsCollectionRef.document(String(uid)).fetchSingle(decoder: decoder).share(replay: 1).observeOn(queue)
  }

  func insightsStream(byFieldId: Int? = nil, byCategory: String? = nil, onlyHighlights: Bool, cycleId: Int? = nil, publicationYear: Int? = nil) -> Observable<[InsightServerModel]> {
    var insightQuery = insightsBaseQuery
    if onlyHighlights {
      insightQuery = insightQuery.order(by: highlightsFieldName)
    }
    if let byFieldId = byFieldId {
      insightQuery = insightQuery.whereField(fieldIdFieldName, isEqualTo: byFieldId)
    }
    if let byCategory = byCategory {
      insightQuery = insightQuery.whereField(categoryFieldName, isEqualTo: byCategory)
    }
    if let cycleId = cycleId {
      insightQuery = insightQuery.whereField(cycleIdFieldName, isEqualTo: cycleId)
    } else if let publicationYear = publicationYear {
      insightQuery = insightQuery.whereField(publicationYearFieldName, isEqualTo: publicationYear)
    }
    return insightQuery.fetchList(decoder: decoder).share(replay: 1).observeOn(queue)
  }

  func insightsStreamFilteredByCriteria(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[InsightServerModel]> {
    let observables = criteria.compactMap { criterion -> Observable<[InsightServerModel]>? in

      guard criterion.collection == insightsCollectionName else {
        return nil
      }

      var insightQuery = insightsBaseQuery
        .whereField(fieldIdFieldName, isEqualTo: fieldId)
      criterion.filterBy.forEach { filterItem in
        insightQuery = insightQuery.whereField(filterItem.property, isEqualTo: filterItem.value.valueAsAny)
      }

      return insightQuery.fetchList(decoder: decoder)
    }

    return observables.isEmpty ? .just([]) : Observable.combineLatest(observables)
      .map { resultsArray in
        resultsArray.flatMap { $0 }
      }.observeOn(queue)
  }
}
