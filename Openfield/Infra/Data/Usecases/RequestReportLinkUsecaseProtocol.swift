//
//  RequestReportLinkUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 29/05/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol RequestReportLinkUsecaseProtocol {
    
    func getRequestReportLink(field: Field, selectedSeasonOrder: Int) -> Observable<URL?>
}
