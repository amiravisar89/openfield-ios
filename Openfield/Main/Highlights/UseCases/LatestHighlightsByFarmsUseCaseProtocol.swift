//
//  LatestHighlightsByFarmsUseCaseProtocol.swift
//  Openfield
//
//  Created by Amitai Efrati on 12/08/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol LatestHighlightsByFarmsUseCaseProtocol {
  func getHighlightsForFarms(
    limit: Int?,
    fromDate: Date?,
    fieldsIds: [Int]
  ) -> Observable<[HighlightItem]>
}
