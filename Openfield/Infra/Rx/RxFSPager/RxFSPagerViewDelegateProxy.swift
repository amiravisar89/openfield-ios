//
//  RxFSPagerViewDelegateProxy.swift
//  ytxIos
//
//  Created by x j z l on 2019/9/26.
//  Copyright © 2019 spectator. All rights reserved.
//

import Foundation
import FSPagerView
import RxCocoa
import RxSwift

extension FSPagerView: HasDelegate {
    public typealias Delegate = FSPagerViewDelegate
}

public extension Reactive where Base: FSPagerView {
    var delegate: DelegateProxy<FSPagerView, FSPagerViewDelegate> {
        return RxFSPagerViewDelegateProxy.proxy(for: base)
    }
}

open class RxFSPagerViewDelegateProxy: DelegateProxy<FSPagerView, FSPagerViewDelegate>, DelegateProxyType, FSPagerViewDelegate {
    public static func registerKnownImplementations() {
        register { RxFSPagerViewDelegateProxy(pagerView: $0) }
    }

    public private(set) weak var pagerView: FSPagerView?

    public init(pagerView: ParentObject) {
        self.pagerView = pagerView
        super.init(parentObject: pagerView, delegateProxy: RxFSPagerViewDelegateProxy.self)
    }
}
