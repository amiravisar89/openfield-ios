//
//  GetSingleInsightUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 12/02/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol GetSingleInsightUsecaseProtocol {
    func insight(byUID uid: String) -> Observable<Insight?>
}
