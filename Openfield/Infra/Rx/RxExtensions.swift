//
//  RxExtensions.swift
//  Openfield
//
//  Created by Itay Kaplan on 28/12/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    func castAndFilterType<T>(_: T.Type) -> Observable<T> {
        return map { $0 as? T }.compactMap { $0 }
    }
}

extension ObservableType where Element: Sequence {
    func castAndFilterElementsInSequence<T>(_: T.Type) -> Observable<[T]> {
        return map { $0.filter { $0 is T }.map { $0 as! T } }
    }
}
