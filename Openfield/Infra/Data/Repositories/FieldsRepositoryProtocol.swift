//
//  FieldsRepositoryProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 09/01/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase
import RxSwift

protocol FieldsRepositoryProtocol {
    
    func fieldsStream() -> Observable<[FieldServerModel]>
    
    func imagesStream(whereDateGreaterThanOrEqualTo fromDate: Date) -> Observable<[FieldImageServerModel]>
    
    func fieldsLastReadStream() -> Observable<[FieldLastReadServerModel]>
    func updateFieldLastRead(id: Int, lastRead: FieldLastRead?) -> Observable<Void>
}

