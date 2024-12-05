//
//  Highlights+injection.swift
//  Openfield
//
//  Created by amir avisar on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Resolver

extension Resolver {
  static func registerHighlights() {
    register { HighlightInsightCardProvider(dateProvider: resolve()) as HighlightsCardsProvider }.scope(application)
    register { _, arg -> HighlightsReactor in
      let args = arg as? [Any]
      let fieldId = args?[0] as? Int
      let categoryId = args?[1] as? String
      let getHighlightsUseCase: GetHighlightsUseCase = resolve()
      let getSupportedInsightUseCase: GetSupportedInsightUseCase = resolve()
      return HighlightsReactor(getHighlightsUseCase: getHighlightsUseCase, getSupportedInsightUseCase: getSupportedInsightUseCase, fieldId: fieldId, categoryId: categoryId)
    }
    register {
      let insightsRepository: InsightsFromDateUsecase = resolve()
      let insightsFromFieldAndCategoryUsecase: InsightsFromFieldAndCategoryUsecase = resolve()
      let locationsFromInsightUsecase: LocationsFromInsightUsecase = resolve()
      let farmFilter: FarmFilter = resolve()
      return GetHighlightsUseCase(insightsFromDateUsecase: insightsRepository, insightsFromFieldAndCategoryUsecase: insightsFromFieldAndCategoryUsecase, locationsFromInsightUsecase: locationsFromInsightUsecase, farmFilter: farmFilter)
    }

    register {
      let getHighlightsUseCase: GetHighlightsUseCase = resolve()
      return GetHighlightsForFieldsUsecase(getHighlightsUseCase: getHighlightsUseCase)
    }
    register {
      let insightsFromDateUseCase: InsightsFromDateUsecase = resolve()
      let getHighlightsUseCase: GetHighlightsUseCase = resolve()
      return LatestHighlightsByFarmsUseCase(insightsFromDateUseCase: insightsFromDateUseCase, getHighlightsUseCase: getHighlightsUseCase)
    }
  }
}
