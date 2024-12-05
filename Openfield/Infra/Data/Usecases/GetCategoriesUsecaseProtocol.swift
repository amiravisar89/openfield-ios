//
//  GetCategoriesUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 12/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol GetCategoriesUsecaseProtocol {
    
    func categories(fieldId: Int) -> Observable<[InsightCategory]>
    func categoriesBySeason(field: Field, selectedSeasonOrder: Int) -> Observable<[InsightCategory]>
}
