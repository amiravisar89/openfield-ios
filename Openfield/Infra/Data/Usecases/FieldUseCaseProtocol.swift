//
//  FieldUseCaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 23/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol FieldUseCaseProtocol {
    
    func getFieldWithImages(fieldId: Int) -> Observable<Field>
    func getFieldWithoutImages(fieldId: Int) -> Observable<Field>
    func getFieldWithLastImage(fieldId: Int) -> Observable<Field>
    func getFilteredFieldWithImages(fieldId: Int, criteria: [FilterCriterion]) -> Observable<Field>
}
