//
//  GetHighlightsUseCaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 10/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol GetHighlightsUseCaseProtocol {
  func highlights(limit: Int?, fromDate: Date?) -> Observable<[Highlight]>
  func highlights() -> Observable<[SectionHighlightItem]>
  func highlights(byFieldId: Int, byCategory: String) -> Observable<[SectionHighlightItem]>
  func insightsToHighlights(insights: Observable<[Insight]>) -> Observable<[Highlight]>
}
