//
//  FieldsUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 11/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

// Define a protocol for the FieldsUsecase
protocol FieldsUsecaseProtocol {
    
    func getFieldsWithoutImages() -> Observable<[Field]>
    func getFieldsWithImages(imagesFromDate: Date) -> Observable<[Field]>
}
