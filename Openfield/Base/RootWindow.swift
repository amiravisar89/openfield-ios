//
//  RootWindow.swift
//  LottoMatic
//
//  Created by amir avisar on 14/01/2022.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift
import RxViewController

class RootWindow: UIWindow {
    let disposeBag = DisposeBag()

    convenience init(rootVc: BaseNavigationViewController) {
        self.init(frame: UIScreen.main.bounds)
        rootViewController = rootVc
        frame = UIScreen.main.bounds
        backgroundColor = R.color.white()

        rootVc.rx.didShow.subscribe { (viewController: UIViewController, _: Bool) in
            viewController.generateAccessibilityIdentifiers()
        }.disposed(by: disposeBag)
    }
}
