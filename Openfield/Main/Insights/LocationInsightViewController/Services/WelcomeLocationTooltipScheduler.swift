//
//  WelcomeLocationTooltipScheduler.swift
//  Openfield
//
//  Created by dave bitton on 28/02/2021.
//  Copyright © 2021 Prospera. All rights reserved.
//

import EasyTipView
import RxSwift
import UIKit

class WelcomeLocationTooltipScheduler {
    struct Tip {
        let text: String
        let view: UIView
    }

    struct State {
        var stepWillBeDisplayAtIndex: Int?
        var stepDidHideAtIndex: Int?
    }

    private struct TipStep {
        let text: String
        let tipView: EasyTipView
        weak var relatedView: UIView?

        func show() {
            guard let view = relatedView else { return }
            tipView.show(forView: view)
        }

        func hide() {
            tipView.dismiss()
        }
    }

    lazy var tipPreferences: EasyTipView.Preferences = {
        var tipPreferences = EasyTipView.Preferences()
        tipPreferences.drawing.arrowPosition = .bottom
        tipPreferences.drawing.arrowHeight = 5
        tipPreferences.drawing.backgroundColor = R.color.valleyDarkBrand()!
        tipPreferences.drawing.font = R.font.avertaRegular(size: 13)!
        return tipPreferences
    }()

    private var walkThroughSteps = [TipStep]()
    private(set) var currentTipStepIndex = -1
    private(set) var currentState = State(stepWillBeDisplayAtIndex: nil, stepDidHideAtIndex: nil) {
        didSet {
            state.onNext(currentState)
        }
    }

    var state: BehaviorSubject<State>

    init() {
        state = BehaviorSubject(value: currentState)
    }

    func initWalkthrough(withSteps steps: [Tip]) {
        guard !steps.isEmpty else { return }
        walkThroughSteps = steps.map {
            let view = EasyTipView(text: $0.text, preferences: self.tipPreferences, delegate: self)
            return TipStep(text: $0.text, tipView: view, relatedView: $0.view)
        }
        currentTipStepIndex = -1
    }

    func showNextTip() {
        currentTipStepIndex += 1
        guard currentTipStepIndex < walkThroughSteps.count else { return }
        currentState.stepWillBeDisplayAtIndex = currentTipStepIndex
        walkThroughSteps[currentTipStepIndex].show()
        PassThroughScreenOverlay.addToKeyWindow {
            self.walkThroughSteps[self.currentTipStepIndex].hide()
        }
    }
}

extension WelcomeLocationTooltipScheduler: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_: EasyTipView) {
        currentState.stepDidHideAtIndex = currentTipStepIndex
    }

    func easyTipViewDidTap(_: EasyTipView) {}
}
