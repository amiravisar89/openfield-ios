//
//  GetImageryUsecaseProtocol.swift
//  Openfield
//
//  Created by amir avisar on 21/10/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import RxSwift

protocol GetImageryUsecaseProtocol {
    func imageries() -> Observable<[Imagery]>
}
