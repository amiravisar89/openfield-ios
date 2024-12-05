//
//  FieldRepositoryProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 23/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol FieldRepositoryProtocol {
    
    func fieldStream(fieldId: Int) -> Observable<FieldServerModel>
    
    func imagesStream(fieldId: Int) -> Observable<[FieldImageServerModel]>
    
    func imagesStreamByFieldFilter(fieldId: Int, criteria: [FilterCriterion]) -> Observable<[FieldImageServerModel]>
    
    func lastImageStream(fieldId: Int) -> Observable<[FieldImageServerModel]>
    
}
