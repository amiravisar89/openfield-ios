//
//  AnimationsProvider.swift
//  Openfield
//
//  Created by amir avisar on 15/08/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Foundation
import RxSwift

class AnimationProvider {
    func animate(duration: TimeInterval, delay: TimeInterval, animations: @escaping () -> Void) -> Observable<Void> {
        return Observable<Void>.create { observer in
            UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: animations) { _ in
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
