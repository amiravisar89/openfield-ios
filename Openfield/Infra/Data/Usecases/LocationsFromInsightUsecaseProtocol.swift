//
//  LocationsFromInsightUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 11/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol LocationsFromInsightUsecaseProtocol {
    func locations(forInsightUID insightUID: String) -> Observable<[Location]>
}
