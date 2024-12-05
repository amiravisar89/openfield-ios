//
//  GetFieldIrrigationUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 14/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol GetFieldIrrigationUsecaseProtocol {
    func irrigations(field: Field, selectedSeasonOrder: Int) -> Observable<[FieldIrrigation]>
}
