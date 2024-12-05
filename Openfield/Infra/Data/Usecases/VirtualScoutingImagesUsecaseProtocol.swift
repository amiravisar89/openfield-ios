//
//  virtualScoutingImagesUsecaseProtocol.swift
//  Openfield
//
//  Created by Yoni Luz on 26/06/2024.
//  Copyright © 2024 Prospera. All rights reserved.
//

import Foundation
import RxSwift

protocol VirtualScoutingImagesUsecaseProtocol {

    func getImages(cellId: Int) -> Observable<[VirtualScoutingImage]>
}
