//
//  GetFieldImageryUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 14/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol GetFieldImageryUsecaseProtocol {
    func fieldImages(fieldId: Int) -> Observable<[FieldImage]>
    func fieldImagesWithFilter(field: Field, selectedSeasonOrder: Int) -> Observable<[FieldImage]>
}
