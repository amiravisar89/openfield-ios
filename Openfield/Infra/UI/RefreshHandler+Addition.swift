//
//  RefreshHandler+Addition.swift
//  Openfield
//
//  Created by Daniel Kochavi on 04/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import NVActivityIndicatorView
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class RefreshHandler: NSObject {
    let refresh = PublishSubject<Void>()
    let refreshControl = UIRefreshControl()
    init(view: UIScrollView) {
        super.init()
        refreshControl.addTarget(self, action: #selector(refreshControlDidRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .clear
        refreshControl.subviews.first?.alpha = 0
        let indicator = NVActivityIndicatorView(frame: refreshControl.bounds, type: .circleStrokeSpin, color: R.color.valleyBrand(), padding: 0)
        indicator.backgroundColor = refreshControl.backgroundColor
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        refreshControl.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.center.equalTo(refreshControl)
        }
        view.addSubview(refreshControl)
    }

    // MARK: - Action

    @objc func refreshControlDidRefresh(_: UIRefreshControl) {
        refresh.onNext(())
    }

    func end() {
        refreshControl.endRefreshing()
    }
}

extension Reactive where Base: RefreshHandler {
    var isRefreshing: Binder<Bool> {
        return Binder(base) { handler, isRefreshing in
            if !isRefreshing {
                handler.end()
            }
        }
    }
}
