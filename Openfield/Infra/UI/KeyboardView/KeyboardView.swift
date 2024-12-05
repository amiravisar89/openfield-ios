//
//  KeyboardView.swift
//  Openfield
//
//  Created by Daniel Kochavi on 05/01/2020.
//  Copyright © 2020 Prospera. All rights reserved.
//

import RxSwift
import UIKit

class KeyboardView: UIControl {
    @IBOutlet fileprivate var contentView: UIView!
    @IBOutlet fileprivate var verticalStackView: UIStackView!
    @IBOutlet fileprivate var row1StackView: UIStackView!
    @IBOutlet fileprivate var row2StackView: UIStackView!
    @IBOutlet fileprivate var row3StackView: UIStackView!
    @IBOutlet fileprivate var row4StackView: UIStackView!
    @IBOutlet fileprivate var btn1: SGButton!
    @IBOutlet fileprivate var btn2: SGButton!
    @IBOutlet fileprivate var btn3: SGButton!
    @IBOutlet fileprivate var btn4: SGButton!
    @IBOutlet fileprivate var btn5: SGButton!
    @IBOutlet fileprivate var btn6: SGButton!
    @IBOutlet fileprivate var btn7: SGButton!
    @IBOutlet fileprivate var btn8: SGButton!
    @IBOutlet fileprivate var btn9: SGButton!
    @IBOutlet fileprivate var btn0: SGButton!
    @IBOutlet fileprivate var btnDelete: SGButton!

    fileprivate var rowStacks = [UIStackView]()
    fileprivate var numberButtons = [SGButton]()

    fileprivate var tapKeySubject = PublishSubject<String>()
    fileprivate var tapDeleteSubject = PublishSubject<Void>()

    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        setupView()
    }

    @IBAction func pressedKeypad(_ sender: Any) {
        guard let value: Int = (sender as? UIView)?.tag else { return }
        vibrate()
        switch value {
        case -1:
            EventTracker.track(event: AnalyticsEventFactory.buildClickEvent(EventCategory.keypad, "keypad_backspace"))
            tapDeleteSubject.onNext(())
        case 0 ... 9:
            tapKeySubject.onNext("\(value)")
        default:
            return
        }
    }

    override func awakeFromNib() {
        rowStacks = [row1StackView, row2StackView, row3StackView, row4StackView]
        numberButtons = [btn0, btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9]
        rowStacks.forEach { $0.spacing = 12 }
        verticalStackView.spacing = 9
        setupStaticData()
        setupQAIds()
    }

    private func setupView() {
        UINib(resource: R.nib.keyboardView).instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.masksToBounds = true
        impactFeedbackgenerator.prepare()
    }

    private func setupStaticData() {
        btnDelete.defaultImage = R.image.keyboard_backspace()!
        btnDelete.highlightedImage = R.image.keyboard_backspace()!
        for (index, btn) in numberButtons.enumerated() {
            btn.titleString = "\(index)"
        }
    }

    private func setupQAIds() {
        btnDelete.accessibilityIdentifier = "KeyDelete"
        for (index, btn) in numberButtons.enumerated() {
            btn.accessibilityIdentifier = "Key\(index)"
        }
    }

    private func vibrate() {
        impactFeedbackgenerator.impactOccurred()
    }
}

extension KeyboardView {
    static func instanceFromNib() -> KeyboardView {
        return KeyboardView(frame: CGRect.zero)
    }
}

extension Reactive where Base: KeyboardView {
    var tapKey: Observable<String> {
        return base.tapKeySubject
    }

    var tapDelete: Observable<Void> {
        return base.tapDeleteSubject
    }
}
